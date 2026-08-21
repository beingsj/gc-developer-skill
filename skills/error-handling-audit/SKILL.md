---
name: error-handling-audit
description: Use this skill when auditing how a feature handles failure — API errors, database failures, network/third-party failures, upload failures, expired sessions, timeouts, and the quality of user-facing error messages — before shipping anything that talks to a backend, DB, or external service.
---

# Error Handling Audit Skill

You are a QA engineer whose job is to make things fail on purpose and check whether the app fails gracefully.

## Goal

Determine whether the feature handles failure conditions safely and communicates them clearly, instead of crashing, hanging, or leaking internals.

## API Error Response Checklist

Check:
- Correct HTTP status codes are returned for each failure type (400 validation, 401 unauthenticated, 403 forbidden, 404 not found, 409 conflict, 500 unexpected)
- Error responses have a consistent shape across routes (not one controller returning `{error}` and another `{message}`)
- Stack traces, internal file paths, and raw Mongo/Mongoose error objects are never sent in the response body to the client
- Express global error-handling middleware catches unhandled errors instead of the process/route hanging or crashing
- Validation errors (Joi/Zod/express-validator/Mongoose) return field-level messages the frontend can actually map to form fields

## Database Failure Handling Checklist

Check:
- MongoDB connection loss is caught and surfaced as a clear error, not an unhandled rejection that crashes the Node process
- Query timeouts return a timeout-specific error/status rather than hanging the request indefinitely
- Duplicate key errors (E11000) are caught and translated into a meaningful "already exists" message, not a raw Mongo error
- Mongoose validation errors are caught in a try/catch or centralized error handler, not left to bubble as 500s with no context
- Connection retry/backoff logic exists (or a documented decision not to) for transient DB unavailability

## Network/Third-Party Failure Handling Checklist

Check:
- Calls to external APIs (payment gateway, email provider, SMS, storage, maps, etc.) are wrapped in try/catch with a timeout set
- A third-party API being down/slow doesn't hang the whole request indefinitely or block unrelated functionality
- Malformed or unexpected responses from a third-party API are validated before being used, not blindly trusted
- Retries for transient third-party failures are bounded (no infinite retry loops) and ideally use backoff
- Failure of a non-critical third-party call (e.g. analytics, optional enrichment) doesn't fail the entire user-facing request

## Upload Failure Handling Checklist

Check:
- Oversized file uploads are rejected with a clear message, not a server crash or silent truncation
- Wrong file type/mimetype is rejected server-side, not just via the file picker's `accept` attribute
- Interrupted uploads (network drop mid-upload) don't leave a corrupt/partial file referenced in the DB
- Upload failures clean up any partially-written file/blob storage object rather than leaving orphaned data
- Frontend shows upload progress/failure state distinctly, not a generic spinner that never resolves

## Session Expiry Handling Checklist

Check:
- An expired session/JWT returns a distinct, clear status (401) that the frontend maps to a re-auth prompt
- The user is redirected to login (or shown a re-auth modal) instead of seeing a silent failure or blank screen
- In-progress work isn't silently discarded when a session expires — the user gets a chance to re-auth and retry
- Refresh-token failures are handled explicitly, not treated the same as "still logged in"
- No protected route/endpoint is reachable after expiry due to a missed auth-middleware check

## User-Facing Error Message Quality Checklist

Check:
- Error messages tell the user what happened and what to do next, not just "Something went wrong"
- Raw backend/database error text is never shown directly to end users
- Field-level errors point at the specific field, not just a generic top-of-form banner
- Messages are consistent in tone and terminology across the app
- Errors that are actually the app's fault (5xx) are distinguished from errors caused by the user's input (4xx) in wording

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
