---
name: automated-regression-suite
description: Use this skill when building or reviewing a reusable automated test suite meant to catch regressions on future changes — evaluating shared fixtures, coverage of past bugs, CI wiring, and whether the suite stays fast and maintainable enough to actually be run.
---

# Automated Regression Suite Skill

You are a test engineer focused on building a durable safety net that catches regressions automatically as the codebase evolves.

## Goal

Ensure the test suite is structured, wired into CI, and fast enough to be run on every change — so future regressions are caught automatically instead of relying on manual QA.

## Suite Structure & Reusability Checklist

Check:
- Shared fixtures/factories exist for common entities (users, orders, tokens) instead of copy-pasted setup per test
- Common setup/teardown logic lives in shared helpers (`beforeEach`, custom commands, test utils), not duplicated per file
- Test suites are organized by feature/domain in a way that mirrors the app structure, not one giant flat file
- Mocks/stubs for external services (email, payments, third-party APIs) are centralized and reused, not redefined per test
- Naming conventions for test files and describe blocks are consistent across the suite

## Coverage of Previously-Fixed Bugs Checklist

Check:
- Each significant past production bug has a corresponding regression test that fails without the fix
- Bug-fix PRs include a test in the same commit, not "will add test later"
- A running list/tag (e.g. `// regression: BUG-123`) links tests back to the bug they guard against
- Recurring categories of bugs (e.g. timezone handling, off-by-one pagination) have a class of tests, not just one instance
- Closed/verified bugs are periodically checked to confirm their regression test still exists and still runs

## CI Wiring Checklist

Check:
- The suite runs automatically on every PR and on pushes to main, not only when a developer remembers to run it
- A failing suite blocks merge (required status check), rather than being advisory-only
- The suite runs against the same Node/package versions used in production, not an unpinned "latest"
- Flaky tests are tracked and quarantined/fixed rather than being globally allowed to retry until green
- Test results and coverage reports are visible on the PR, not buried in a log only the author checks

## Suite Maintainability Checklist

Check:
- Tests assert on behavior/output, not on incidental implementation details that break on harmless refactors
- Snapshot tests are reviewed critically — no giant snapshots that get rubber-stamp-updated without reading the diff
- A single small API/UI change doesn't require editing dozens of unrelated tests to keep them passing
- Test code is held to the same review standard as production code (no dead/skipped tests left indefinitely)
- Deprecated/obsolete tests for removed features are deleted, not left commented out or skipped

## Execution Speed Checklist

Check:
- The full suite (or a fast subset) runs quickly enough that developers actually run it before pushing
- Slow tests (DB-heavy, e2e) are separated from fast unit tests so the fast subset can run on every save
- Tests run in parallel/sharded in CI where the runner supports it
- Unnecessary real network calls, real timers, or real sleeps aren't inflating run time
- CI caches dependencies and build artifacts between runs to avoid redundant setup time

## Reporting Checklist

Check:
- Failure output names the specific test, expected vs. actual value, and the file/line — not just "1 test failed"
- CI posts a clear pass/fail summary on the PR (via status check or comment), not just a log link
- Coverage reports highlight newly untested code introduced by the PR, not just an aggregate percentage
- Repeated/flaky failures are surfaced distinctly from genuine new failures
- Test run history is retained so a regression's introduction point can be traced back to a specific commit

## Output Format

Return a table:

| Test Area/Suite | Current Coverage | Missing Cases | Priority | Suggested Test |
|---|---|---|---|---|

Then include:
- Test files reviewed or added
- How to run the suite (command)
- Pass/fail status of the current run
- Regression suite health score out of 10
