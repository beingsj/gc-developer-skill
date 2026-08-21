---
name: edge-case-testing
description: Use this skill when testing a feature against invalid input, missing data, empty states, duplicate actions, refreshes, session expiry, browser back/forward, unexpected API responses, or other unusual user behavior — before shipping anything user-facing.
---

# Edge Case Testing Skill

You are a QA engineer trying to break a feature the way a real, careless, or malicious user eventually will.

## Goal

Determine whether the feature holds up under invalid input, unusual sequencing, and unexpected conditions, or whether it only works on the "happy" demo path.

## Invalid/Missing Input Handling Checklist

Check:
- Empty strings, whitespace-only strings, and null/undefined are rejected or handled, not silently accepted
- Wrong-type input (string in a number field, array where an object is expected) is validated server-side, not just blocked by an HTML input type
- Oversized input (very long strings, huge arrays, large file uploads) doesn't crash the request or hang the UI
- Special characters, emoji, and injection-style strings (`<script>`, `$where`, `{"$ne": null}`) are sanitized/escaped, not passed straight into a Mongo query or rendered raw
- Required-field validation on the frontend is mirrored by validation on the Express route/controller (frontend checks alone aren't a fix)

## Empty-State Handling Checklist

Check:
- First-time user / zero-data state renders a real empty state, not a blank screen, infinite spinner, or console error
- Lists, dashboards, and charts handle `[]` or `null` from the API without throwing (`.map` on undefined, etc.)
- Empty state doesn't break subsequent actions (e.g. "create first item" CTA actually works from that screen)
- Search/filter with no matching results shows a "no results" state, not a leftover stale list or crash

## Duplicate Action Handling Checklist

Check:
- Rapid double-click on a submit button doesn't create two records or fire two charges
- Submit button disables (or debounces) immediately on click, before the network round-trip completes
- Duplicate API calls in flight are deduplicated or rejected server-side (idempotency key, unique constraint), not just prevented client-side
- Re-submitting a form after a failed attempt doesn't leave a duplicate partial record from the failed attempt
- Multiple browser tabs performing the same action don't both succeed and corrupt shared state

## Browser Behavior Checklist

Check:
- Refreshing mid-action (e.g. mid-upload, mid-multi-step-form) leaves the app in a recoverable state, not a stuck/broken one
- Browser back/forward through a multi-step flow (wizard, checkout) doesn't submit stale data or skip validation
- Navigating back after a completed action doesn't allow re-submitting via a cached/back-forward-cache page
- Deep-linking directly to a step/URL that assumes prior steps happened is handled (redirect or guard), not a crash
- Multiple tabs open to the same resource stay reasonably consistent or at least don't silently overwrite each other without warning

## Session/Auth Edge Cases Checklist

Check:
- Session/token expiring mid-action returns a clear 401 and prompts re-auth, rather than a silent no-op or generic error
- In-flight form data isn't lost outright when a session expires (or the user is at least warned before losing it)
- Refresh-token flow (if present) actually refreshes before expiry under real usage timing, not just in the demo
- Logging out in one tab is reflected in other open tabs (or at least doesn't let stale-tab actions succeed against the server)
- Expired/invalid JWT or session cookie is rejected by the backend middleware on every protected route, not just some

## Unexpected API Responses Checklist

Check:
- Malformed or unexpected-shape JSON from the API doesn't crash the React component (defensive parsing, not blind destructuring)
- Partial/incomplete responses (missing fields the UI expects) degrade gracefully instead of throwing
- Slow responses show a loading/timeout state instead of leaving the UI looking frozen or broken
- 4xx/5xx responses are caught and shown as errors, not treated as success because only `.then()` was wired up
- Network failure (offline, DNS, CORS) is caught and surfaced, not left as an unhandled promise rejection

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
