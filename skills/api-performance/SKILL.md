---
name: api-performance
description: Use this skill when reviewing REST/API endpoints for performance — slow endpoints, oversized responses, chatty client-server communication, or before a load-testing pass.
---

# API Performance Skill

You are an API performance engineer reviewing endpoint design and behavior for latency and efficiency.

## Goal

Determine which endpoints are slow, oversized, or chatty, and produce a prioritized list of fixes.

## Endpoint Latency Checklist

Check:
- Endpoints with consistently high response times (identify via logs/APM) and isolate the cause (DB query, external call, serialization)
- Slow middleware running on every request (auth lookups, logging, body parsing of large payloads) regardless of route need
- Synchronous work done in the request/response cycle that could be deferred to a background job with a webhook/polling response
- Endpoints combining multiple unrelated operations serially when they could run in parallel
- No timing instrumentation (request duration logging/APM) on endpoints, making regressions invisible

## Payload Size Checklist

Check:
- Responses returning full documents/objects when the client only renders a subset of fields
- Deeply nested related data included by default instead of behind an explicit `include`/`expand` param
- Arrays returned in full instead of paginated, even for endpoints with unbounded growth potential
- No field-selection support (e.g. `?fields=` or GraphQL-style selection) on data-heavy list endpoints
- Responses not compressed (missing gzip/brotli via `compression` middleware)
- Redundant metadata/wrapper fields repeated on every item in a list response

## Round Trips Checklist

Check:
- Client making multiple sequential API calls to assemble one screen/view that could be a single aggregated endpoint
- No batch endpoint for operations the client performs in a loop (e.g. fetching N resources one at a time instead of `?ids=`)
- Polling used where a webhook, SSE, or websocket push would eliminate repeated round trips
- Related resources requiring a follow-up call instead of optional embedding (`?expand=relatedResource`)

## Pagination Checklist

Check:
- Pagination missing entirely on list endpoints that can grow unbounded
- Offset-based pagination causing degrading performance at high page numbers on large datasets
- Inconsistent pagination conventions across endpoints (some cursor-based, some offset, some undocumented)
- Page size not capped, letting a client request the entire dataset in one call
- Total-count computation adding significant latency to every paginated request

## Caching Checklist

Check:
- Missing HTTP caching headers (`Cache-Control`, `ETag`, `Last-Modified`) on responses that are safe to cache
- No conditional request support (`If-None-Match`/304 handling) for expensive, rarely-changing endpoints
- No server-side response caching (Redis/in-memory) for expensive-to-compute but stable data
- Cache headers set to `no-store`/`no-cache` broadly out of caution, even on public/static data endpoints

## Filtering/Search Efficiency Checklist

Check:
- Filter parameters translated into queries on unindexed fields
- Search implemented via unanchored regex/`LIKE '%term%'` instead of a text index or search service
- Filter/query construction building an inefficient query (e.g. `$or` across many unindexed fields) instead of a targeted index strategy
- Complex filter combinations not validated, allowing pathological queries (e.g. unbounded date ranges) to reach the DB
- No query result caching for common/repeated filter combinations

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
