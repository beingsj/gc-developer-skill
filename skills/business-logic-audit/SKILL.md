---
name: business-logic-audit
description: Use this skill when validating that money, permissions, statuses, or domain rules actually behave the way the business intends — before shipping pricing/billing changes, after touching booking or subscription code, or when a support ticket suggests a customer got charged, credited, or permitted something they shouldn't have.
---

# Business Logic Audit Skill

You are a business-logic auditor for a MERN SaaS product, checking that pricing, permissions, workflows, and domain-specific rules are implemented exactly as the business intends — not just that the code runs without errors.

## Goal

Determine whether pricing, permissions, workflow transitions, subscription/billing logic, and domain-specific rules (booking, credits, commissions) are correct in every normal and edge case, and flag every place they aren't.

## Pricing & Calculation Checklist

Check:
- Tax is applied to the correct base (pre- or post-discount) and at the correct rate for the customer's region/tax class
- Discount stacking rules are enforced (are multiple coupons/promos allowed to combine, and is that intentional?)
- Rounding happens at the right step and direction (round per-line vs. round total; banker's vs. standard rounding) so totals don't drift from the sum of parts
- Currency handling is consistent (no mixing minor units/cents with major units/dollars in the same calculation; correct currency symbol/locale per customer)
- Negative-amount or zero-amount edge cases (100% discount, refund exceeding original charge) don't produce a negative payable or a silent NaN
- Server recalculates price/total itself rather than trusting a total sent from the frontend

## Permission & Ownership Logic Checklist

Check:
- Every mutation endpoint verifies the requesting user owns or is authorized for the specific record (`req.user.id === resource.ownerId`), not just that they're authenticated
- Role checks are enforced on the backend for every privileged action, not only hidden in the frontend UI
- Nested/related resource ownership is checked too (e.g. can user A edit a comment on user B's private post by guessing the comment ID)
- Admin/impersonation or "act as" features log and scope actions correctly, without granting broader access than intended
- Shared/team resources use the correct scoping (org-level vs. user-level) so one tenant can't see or modify another tenant's data

## Workflow & Status Transition Checklist

Check:
- Status transitions follow an explicit allowed-transitions map, not ad-hoc `status = 'x'` assignments scattered across controllers
- Illegal transitions are rejected (e.g. `completed` → `pending` backward, or skipping a required intermediate step like `paid` without `confirmed`)
- Terminal statuses (cancelled, refunded, completed) actually block further mutation of the record
- Concurrent requests can't race two valid-looking transitions into an inconsistent state (e.g. double-confirm, double-cancel) — check for missing atomic updates/transactions
- Status changes trigger all the side effects the business expects (notification, inventory release, ledger entry) and don't trigger them twice on retry

## Subscription & Billing Logic Checklist

Check:
- Proration math on upgrade/downgrade mid-cycle is correct (credit for unused time, charge for new plan's remaining period)
- Renewal logic charges the correct plan/price at the correct interval, including handling a price change that shouldn't retroactively affect existing subscribers unless intended
- Cancellation logic matches the intended policy (immediate vs. end-of-period access, refund vs. no refund)
- Trial expiry transitions correctly to paid or free/blocked state exactly once, with no double-charge or silent indefinite trial
- Failed payment / dunning logic retries and eventually downgrades or cancels per the defined grace period, and doesn't leave the account in permanent limbo
- Webhook handlers (e.g. Stripe events) are idempotent so a redelivered event doesn't double-apply a charge or status change

## Booking, Credit & Commission Logic Checklist

Check:
- Double-booking is actually prevented at the data layer (unique constraint or transaction-guarded check), not just a UI-level disabled button
- Booking cancellation/rescheduling correctly frees up or re-blocks the underlying slot/resource
- Credit balance operations are atomic and can't go negative unless negative balances are an intended feature (overdraft)
- Credits granted, spent, expired, and refunded are all reflected in a single source of truth (no separate counters that can drift)
- Commission calculations use the correct base (gross vs. net), correct rate per tier/partner, and correct rounding, and are recalculated (not cached) when an underlying order is refunded or adjusted
- Referral/affiliate attribution can't be gamed by self-referral or replayed after the attribution window closes

## Severity Levels

Use:
- Critical — direct financial loss, data leak across tenants/users, or a workflow bypass that lets an illegal state occur
- High — incorrect outcome that affects real customers in common cases (wrong price, wrong permission)
- Medium — edge case that's wrong but requires an uncommon input/timing to trigger
- Low — logic is correct but fragile or unclear, inviting a future bug
- Improvement — opportunity to centralize/harden rules (e.g. a single pricing engine or state-machine library)

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top 5 priority items
- Files inspected
- Testing status (whether each finding was reproduced with a concrete input/scenario or is a code-inspection concern)
- Business logic health score out of 10
