# Failure Taxonomy

Walk **every** category below against the scenario's execution path. For each
prompt, ask: *can this happen on this path, and what would it do?* Skip a
category only after confirming it cannot touch the path. Strong coverage of
web/SaaS scenarios (auth, payments, uploads, webhooks) is intentional, but the
taxonomy is general-purpose.

**Two directions.** This taxonomy is used both ways. As a **lens** (the
per-scenario flow): given a scenario, ask what each category breaks. As a
**generator** (Stage 0, see `scenario-generation.md`): given a bounded surface,
ask what concrete scenario on that surface would *exercise* each category. Same
8 categories, opposite questions.

Use these as failure-mode generators, not a checklist to tick. One prompt often
surfaces several distinct failure modes — capture each as its own FMEA row.

---

## 1. Inputs

What enters the path from the outside (request body, params, headers, files,
query strings, message payloads, env, config).

- **Null / missing** — required field absent; optional field assumed present.
- **Empty** — `""`, `[]`, `{}`, zero-length file, empty page of results.
- **Malformed** — bad JSON, wrong type (string where number expected), wrong
  shape, extra unexpected fields.
- **Huge** — 2GB upload, 10MB JSON body, a million array elements, deeply
  nested payload (stack/parse blowup), pathologically long string.
- **Malicious** — injection (SQL/NoSQL/command/template/LDAP), XSS payloads,
  path traversal (`../`), SSRF URLs, zip bombs, polyglot files, oversized
  headers, header smuggling.
- **Boundary** — 0, -1, off-by-one, max int / overflow, exactly-at-limit vs
  one-over, first/last page, empty vs single vs many.
- **Encoding** — UTF-8 vs UTF-16, emoji / surrogate pairs, BOM, invalid bytes,
  normalization (é as one vs two codepoints), case folding, locale collation,
  CRLF vs LF, double-encoding.

## 2. State & Timing

What happens when the path runs concurrently, out of order, or partially.

- **Races** — two requests mutate the same row/file/counter; check-then-act
  (TOCTOU); lost update; read-modify-write without a lock.
- **Double-submission** — user double-clicks; client retries; the same logical
  action arrives twice. Is the operation idempotent?
- **Stale reads** — read from a replica that hasn't caught up; cached value
  after the source changed; read-your-own-writes violations.
- **Partial updates** — step 3 of 5 fails; DB write succeeds but the event
  publish fails; two systems left inconsistent (no transaction / no saga).
- **Non-idempotent retries** — a retry re-runs a side effect (charge, email,
  increment) because there's no idempotency key or dedup.
- **Ordering** — events/messages arrive out of order; a "delete" lands before
  the "create"; webhook for a later state arrives first.

## 3. External Dependencies

Every network hop, third-party API, DB, cache, queue, or service you call.

- **Timeout** — the dependency hangs; is there a deadline? what's the fallback?
- **Garbage response** — 200 OK with an empty/HTML/error body; unexpected
  schema; nulls where data was promised.
- **Rate limit** — 429s under load; do you back off, queue, or hard-fail?
- **Outage** — dependency fully down; does the path degrade gracefully or take
  the whole request down with it? cascading failure?
- **Silent contract change** — the API changed a field, status code, or
  pagination behavior without notice; your parser silently mis-reads it.
- **Partial / slow** — degraded latency, truncated response, connection reset
  mid-stream, TLS errors, DNS failure.

## 4. Resources & Scale

What happens at 10x, 100x, 1000x the expected volume.

- **Load multipliers** — 10x/100x/1000x requests, items, or payload size; the
  "1000 signups in a minute" case. Where does it fall over first?
- **Memory** — loading a whole result set / file into memory; unbounded
  buffering; leak under sustained load; large object retention.
- **Connection pools** — pool exhausted under burst; long-held connections;
  no timeout returning connections; thread/worker starvation.
- **Runaway cost** — an operation that costs money per call invoked in a loop or
  under retry storm; unbounded fan-out; expensive query at scale.
- **N+1 / amplification** — one request triggers N DB/API calls; a webhook
  triggers a cascade; recursive expansion.
- **Disk / quota** — temp files not cleaned up; log volume; storage quota; file
  descriptor exhaustion.

## 5. Auth & Security

Specific to **this** path — not a generic audit.

- **Missing access control** — endpoint reachable without auth; object-level
  authz missing (IDOR — can user A read user B's resource by changing an ID?).
- **Privilege escalation** — a normal user reaches an admin action; role check
  done in UI but not server-side; mass-assignment of a `role`/`isAdmin` field.
- **Leaked secrets** — secrets in logs, error messages, responses, or client
  bundles; verbose stack traces to the user; PII in logs.
- **Injection on this path** — see Inputs §malicious, but trace where this
  path's untrusted data reaches a sink (query, shell, eval, template, file path,
  outbound URL).
- **Token / session** — expired/forged/replayed token accepted; missing CSRF
  protection; insecure direct redirect (open redirect); JWT alg confusion.

## 6. Time

Anything involving clocks, dates, durations, or expiry.

- **Timezones** — server UTC vs user local; off-by-a-day; date-only vs datetime;
  ambiguous local times.
- **DST** — the hour that doesn't exist / happens twice; cron jobs that skip or
  double-fire across the transition; duration math across DST.
- **Expiry** — token/session/cache/coupon expires mid-operation; expiry checked
  at start but not at use; grace windows.
- **Clock skew** — client vs server clocks differ; signature/nonce windows;
  "not before" / "not after" rejections; certificate validity edges.
- **Long-running ops** — operation outlives a token's validity, a connection
  timeout, or a deploy; leap second / year boundaries; epoch rollover.

## 7. Money / SaaS

Billing, payments, and subscription flows — get these wrong and customers feel
it directly.

- **Double-charge** — retry or double-submit charges twice; missing idempotency
  key on the payment call.
- **Failed webhook** — payment provider's webhook never arrives or arrives late;
  state stuck "pending"; no reconciliation job.
- **Duplicate webhook** — the SAME webhook delivered twice (providers guarantee
  at-least-once); processing it twice grants double credit / double fulfillment.
- **Out-of-order webhook** — `subscription.updated` arrives before
  `subscription.created`; `refund` before `charge`.
- **Refund edges** — partial refund, refund after dispute, refund of an already-
  refunded charge, currency rounding, refund exceeding original.
- **State drift** — your DB and the provider's records disagree; entitlement not
  revoked on cancellation; proration / trial / plan-change edge cases.

## 8. Failure of the Failure

When a step in this path fails, what happens to the recovery itself?

- **Is recovery present at all?** — or does the failure propagate raw?
- **Fail loud vs silent** — is the failure surfaced (logged, alerted, returned)
  or swallowed by an empty `catch`/`except`? Silent failure is the worst kind.
- **Rollback / compensation** — on partial failure, is prior work undone, or is
  the system left half-done?
- **Retry safety** — does the recovery path itself re-trigger the side effect?
  (loops back to §2 non-idempotent retries)
- **Error path tested?** — the happy path works; has the error branch ever
  actually run? Dead/incorrect error handling is common.
- **Observability** — if this fails in prod at 3am, is there enough signal
  (logs, metrics, traces, alerts) to even know it happened?

---

## Pre-mortem prompt (run after the forward walk)

> "Assume this scenario has ALREADY caused a catastrophic, customer-visible
> failure in production. Narrate exactly what happened, step by step — what the
> user did, what the system did, where it broke, and why nobody caught it."

Forward reasoning enumerates known classes; the pre-mortem forces a narrative
that often exposes interaction effects and silent-failure chains the categories
above miss in isolation. Fold anything new into the FMEA output.
