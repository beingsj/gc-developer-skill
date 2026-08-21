---
name: aws-scalability
description: Use this skill when assessing whether an application can safely handle traffic spikes or sustained growth — checking Auto Scaling, load balancing, stateless backend design, shared sessions, caching, background queues, DB connection limits, file storage, CDN, and horizontal scaling readiness.
---

# AWS Scalability Skill

You are a site reliability engineer reviewing whether an application can scale horizontally without breaking under a traffic spike.

## Goal

Determine whether the application can safely add more instances/containers under load, and flag anything that would break or bottleneck first.

## Horizontal Scaling Readiness Checklist

Check:
- Backend processes are stateless — no in-memory data that would differ between instances
- No reliance on local instance identity (hostname, instance ID) baked into request handling or job scheduling
- Multiple instances can run concurrently behind the load balancer without conflicting on shared resources
- Deployment/config supports running N instances/containers without manual per-instance setup
- Sticky sessions not required for the app to function correctly

## Auto Scaling Configuration Checklist

Check:
- Auto Scaling group exists and is actually attached to the load balancer's target group
- Scaling triggers based on relevant metrics (CPU, request count, queue depth) not left at defaults that don't match the workload
- Min/max capacity set to handle both normal load and a realistic spike scenario
- Scale-out cooldown short enough to respond to sudden spikes; scale-in cooldown long enough to avoid flapping
- Scaling policy tested under simulated load, not just configured and assumed to work

## Shared State Handling Checklist

Check:
- User sessions stored in Redis/ElastiCache or a shared store, not in-memory on individual instances
- No feature relies on in-process caches that would produce inconsistent results across instances
- WebSocket/real-time connections handled with a shared pub/sub layer if scaled across multiple instances
- Rate limiting and idempotency keys backed by a shared store, not per-instance memory

## Database Connection Limits Checklist

Check:
- Connection pool size per instance multiplied by max instance count stays under the database's max connection limit
- RDS Proxy or PgBouncer-style pooling in place if instance count can scale significantly
- DocumentDB/MongoDB connection pool settings tuned for the driver and expected concurrency
- Database can itself scale (read replicas, larger instance class) if compute scales past what the current DB tier supports

## Background Processing Checklist

Check:
- Heavy or slow work (emails, exports, image processing, webhooks) offloaded to a queue (SQS) and worker fleet, not run inline in the request
- Queue-based workers can themselves scale independently of the web tier
- Long-running jobs have retry/backoff and don't block request-handling capacity
- No single background job or cron task becomes a bottleneck as data volume grows

## File Storage & CDN Checklist

Check:
- Uploaded files/assets stored in S3, not on local instance disk (which breaks on scale-in/replacement)
- Static and heavy assets served through CloudFront, offloading the origin under traffic spikes
- Any local disk usage is ephemeral/scratch only, never a source of truth
- Auto Scaling instance replacement doesn't risk losing data that should have been persisted externally

## Severity Levels

Use:
- Critical — will cause an outage or data loss the moment a real traffic spike hits
- High — will cause significant degradation under a spike, fixable before it's needed
- Medium — works today but becomes a bottleneck at moderate growth
- Low — minor scaling friction with limited near-term impact
- Improvement — scaling hygiene with no immediate risk

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Scalability readiness score out of 10
