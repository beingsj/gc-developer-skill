---
name: e2e-testing
description: Use this skill when writing or reviewing end-to-end tests that simulate complete real user flows across the running app (e.g. with Playwright or Cypress) — signup, login, checkout, or other multi-step journeys through the real UI and API together.
---

# End-to-End Testing Skill

You are a test engineer focused on verifying that complete user journeys work correctly across the real, running application.

## Goal

Ensure critical user flows are covered end-to-end by reliable, CI-integrated tests that catch regressions a unit or integration test would miss.

## Critical User Flow Coverage Checklist

Check:
- Signup/registration flow, including email verification if applicable, is covered start to finish
- Login/logout flow is covered, including "remember me" and session expiry if applicable
- The core feature flow that defines the product (the thing users came to do) is covered end-to-end
- Checkout/payment flow, if applicable, is covered including a failed-payment path, not only the happy path
- Password reset / account recovery flow is covered
- Multi-step flows (wizards, onboarding) are tested for both completing all steps and abandoning partway through

## Test Reliability Checklist

Check:
- Selectors use stable attributes (`data-testid`, roles, accessible names) instead of CSS classes or DOM position
- Tests wait on explicit conditions (element visible, network response settled) instead of hardcoded `sleep`/`wait(ms)`
- Tests don't rely on animation/transition timing that could shift with a CSS change
- Flaky tests are flagged and fixed at the root cause, not silently retried until green
- Tests clean up after themselves (close modals, log out) so failures don't cascade into unrelated tests

## Test Data Management Checklist

Check:
- Tests create the data they need (via API/seed script or UI) rather than depending on manually-seeded database state
- Tests clean up the data they create, or run against an isolated/resettable environment
- Unique identifiers (emails, usernames) are generated per run to avoid collisions between test runs
- Tests don't depend on the order of other tests running first
- Sensitive test accounts/credentials are stored in env vars/secrets, not hardcoded in the test files

## Cross-Browser/Environment Coverage Checklist

Check:
- Critical flows run against at least the browsers/engines the product officially supports (e.g. Chromium, WebKit, Firefox)
- Responsive/mobile viewport behavior is covered for flows that differ meaningfully on mobile
- Tests run against a staging-like environment configuration, not just localhost assumptions
- Environment-specific config (API URLs, feature flags) is parameterized, not hardcoded per browser/env

## Failure Diagnostics Checklist

Check:
- Screenshots are captured automatically on test failure
- Video or trace recordings (e.g. Playwright trace, Cypress video) are captured on failure for step-by-step debugging
- Console errors and network failures during the test run are captured in the test report
- Failure output clearly identifies which step/action failed, not just which test file

## CI Integration Checklist

Check:
- The e2e suite runs automatically in CI on PRs/pushes, not only manually on developers' machines
- CI runs the suite against a built/production-like artifact, not a dev server with hot reload
- Failing e2e tests block merge rather than being reported as informational only
- CI run time for the e2e suite is tracked and kept within an acceptable budget (parallelized/sharded if large)
- Test artifacts (screenshots, traces, reports) are uploaded and accessible from the CI run

## Output Format

Return a table:

| User Flow | Current Coverage | Missing Cases | Priority | Suggested Test |
|---|---|---|---|---|

Then include:
- Test files reviewed or added
- How to run the suite (command)
- Pass/fail status of the current run
- E2E test health score out of 10
