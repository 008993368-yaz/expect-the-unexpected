# Output — Stage 0 menu + one deep dive

## Stage 0 — ranked scenario menu

Risk anchors: `POST` checkout entry, untrusted `cartId`, Stripe session create,
cart row mutation, `metadata` carries `userId`/`cartId`, new 100-item cap.

| # | Scenario | Why risky |
|---|----------|-----------|
| 1 | User double-clicks "Pay" — two checkout sessions for one cart | State & timing; double Stripe sessions, ambiguous `cart.stripeSessionId` |
| 2 | Cart has 101 items (just over new cap) | Inputs boundary; rejects but client may not handle `BadRequest` |
| 3 | Stripe `sessions.create` times out after cart already saved with stale session id | External deps + partial update; cart points at dead session |
| 4 | Attacker passes another user's `cartId` before ownership check races | Auth; TOCTOU if cart reassigned between read and charge |
| 5 | `unit_amount` float / currency mismatch vs cart `price` | Money/SaaS; undercharge or Stripe rejection |
| 6 | Success URL open redirect via tampered `APP_URL` env | Auth & security; phishing if config compromised |
| 7 | 1000 concurrent checkouts on one cart | Resources; connection pool / Stripe rate limit |

**Skipped:** unrelated files in repo; test-only changes not in diff.

**Ask:** Which scenarios should I analyze? ("Top 3" is valid.)

---

## User pick: #1 and #3

### Scenario 1 — double-click checkout (abbreviated FMEA)

**Path:** `createCheckout` → load cart → cap check → sum → Stripe create →
save `stripeSessionId` → return URL.

| Failure mode | Trigger | Symptom | L | I | Risk | Mitigation / Test |
|--------------|---------|---------|---|---|------|-------------------|
| Two live sessions | Parallel requests before `cart.save` | User pays twice or wrong session wins | High | High | **High** | Idempotency key on cart; return existing open session. Test: parallel calls → one Stripe create (mock). |
| Overwritten session id | Second request saves after first payment | First payment succeeds but cart links to second session | Med | High | **High** | DB lock or `WHERE stripeSessionId IS NULL`. Test: interleaved saves → one session id retained. |

### Scenario 3 — Stripe timeout (abbreviated FMEA)

| Failure mode | Trigger | Symptom | L | I | Risk | Mitigation / Test |
|--------------|---------|---------|---|---|------|-------------------|
| Orphan session id | Timeout after Stripe created session but before save | Session exists in Stripe, cart has no link | Med | Med | **Med** | Compensating cancel or reconcile job. Test: mock timeout after create → cart has no id, session canceled (mock). |
| Stuck cart | Partial save with invalid session id | User cannot retry checkout | Med | Med | **Med** | Clear `stripeSessionId` on failure path. Test: failed save rolls back cart field. |

## Coverage note

> These are known failure classes for this path; this is not proof of
> correctness. Untested classes and anything outside this scenario remain
> unverified.

Scenarios **#2, #4–#7** were generated but not selected; other diff hunks
outside `checkout.ts` were not analyzed.
