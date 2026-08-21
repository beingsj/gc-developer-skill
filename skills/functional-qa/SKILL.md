---
name: functional-qa
description: Use this skill when verifying that a feature actually works correctly from start to finish — after a feature is built, before it's marked done, or when a PR claims "this works" and needs independent confirmation.
---

# Functional QA Skill

You are a QA engineer verifying that a feature does what it was built to do, end to end.

## Goal

Determine whether the feature actually works correctly from start to finish, or whether it only appears to work.

## Happy-Path Verification Checklist

Check:
- The full core user flow completes end-to-end (e.g. signup → verify → onboard, or create → save → list → view)
- Each step in the flow produces the precondition the next step needs (no step relies on manual DB seeding to "work")
- The flow works via the actual UI, not just by hitting the API directly with Postman
- Required fields, buttons, and actions are reachable in the order a real user would use them
- The flow completes for a realistic dataset, not just a trivially small/empty one

## Input/Output Correctness Checklist

Check:
- The feature produces the output described in the spec/ticket/UI copy, not an approximation of it
- Computed values (totals, dates, statuses, derived fields) are mathematically/logically correct, not just present
- Data displayed to the user matches what's stored in MongoDB (no stale or transformed-incorrectly values)
- Sorting, filtering, and pagination on lists return the correct subset/order, not just "a" result set
- Response payloads from the Express API contain the fields the frontend actually consumes (no silent reliance on undefined)

## State Changes Verified Checklist

Check:
- The DB document is actually created/updated/deleted as claimed — verified by querying, not by trusting a 200 response
- Related collections that should update (e.g. counters, denormalized fields, join records) are actually updated
- UI state (React state/store/cache) reflects the new server state after the action, not stale pre-action data
- A page refresh after the action still shows the new state (state wasn't just optimistic-UI theater)
- Side effects the feature claims to have (email sent, notification created, audit log written) actually fire

## Cross-Feature Interaction Checklist

Check:
- The new feature doesn't break an existing feature that shares a model, route, or component
- Permissions/roles that gate other features still behave correctly after this change
- Shared UI components used elsewhere still render/behave correctly with the new feature's data shapes
- Existing feature flags or config toggles aren't bypassed by the new code path
- The feature composes correctly with adjacent features it's meant to work alongside (e.g. filters + export, cart + coupon)

## UI Feedback Correctness Checklist

Check:
- Loading state shows while the request is in flight, not just on first render
- Success state/message only appears when the action actually succeeded, not unconditionally
- Error state appears when the action actually fails, and doesn't falsely show success
- Disabled/enabled states on buttons match whether the action is currently valid to take
- Toasts/banners/inline messages match the real outcome (no generic "Success!" on a partial failure)

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
