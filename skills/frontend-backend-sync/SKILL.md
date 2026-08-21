---
name: frontend-backend-sync
description: Use this skill when checking that frontend and backend haven't drifted apart — after an API change, before merging a PR that touches both a React component and its Express route, or when a bug report smells like a contract mismatch ("works in Postman but not in the UI").
---

# Frontend-Backend Sync Skill

You are an integration auditor verifying that a React frontend and a Node.js/Express/MongoDB backend agree on the exact shape of every contract between them.

## Goal

Determine whether every request the frontend sends and every response it expects still matches what the backend actually accepts and returns, and flag every point of drift.

## Request/Response Field Parity Checklist

Check:
- Every field the frontend sends in a request body/query exists in the backend's expected schema (no silently-dropped fields on `req.body`)
- Every field the frontend reads off a response (`res.data.x`) is actually present in the controller's returned JSON, including nested objects/arrays
- Optional vs. required fields agree — a field the backend treats as required isn't sent as optional/undefined from a form
- Field name casing matches exactly (`camelCase` vs `snake_case` vs `PascalCase`) with no undocumented transform layer
- Renamed or removed backend fields don't leave frontend code reading a field that no longer exists (dead reads)
- Populated/joined Mongoose fields (e.g. `.populate('user')`) return the shape the frontend assumes (object vs. ObjectId string)

## Route & HTTP Method Checklist

Check:
- Every frontend API call's URL path matches an actual registered Express route (including base path/prefix and versioning)
- HTTP method used by the frontend (GET/POST/PUT/PATCH/DELETE) matches the method the route is registered under
- Path params (`:id`, `:userId`) are supplied in the same order/format the frontend constructs them
- No frontend calls hitting a deprecated or removed endpoint still referenced in an old service file
- Route-level middleware (auth guard, upload handler) isn't silently expected by the backend but skipped by how the frontend calls it (e.g. missing multipart headers for file upload)

## Type Consistency Checklist

Check:
- TypeScript interfaces/PropTypes on the frontend match the Mongoose schema types (String vs Number vs Date vs ObjectId) field by field
- Enum values on the frontend (dropdown options, constants) are the exact same set/spelling as the backend enum/schema `enum: []`
- Date/time fields are handled consistently (ISO string vs epoch vs Date object) on both ends
- Numeric fields aren't sent as strings (or vice versa) causing silent coercion or validation failures
- Array vs. single-object mismatches (frontend expects an array, backend returns one object or null)

## Validation Parity Checklist

Check:
- Every backend validation rule (required, min/max length, regex, min/max value) has a matching frontend-side check, not just a duplicate but functionally identical rule
- Frontend validation isn't stricter/looser than backend in a way that lets invalid data through or blocks valid data
- Custom validators (e.g. password complexity, phone format, unique email) are implemented identically on both sides, not just "similar"
- Error messages/error codes returned by backend validation middleware are actually mapped to something the frontend displays, not swallowed
- File upload constraints (size, mime type) match between frontend input restrictions and backend multer/storage config

## Auth & Permission Expectations Checklist

Check:
- Frontend UI hides/shows actions based on the same role/permission logic the backend actually enforces (no UI-only gating with no backend check, or vice versa)
- Token/session expectations match (frontend attaches token the way backend middleware expects — header name, `Bearer` prefix, cookie vs. header)
- 401/403 responses are distinguished and handled distinctly on the frontend (expired session vs. insufficient permission)
- Ownership checks assumed by the frontend (e.g. "only the owner sees edit button") are actually re-verified server-side, not trusted from the client

## Pagination, Filter & Status Parity Checklist

Check:
- Pagination query params (`page`, `limit`, `offset`, `cursor`) use the same names and semantics on both ends
- Response pagination metadata shape (`total`, `totalPages`, `hasMore`) matches what the frontend reads to render pagination controls
- Filter/query param names and accepted values match backend query parsing exactly (e.g. `status=active` vs `isActive=true`)
- Sort param names and allowed sort fields match between frontend sort UI and backend sort whitelist
- Status/enum values shown in frontend badges/filters are the complete, exact set defined in the backend schema — no status added on one side and missed on the other

## Severity Levels

Use:
- Critical — silent data loss, broken core flow, or a security gap (client-only permission check with no backend enforcement)
- High — feature visibly broken or returns wrong data for a common case
- Medium — edge case mismatch that only surfaces for some users/inputs
- Low — cosmetic inconsistency (naming, unused field) with no functional impact
- Improvement — opportunity to share types/validation (e.g. a shared schema package) to prevent future drift

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top 5 priority items
- Files inspected (frontend API/service files and backend routes/controllers/models paired up)
- Testing status (whether the mismatch was confirmed against a live request/response or inferred from code)
- Sync health score out of 10
