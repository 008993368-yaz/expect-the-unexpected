# Input — per-scenario mode

**User prompt:**

> Before we ship checkout — what if a customer's payment succeeds at Stripe but
> our confirmation webhook fires twice?

**Bounded context (user pasted this handler):**

```typescript
// src/routes/webhooks/stripe.ts
app.post('/webhooks/stripe', async (req, res) => {
  const event = stripe.webhooks.constructEvent(req.body, sig, secret);
  if (event.type !== 'payment_intent.succeeded') {
    return res.json({ received: true });
  }
  const intent = event.data.object as Stripe.PaymentIntent;
  const order = await db.orders.findByStripeIntent(intent.id);
  if (!order) return res.status(404).send('order not found');
  order.status = 'paid';
  await order.save();
  await email.sendReceipt(order.userId, order.id);
  res.json({ received: true });
});
```

**Routing:** Specific scenario given → skip Stage 0, run Steps 1–6.
