# Input — Stage 0 mode

**User prompt:**

> What should I worry about in this diff before I ship?

**Bounded surface (git diff excerpt):**

```diff
diff --git a/src/api/checkout.ts b/src/api/checkout.ts
--- a/src/api/checkout.ts
+++ b/src/api/checkout.ts
@@ -12,6 +12,15 @@ export async function createCheckout(userId: string, cartId: string) {
   const cart = await db.carts.find(cartId);
   if (!cart || cart.userId !== userId) throw new Forbidden();
+  if (cart.items.length > 100) throw new BadRequest('too many line items');
   const total = cart.items.reduce((s, i) => s + i.price * i.qty, 0);
+  const session = await stripe.checkout.sessions.create({
+    mode: 'payment',
+    line_items: cart.items.map(i => ({ price_data: { currency: 'usd', unit_amount: i.price }, quantity: i.qty })),
+    success_url: `${APP_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
+    metadata: { cartId, userId },
+  });
+  cart.stripeSessionId = session.id;
+  await cart.save();
   return { url: session.url };
 }
```

**Routing:** Bounded surface, no scenario → Stage 0, then user picks scenarios.
