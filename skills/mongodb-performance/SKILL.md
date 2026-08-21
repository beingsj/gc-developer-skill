---
name: mongodb-performance
description: Use this skill when reviewing MongoDB/Mongoose usage for performance — slow queries, high read/write latency, or before scaling a collection that's growing fast.
---

# MongoDB Performance Skill

You are a MongoDB performance engineer reviewing schema design and query patterns for efficiency at scale.

## Goal

Determine which queries, indexes, or schema decisions are causing slow or expensive database operations, and produce a prioritized list of fixes.

## Indexing Checklist

Check:
- Missing indexes on fields used in frequent `find()` filters, `sort()`, or `$match` stages
- Compound indexes not aligned with actual query shape (wrong field order for equality-sort-range pattern)
- Unique/sparse indexes missing where uniqueness is enforced only in application code
- Indexes defined but never used (check against query patterns or `$indexStats`)
- Text/geospatial indexes missing where the app does text search or location queries via regex/manual filtering instead
- Too many indexes on a write-heavy collection, slowing down inserts/updates

## Query Plan Checklist

Check:
- Queries doing a full collection scan (`COLLSCAN` in `.explain()`) where an index scan should apply
- `$regex` queries with leading wildcards (`/.*foo/`) that can't use an index
- Queries filtering on a field with an index but in a way that defeats it (e.g. `$ne`, negation, function on the field)
- `.explain("executionStats")` not checked on any of the app's known slow endpoints
- Sort operations without a supporting index causing in-memory sort (and hitting the 32MB sort limit risk)

## Aggregation Pipeline Efficiency Checklist

Check:
- `$match` stages placed late in the pipeline instead of as early as possible to shrink the working set
- `$lookup` performed without an index on the foreign field
- `$lookup` joining large collections without a preceding `$match`/`$limit` to bound the join
- Pipelines materializing large intermediate result sets instead of using `$project`/`$unset` to drop unneeded fields early
- Aggregations run synchronously in the request path when they could be precomputed/scheduled
- `allowDiskUse` silently masking a pipeline that should be restructured instead

## Pagination Checklist

Check:
- `skip()`/`limit()` used for deep pagination on large collections (skip cost grows linearly with offset)
- No cursor-based pagination (`_id`-based or indexed sort-key range queries) for infinite-scroll/large-dataset endpoints
- Total count computed via a separate full `countDocuments()` on every paginated request instead of cached/estimated
- Page size unbounded or not validated, allowing a client to request excessive result sets

## Projections Checklist

Check:
- Queries using `find({})` with no projection, returning full documents when the endpoint uses only a few fields
- Large fields (embedded arrays, binary/base64 blobs, long text) fetched even when unused by the response
- `.lean()` not used on read-only Mongoose queries that don't need document methods/hydration
- Populated fields pulling entire referenced documents instead of a projected subset

## Duplicate/Redundant Queries Checklist

Check:
- Same document/collection queried multiple times within a single request (e.g. once in middleware, again in controller)
- Related data fetched in a loop instead of batched with `$in`
- No request-scoped caching/dataloader pattern for data reused across resolvers/middleware in the same request
- Validation queries (existence checks) duplicated right before a write that will fail naturally on a constraint

## Schema Design Impact Checklist

Check:
- Over-normalization causing excessive `$lookup`/multiple round-trip queries for data that's almost always read together
- Over-embedding causing document bloat (large growing arrays pushing documents toward the 16MB limit)
- One-to-many relationships modeled as unbounded embedded arrays instead of referenced/bucketed
- Frequently-updated subdocuments embedded inside a large parent document, causing full-document rewrites
- Schema doesn't reflect actual read/write ratio (optimized for writes when reads dominate, or vice versa)

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
