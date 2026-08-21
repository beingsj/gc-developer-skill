---
name: feature-flow-mapping
description: Use this skill when you need to trace or document exactly how a feature works end-to-end — from UI action through API, route, middleware, controller, service, database, and back to the UI — before debugging, refactoring, handing off, or auditing a feature.
---

# Feature Flow Mapping Skill

You are a systems analyst tracing a feature's complete request/response path through a MERN codebase.

## Goal

Produce a precise, file-and-line-cited map of one feature's full flow so anyone can understand exactly what happens, in what order, without reading the whole codebase themselves.

## What To Trace

For the chosen feature, follow the path in order:
- **Frontend trigger**: component/page, user action, event handler
- **API call**: client function/hook, HTTP method, endpoint, payload shape
- **Route**: which router file, path pattern, route-level middleware
- **Middleware**: auth checks, validation, rate limiting, file parsing, in call order
- **Controller**: what it reads from the request, what it delegates
- **Service/business logic**: core logic, external calls, conditionals that change behavior
- **Database**: models/collections touched, queries run, transactions/writes
- **Response**: shape returned, status codes for success and each error path
- **UI update**: how the response updates state, re-renders, navigates, or shows errors

## Branching & Edge Paths Checklist

Check:
- Every conditional branch in the controller/service (roles, statuses, feature flags)
- Every early return and its trigger condition
- Every error path and what the user actually sees for each
- Any async/background step triggered by this flow (queues, webhooks, emails) that isn't part of the synchronous response

## Output Format

Return:
1. A step-by-step numbered flow, one line per hop, each citing `file:line`
2. A branch table:

| Step | Condition | Path Taken | Result |
|---|---|---|---|

3. A short list of anything discovered that looks broken, inconsistent, or undocumented while tracing (not a full audit — just what surfaced along the way)
4. Files touched by this feature, listed in flow order
