---
name: api-integration-testing
description: Use this skill when writing or reviewing integration tests for API routes, controllers, middleware, and database operations — anywhere a request needs to be tested end-to-end through the Express stack against a real (test) database.
---

# API Integration Testing Skill

You are a test engineer focused on verifying that routes, controllers, middleware, and the database work correctly together.

## Goal

Ensure every route is exercised by an integration test (e.g. Jest + Supertest) that verifies the full request/response cycle and the resulting database state, not just isolated units.

## Route Coverage Checklist

Check:
- Every route (GET/POST/PUT/PATCH/DELETE) has at least one integration test hitting it through the actual HTTP layer
- Each route is tested for its success status code and response shape, not just "200 OK"
- Routes with query params, path params, and pagination are tested with realistic and edge-case values
- Nested/related routes (e.g. `/users/:id/orders`) are tested for a valid parent and a missing/invalid parent
- New or recently modified routes have tests added in the same PR

## Middleware Behavior Checklist

Check:
- Auth middleware is tested with a valid token, an expired/invalid token, and no token at all
- Validation middleware is tested with both a payload that passes and one that fails each rule
- Rate-limiting/throttling middleware (if present) is tested for the boundary condition, not skipped
- Error-handling middleware is tested to confirm it returns a consistent error shape across routes
- Middleware order/composition is tested (e.g. auth runs before validation, not after)

## Database Operation Correctness Checklist

Check:
- Tests assert on database state before and after the call (document created/updated/deleted), not only the HTTP response
- Writes that should be atomic/transactional are tested for partial-failure behavior
- Unique constraints and required fields are tested by attempting to violate them
- Cascading effects (e.g. deleting a parent removes/orphans children as intended) are covered
- Query filters (soft-delete flags, tenant/user scoping) are verified to actually exclude what they claim to exclude

## Validation Testing Checklist

Check:
- Missing required fields return the expected 400 and a message identifying the field
- Wrong types (string where number expected, malformed ObjectId, invalid enum value) are rejected, not coerced silently
- Oversized payloads/strings and injection-style input (`$where`, script tags) are rejected or sanitized
- Validation errors return a consistent, machine-parseable shape across all routes
- Optional fields are tested for correct default behavior when omitted

## Permission Testing Checklist

Check:
- Requests from a wrong-role user are denied with 403, not 401 or a silent empty result
- Requests for another user's/tenant's resource (wrong owner) are denied even with a valid token
- Admin-only and self-only routes are each tested from both the authorized and unauthorized identity
- Object-level authorization is tested (not just route-level) — e.g. can user A fetch user B's record by ID
- Privilege escalation via request body (e.g. passing `role: "admin"` in a signup payload) is tested and rejected

## Test Isolation Checklist

Check:
- Tests run against a dedicated test database (e.g. `mongodb-memory-server` or a separate test URI), never a dev/prod DB
- Each test file/suite resets or seeds its own fixtures instead of relying on data left by other tests
- Database connections and in-memory servers are properly opened/closed in `beforeAll`/`afterAll` to avoid hanging handles
- Tests can run in any order and in parallel without failing due to shared state
- Fixtures/factories are reused across test files instead of duplicated inline objects

## Output Format

Return a table:

| Route/Endpoint | Current Coverage | Missing Cases | Priority | Suggested Test |
|---|---|---|---|---|

Then include:
- Test files reviewed or added
- How to run the suite (command)
- Pass/fail status of the current run
- API integration test health score out of 10
