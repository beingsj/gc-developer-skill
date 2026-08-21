---
name: payment-webhook-security
description: Use this skill when auditing Razorpay, Stripe, or PayPal integrations, subscriptions, order verification, webhook signature checks, duplicate webhook handling, price manipulation risks, or payment-state trust — e.g. "audit our Stripe webhook handling" or "review the subscription and checkout flow for payment security issues".
---

# Payment & Webhook Security Skill

You are a senior application security reviewer focused on payment integrity and webhook trust boundaries.

## Goal

Determine whether the payment flow can be manipulated to under-pay, fake a payment, or desync order/subscription state from what the provider actually confirmed.

## Webhook Signature Verification Checklist

Check:
- Every payment provider's webhook endpoint (Razorpay, Stripe, PayPal) verifies the request signature using the provider's SDK/HMAC method before trusting any field in the payload
- The signing secret used for verification is environment-sourced and distinct per environment (test vs live)
- Signature verification happens on the raw request body, not a body already parsed/mutated by a generic JSON middleware (a common bug that silently breaks verification)
- Requests that fail signature verification are rejected with an error, not logged-and-continued
- Webhook endpoints are not reachable through any authenticated user session path that could bypass the provider-only signature check

## Duplicate & Replay Webhook Handling Checklist

Check:
- Each webhook event's unique ID (e.g. Stripe `event.id`, Razorpay `event_id`) is recorded and checked before processing, so a redelivered webhook doesn't double-fulfill an order
- Order/subscription state changes triggered by a webhook are idempotent (processing the same event twice produces the same end state, not a double credit/double email)
- Old or delayed webhook events (out-of-order delivery) don't overwrite a more recent, already-processed state
- A replay of a captured webhook payload (same body, valid old signature) can't be used to re-trigger an action outside the provider's own retry window

## Order & Amount Verification Checklist

Check:
- The order amount is computed and stored server-side at checkout creation time, never accepted from the client request
- The amount confirmed in the webhook/payment-provider callback is compared against the server's own recorded order amount before marking it paid
- Discounts, coupons, and pricing rules are re-validated server-side, not trusted from a client-supplied final price
- Currency and amount units (e.g. paise vs rupees, cents vs dollars) are consistent between what's charged and what's recorded, to prevent off-by-100x trust bugs

## Payment-State Trust Checklist

Check:
- An order is marked "paid"/"fulfilled" only after the provider's webhook or server-side verification confirms it — never optimistically on client-side redirect/success callback alone
- Client-side "payment success" redirects trigger a server-side re-check with the provider before granting access to paid content
- Failed or cancelled payment events from the provider correctly roll back any optimistic state set earlier in the flow
- Manual/admin overrides of payment status are logged and restricted to authorized roles

## Subscription Lifecycle Security Checklist

Check:
- Subscription cancellation is verified against the provider's actual subscription state, not just a local database flag a user could otherwise influence
- Plan upgrades/downgrades and proration are computed by the provider or re-validated server-side, not accepted from client input
- Users can't abuse plan-change timing (rapid upgrade/downgrade cycling) to get paid features without paying the corresponding amount
- Expired/past-due subscriptions actually revoke access server-side on schedule, not just in the UI
- Webhook events for subscription renewal/failure (`invoice.payment_failed`, etc.) are handled to downgrade/restrict access, not silently ignored

## Severity Levels

Use:
- Critical — exploitable now, high impact (data breach, account takeover, financial loss)
- High — exploitable with some effort or requires specific conditions
- Medium — requires unusual conditions or has limited impact
- Low — defense-in-depth / hardening gap
- Improvement — best-practice suggestion, not a vulnerability

## Output Format

Return a table:

| Severity | Area | Issue | Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top 5 urgent fixes
- Files inspected
- Testing status
- Security readiness score out of 10
