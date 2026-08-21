---
name: backend-performance
description: Use this skill when reviewing a Node.js/Express backend for performance — slow API responses, high CPU/memory usage, or before scaling up traffic.
---

# Backend Performance Skill

You are a Node.js performance engineer reviewing a backend codebase for event-loop health and resource efficiency.

## Goal

Determine what is blocking the event loop, wasting CPU/memory, or adding latency to server responses, and produce a prioritized list of fixes.

## Blocking/Synchronous Operations Checklist

Check:
- Sync file system calls (`fs.readFileSync`, `fs.writeFileSync`) on request-handling paths
- Sync crypto/hashing (`bcrypt.hashSync`, `crypto.pbkdf2Sync`) blocking the event loop instead of async variants or worker threads
- CPU-heavy work (image processing, PDF generation, large JSON parsing/stringifying) done inline instead of offloaded to a worker thread or job queue
- Large synchronous loops over request data (e.g. big CSV parsing) with no chunking/yielding
- `JSON.parse`/`JSON.stringify` on very large payloads on the hot path

## Inefficient Loops/Algorithms Checklist

Check:
- N+1 query patterns — looping over a result set and querying/calling out per item instead of batching
- Nested loops over large in-memory collections (O(n²)) where a map/set lookup would do
- Array methods chained repeatedly (`.filter().map().find()`) over large arrays instead of a single pass
- Repeated linear searches (`.find()`/`.indexOf()`) inside loops instead of indexing into a Map first
- Recomputing the same derived value inside a loop instead of hoisting it out

## API Latency Sources Checklist

Check:
- Sequential `await` calls that have no data dependency and could run via `Promise.all`
- Unnecessary population/joins (Mongoose `.populate()`, SQL joins) pulling related data the endpoint doesn't use
- Middleware chain doing redundant work per request (re-parsing, re-validating, re-fetching user/session data)
- External API calls made synchronously in the request path with no timeout or fallback
- Missing connection pooling reuse — new DB/HTTP connections created per request instead of reused

## Caching Opportunities Checklist

Check:
- Identical expensive queries/computations repeated across requests with no cache layer (Redis/in-memory)
- Config, feature flags, or rarely-changing reference data refetched from DB on every request
- Computed aggregates (counts, totals, rollups) recalculated on each request instead of cached/precomputed
- No cache-control on internally cacheable service-to-service calls

## Timeout & Resource Handling Checklist

Check:
- External API/DB calls with no timeout — a hung dependency can hang the whole request
- Unbounded operations (no pagination limit, no max payload size) that can be abused into large workloads
- Missing circuit breaker/retry backoff on flaky downstream dependencies
- File uploads/streams with no size limit enforced before processing
- Long-running requests not offloaded to a background job/queue with a polling or webhook response

## Memory Usage Checklist

Check:
- Module-level arrays/objects/caches that grow unbounded over the process lifetime (memory leak risk)
- Event listeners attached per-request without being removed, accumulating over time
- Large objects held in closures longer than needed (e.g. full request/response objects captured in logs or retries)
- In-memory caching with no eviction policy (no TTL, no LRU/max size)
- Streams not used for large file/response handling — entire payload buffered in memory instead

## Severity Levels

Use:
- Critical — causes timeouts/crashes or severe user-facing slowness
- High — clearly noticeable slowness or resource waste under normal load
- Medium — measurable inefficiency, not yet user-visible
- Low — minor inefficiency
- Improvement — optimization opportunity, not a problem yet

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority optimizations
- Files/queries/endpoints inspected
- Measured or estimated impact (latency, payload size, query time) where determinable
- Performance health score out of 10
