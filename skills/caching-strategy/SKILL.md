---
name: caching-strategy
description: Use this skill when deciding where caching would help across the stack — Redis, browser caching, CDN caching, API caching, query caching, or memoization — before adding a cache layer or when the system feels like it's recomputing/refetching too much.
---

# Caching Strategy Skill

You are a caching strategist reviewing a MERN stack to determine where a cache layer would reduce load and latency, and where one is missing or wrong.

## Goal

Determine which data/computations in the system are worth caching, where in the stack to cache them, and where existing or missing caches create staleness risk.

## Identifying Cacheable Data Checklist

Check:
- Data that's expensive to compute or fetch (heavy aggregations, external API calls, joins) but changes infrequently
- Read-heavy endpoints/queries with a high read-to-write ratio
- Reference/config data (plans, permissions, feature flags, lookup tables) re-fetched from the DB on every request
- Data shared across many users/requests (not user-specific) that's currently fetched per-request instead of once and shared
- Computed rollups (dashboards, counts, analytics) recalculated live on every page view

## Redis/Server-Side Caching Checklist

Check:
- Session data stored in a way that hits the DB on every authenticated request instead of Redis-backed sessions
- Rate-limiting counters implemented via DB writes instead of Redis (atomic incr + TTL)
- Computed aggregates/leaderboards/counts recalculated per request instead of cached with a refresh interval
- Hot DB queries (same query, same params, high frequency) with no cache-aside layer in front of them
- No cache key strategy (namespacing, versioning) — risk of collisions or stale keys across features
- Cache stampede risk — no lock/single-flight pattern when a hot cache key expires under high concurrency

## Browser/HTTP Caching Checklist

Check:
- Static assets (JS/CSS/images/fonts) served without long-lived `Cache-Control` + content-hashed filenames
- API responses that are safe to cache client-side missing `Cache-Control`/`ETag` headers
- No use of `304 Not Modified` flow for polling-style or rarely-changing endpoints
- Service worker/offline caching absent where the app would benefit from repeat-visit speed
- Overly aggressive `no-store` on responses that could safely be cached for even a few seconds

## CDN Caching Checklist

Check:
- Images/media served directly from the app server/origin instead of through a CDN
- Public, non-personalized pages (marketing pages, docs) not cached at the edge
- API responses that are identical for all users (public catalogs, static reference data) not eligible for edge caching
- Cache-control/surrogate-control headers not set to distinguish CDN-cacheable vs. origin-only responses
- No cache purge/invalidation hook tied to content updates, risking stale content being served from edge indefinitely

## Application-Level Memoization Checklist

Check:
- Same expensive pure function called multiple times with identical arguments within a single request with no memoization
- Frontend selectors/derived data recomputed on every render instead of memoized (`useMemo`, reselect)
- Repeated identical outbound calls (e.g. geocoding, currency conversion) across requests with no in-process or Redis-backed memo cache
- Config/env-derived values recomputed per call instead of computed once at startup

## Cache Invalidation Correctness Checklist

Check:
- No clear invalidation path when the underlying data changes (write doesn't bust/update the corresponding cache key)
- TTL-only caching used for data where staleness has real user impact, instead of explicit invalidation on write
- Cache keys not versioned/namespaced, making bulk invalidation on schema/logic changes difficult
- Multi-instance deployment with local (in-memory) caches that go stale relative to Redis/DB after a write on another instance
- No monitoring/alerting for cache hit rate or staleness, so silent staleness would go unnoticed

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
