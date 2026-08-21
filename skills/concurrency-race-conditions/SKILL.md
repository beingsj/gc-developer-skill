---
name: concurrency-race-conditions
description: Use this skill when checking a feature for concurrency and race-condition risk — duplicate submissions, multiple users editing the same resource, repeated webhook events, booking/seat/inventory conflicts, or payment duplication — especially before shipping anything involving money, bookings, or shared limited resources.
---

# Concurrency & Race Conditions Skill

You are a QA engineer stress-testing what happens when two things happen at almost the same time.

## Goal

Determine whether the feature stays correct when multiple requests, users, or events hit the same resource concurrently, or whether it silently corrupts data under load.

## Duplicate Submission Protection Checklist

Check:
- Form submits and "create" API calls are idempotent (retry with the same idempotency key doesn't create a second record)
- Client-side double-click/double-submit prevention exists, but isn't the only line of defense
- A unique index or constraint at the MongoDB level prevents true duplicates even if the app-layer check races
- Network retries (client auto-retry, mobile flaky connection) don't produce duplicate side effects (double email, double charge)
- Idempotency keys (where used) are scoped correctly (per-user, per-request) and actually checked before executing the action

## Concurrent Update Handling Checklist

Check:
- Two users editing the same document at once: last-write-wins behavior is a deliberate choice, not an accident
- Optimistic locking (version field, `updatedAt` check) or a documented alternative exists for records where silent overwrite would be harmful
- Concurrent updates to different fields on the same document don't clobber each other unnecessarily
- The frontend warns the user (or merges) when the record they're editing has changed server-side since it was loaded
- Mongoose `findOneAndUpdate` with atomic operators (`$inc`, `$push`, `$set`) is used instead of read-modify-write where correctness matters

## Duplicate Webhook/Event Handling Checklist

Check:
- Webhook handlers (Stripe, payment gateway, etc.) are idempotent — the same event ID processed twice doesn't double-apply the effect
- Incoming webhook events are deduplicated using the provider's event ID, stored and checked before processing
- Out-of-order webhook delivery (e.g. "completed" arriving before "created") doesn't leave state inconsistent
- Webhook signature verification happens before any processing, and failures are rejected, not silently accepted
- Retried webhook deliveries (providers commonly retry on timeout/non-2xx) don't cause duplicate DB writes or duplicate notifications

## Booking/Seat/Inventory Conflict Handling Checklist

Check:
- Two users booking the same slot/seat at the same time: only one succeeds, and it's enforced at the DB layer (unique index, atomic conditional update), not just app-layer checks
- Inventory/stock decrements use atomic operations (`$inc` with a guard condition) rather than read-then-write, to prevent overselling
- Failed bookings/reservations release any tentative hold instead of leaving the resource stuck as unavailable
- Reservation holds have a timeout/expiry so abandoned checkouts don't permanently lock a seat/slot/unit
- Race between "check availability" and "confirm booking" is closed (no gap where two users both pass the check before either commits)

## Payment Duplication Protection Checklist

Check:
- Concurrent duplicate payment requests for the same order/cart are rejected or deduplicated, not both charged
- Payment intent/charge creation uses an idempotency key tied to the order, so retries don't create a second charge
- Client-side double-click on "Pay" can't fire two charge requests before the button disables
- Webhook-confirmed payment status updates are applied idempotently (processing the same "payment succeeded" event twice doesn't double-fulfill the order)
- Order state transitions (pending → paid → fulfilled) are guarded so a race can't fulfill an order twice or fulfill an unpaid one

## Severity Levels

Use:
- Critical — breaks core functionality or corrupts data for all/most users
- High — breaks functionality for a common path or subset of users
- Medium — degraded experience, workaround exists
- Low — minor/cosmetic issue
- Improvement — suggestion, not a defect

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority issues
- What was tested / files inspected
- What could not be tested (and why)
- Testing verdict / release recommendation
