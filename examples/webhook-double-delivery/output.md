# Output — webhook fires twice

## 1. Execution path

`POST /webhooks/stripe` → verify signature → filter to
`payment_intent.succeeded` → load order by Stripe intent id → set `paid` →
save → send receipt email → `200 { received: true }`. No idempotency check on
`event.id`; external calls: DB read/write, email API.

## 2–3. Taxonomy + pre-mortem (summary)

Forward walk surfaced double-processing, email duplication, and race on
concurrent delivery. Pre-mortem narration: customer charged once, two receipt
emails, support ticket — ops never noticed duplicate `event.id` in logs because
webhook handler doesn't log it.

## 4. FMEA table (ranked)

| Failure mode | Trigger | Symptom | Likelihood | Impact | Risk | Mitigation / Test |
|--------------|---------|---------|------------|--------|------|-------------------|
| Double fulfillment | Same `payment_intent.succeeded` delivered twice (Stripe at-least-once) | Order marked paid twice path; duplicate receipt emails; possible duplicate downstream jobs if added later | High | Med | **High** | Store processed `event.id` (unique index); return 200 on replay. Test: POST two identical signed payloads → second returns 200, `email.sendReceipt` called once (mock). |
| Lost update race | Two different events for same intent arrive concurrently | One save overwrites the other; inconsistent `status` | Med | Med | **Med** | Transaction or `UPDATE ... WHERE status = 'pending'`. Test: parallel handler invocations with mocked DB → exactly one transition to `paid`. |
| 404 on valid payment | Order row missing when webhook arrives (create lag) | Stripe retries; customer paid but order stuck | Med | High | **High** | Queue webhook for retry or create order from intent metadata. Test: `findByStripeIntent` returns null → handler returns 503 (retryable), not 404. |
| Silent email failure | `email.sendReceipt` throws; no try/catch | Order `paid` but no receipt; user thinks payment failed | Med | Med | **Med** | Wrap side effect; log + alert; optional outbox. Test: mock email throw → order still `paid` but error logged / job enqueued. |
| Signature bypass | Malformed or missing `sig` | Forged webhook marks orders paid | Low | High | **Med** | Already uses `constructEvent`; test rejects bad signature with 400. Test: unsigned body → 400, order unchanged. |

*(Likelihood × Impact → Risk per matrix in `SKILL.md`.)*

## 5. Coverage note

> These are known failure classes for this path; this is not proof of
> correctness. Untested classes and anything outside this scenario remain
> unverified.

## 6. Execution offer (sample)

> Want me to write and run tests for any of these failure modes?

*(If user accepts top 2: write vitest tests with mocked `db` and `email`,
run `npx vitest run src/routes/webhooks/stripe.test.ts`, report CONFIRMED on
double fulfillment, NOT REPRODUCED on signature bypass.)*
