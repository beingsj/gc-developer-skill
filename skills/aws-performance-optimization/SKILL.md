---
name: aws-performance-optimization
description: Use this skill when investigating slow response times, high latency, or sluggish page loads on AWS-hosted infrastructure — checking application latency, server configuration, CDN usage, API performance, database performance, caching, instance type, region placement, and load balancing.
---

# AWS Performance Optimization Skill

You are a cloud performance engineer reviewing an AWS-hosted application to find where latency is being introduced and lost.

## Goal

Locate the specific layers (compute, network, data, caching) adding unnecessary latency to requests, and recommend concrete fixes to bring response times down.

## Compute Sizing Checklist

Check:
- Instance type/family matched to actual CPU vs memory bottleneck (compute-optimized vs memory-optimized vs burstable)
- Burstable instances (T-family) running out of CPU credits under sustained load
- ECS/Fargate task CPU/memory allocation causing throttling under real traffic
- Lambda memory allocation too low, indirectly capping CPU and increasing execution time
- Instance/container count too low for concurrent request volume, causing queuing

## CDN & Edge Performance Checklist

Check:
- CloudFront present in front of static assets, images, and cacheable API responses
- Cache hit ratio on CloudFront distributions (low hit ratio indicates poor cache key/TTL config)
- Origin configured correctly (compression enabled, correct cache-control headers from origin)
- Cache behaviors set per path pattern instead of one blanket policy for the whole app
- Edge locations/price class matched to where actual users are

## Database Performance Checklist

Check:
- RDS/DocumentDB instance class sized for query volume and working-set size in memory
- Read replicas in place and actually used for read-heavy endpoints instead of hitting the primary
- Connection pooling configured (RDS Proxy or app-level pool) instead of opening a connection per request
- Slow query logs reviewed for missing indexes or full collection/table scans
- Database and application deployed in the same region/AZ to avoid cross-AZ query latency

## Caching Layer Checklist

Check:
- ElastiCache (Redis/Memcached) present for frequently-read, rarely-changed data
- Cache hit rate monitored and healthy, not silently bypassed by cache-busting patterns
- Session data and computed aggregates cached instead of recomputed per request
- Cache eviction policy and TTLs matched to data volatility, not defaulted
- Cache warm-up strategy exists for cold-start-sensitive paths

## Region & Load Balancer Checklist

Check:
- AWS region chosen closest to the majority of end users, not left at account-default region
- Multi-region or Route 53 latency routing considered if the user base is geographically spread
- ALB health check interval/threshold tuned so unhealthy targets are pulled quickly
- Target group deregistration delay (connection draining) set appropriately, not causing dropped requests
- Load balancer idle timeout matched to the application's actual request duration profile

## Severity Levels

Use:
- Critical — actively causing user-facing timeouts or severe latency in production
- High — measurable, significant latency impact on a common request path
- Medium — moderate latency impact, noticeable but not breaking the experience
- Low — minor latency contributor
- Improvement — performance hygiene with no measured current impact

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Performance score out of 10
