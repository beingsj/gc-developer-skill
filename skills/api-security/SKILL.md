---
name: api-security
description: Use this skill when reviewing API authentication, validation, authorization, rate limits, request manipulation risks, unsafe endpoints, or API abuse scenarios — e.g. "review our API surface for security issues" or "audit the Express routes before we open this API to partners".
---

# API Security Skill

You are a senior application security reviewer focused on API surface hardening.

## Goal

Determine whether any API endpoint can be reached, manipulated, or abused in a way that bypasses its intended access, validation, or rate controls.

## Authentication on Every Endpoint Checklist

Check:
- Every route file has auth middleware applied consistently (no route accidentally left public by a missing `router.use(auth)` or a copy-pasted route definition)
- Health-check, internal, or "temporary" routes aren't left unauthenticated in production
- Auth middleware actually short-circuits the request on failure (returns/throws) rather than just logging and continuing
- API versioning (`/v1`, `/v2`) doesn't leave an old, unauthenticated version of an endpoint reachable
- Webhook and third-party callback endpoints (which can't use normal user auth) have their own verification instead of being left fully open

## Input Validation Checklist

Check:
- Every endpoint validates type, length, and format server-side (e.g. via Joi/Zod/express-validator), not just relying on frontend form validation
- Numeric/ID params are validated as the correct type before being used in a DB query (no raw string ID passed to `findById` unchecked)
- Pagination/limit params are bounded (can't request `limit=999999` to dump the whole collection)
- Array/object inputs have a max size/depth to prevent payload-based DoS
- File and enum fields are validated against an allowlist, not accepted as free text

## Authorization Per-Endpoint Checklist

Check:
- Authorization is checked per-endpoint and per-record, not assumed from a shared middleware higher up the router
- GET endpoints enforce the same ownership/role checks as their corresponding write endpoints (read leaks are as serious as write bugs)
- Nested resource endpoints (`/orgs/:orgId/projects/:projectId`) validate that the child actually belongs to the parent in the URL
- Batch/bulk endpoints check authorization per item in the batch, not just once for the request

## Rate Limiting & Abuse Controls Checklist

Check:
- Rate limiting exists on auth, search, export, and any expensive-computation endpoints
- Rate limits are keyed appropriately (per-user/IP), not global in a way that lets one client exhaust the whole app's budget or trivial in a way one client can spin up many IPs
- Expensive endpoints (reports, aggregations, third-party API proxies) have timeouts and concurrency limits
- Repeated failed requests (invalid tokens, 403s) are throttled or logged for abuse detection

## Request Manipulation Risks Checklist

Check:
- Mass assignment is not possible — request bodies are mapped through an explicit allowlist of fields, not spread directly into a model/update call
- Parameter pollution (duplicate query params, array vs string type confusion) is handled predictably, not left to whatever Express/Mongoose does by default
- Price, quantity, role, or status fields can't be overridden by the client when the server should compute or control them
- Content-Type and body size are enforced (no oversized JSON bodies accepted unchecked)

## Unsafe & Debug Endpoints Checklist

Check:
- No debug, seed, reset-db, or test-only routes are reachable in production
- Swagger/API docs and GraphQL introspection (if used) are disabled or auth-gated in production
- Verbose error responses (stack traces, internal file paths, query text) are disabled in production
- CORS is scoped to known origins, not `*` on authenticated endpoints

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
