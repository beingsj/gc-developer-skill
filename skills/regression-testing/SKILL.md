---
name: regression-testing
description: Use this skill when a newly added feature or fix needs to be checked against existing functionality — before merging a PR, after a shared model/service/component changes, or when "did this break anything else" needs a real answer.
---

# Regression Testing Skill

You are a QA engineer verifying that a change hasn't broken anything that used to work.

## Goal

Determine whether a newly added feature or fix has broken existing functionality elsewhere in the app.

## Blast Radius Identification Checklist

Check:
- Which shared models/schemas were modified, added, or had fields renamed/removed
- Which shared services, utility functions, or middleware were touched by the change
- Which API routes/controllers changed request/response shape, validation rules, or status codes
- Which shared React components, hooks, or context providers were modified
- Which shared state (Redux/Context/React Query cache keys) the change reads from or writes to

## Adjacent Feature Verification Checklist

Check:
- Every feature that reads or writes the same MongoDB collection/model still behaves correctly
- Every feature that calls the same service function or utility still gets the expected return shape
- Every screen that renders the same shared component still renders correctly with its existing data
- Features gated by the same middleware (auth, role check, rate limit) still enforce access correctly
- Any feature relying on the old field name/shape that was renamed/changed still works or was updated

## Previously-Fixed-Bug Verification Checklist

Check:
- Bugs previously fixed in the touched files/modules haven't resurfaced (re-check the original bug report steps)
- Regression test cases or manual QA notes from prior bug fixes in this area still pass
- Edge cases that prompted a past hotfix (null checks, race condition guards, validation) are still in place after this change
- Known flaky areas of the app (payment flow, file upload, auth) are re-verified whenever touched, even indirectly

## API Contract Stability Checklist

Check:
- Existing consumers (frontend, mobile, third-party integrations, webhooks) of a changed endpoint still get compatible response shapes
- Required fields weren't silently added to request bodies without updating all existing callers
- Status codes returned for existing scenarios haven't changed in a way that breaks existing error handling
- Deprecated fields are still present (or a proper versioning/migration path exists) if consumers still depend on them
- Pagination, sorting, and filtering defaults on unchanged endpoints still return the same results as before

## UI Consistency Checklist

Check:
- Shared components (buttons, modals, tables, forms) still render/behave correctly on every screen that uses them, not just the one that was changed
- Global styles/theme changes don't visually break unrelated pages
- Navigation, routing, and layout still work correctly for pages not directly touched by the change
- Forms elsewhere in the app that reuse a shared validation schema still validate correctly
- Notifications/toasts/error banners triggered by shared logic still display correctly across features

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
