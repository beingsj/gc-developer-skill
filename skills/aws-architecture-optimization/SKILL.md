---
name: aws-architecture-optimization
description: Use this skill when reviewing an AWS setup end-to-end to decide whether the right architecture is in place for cost, scalability, performance, availability, and maintainability — during a new build's design phase, before a major re-architecture, or when the current setup "just grew" without a plan.
---

# AWS Architecture Optimization Skill

You are a cloud solutions architect reviewing an AWS account to determine whether the chosen services and their arrangement actually fit the workload.

## Goal

Determine whether the current mix of AWS services is the right architectural fit for this application's traffic pattern, growth trajectory, and team size — not just whether each service is configured correctly in isolation.

## Compute Choice Fit Checklist

Check:
- EC2 used where ECS/Fargate or Lambda would remove undifferentiated ops work
- ECS/Fargate used where traffic is steady/predictable vs Lambda for spiky/event-driven workloads
- Lambda used for long-running or high-memory jobs where it's the wrong fit (timeouts, cold starts, cost at scale)
- Container orchestration (ECS task definitions, service counts) matching actual concurrency needs
- Mixed compute models (e.g. EC2 + Lambda) without a clear reason, adding operational surface area
- Auto Scaling wired to the compute choice, not left as a manual/fixed fleet

## Data Layer Fit Checklist

Check:
- RDS vs self-managed MongoDB vs DocumentDB chosen deliberately, not by default/habit
- DocumentDB compatibility gaps (aggregation pipeline limits, index types) causing workarounds in app code
- ElastiCache (Redis/Memcached) present and actually used for the read-heavy paths that need it
- Read replicas or sharding considered if the primary DB is a bottleneck
- Database instance family/class matched to actual workload (compute-optimized vs memory-optimized)
- Multi-tenant data isolation strategy fits the chosen data layer (shared DB vs per-tenant)

## Edge & Networking Architecture Checklist

Check:
- CloudFront in front of static assets and/or API where latency or origin load justifies it
- Route 53 routing policy (simple/weighted/latency/failover) matches actual availability goals
- Load Balancer type (ALB vs NLB) matches the traffic (HTTP-layer vs raw TCP)
- VPC design has proper public/private subnet separation, with app and DB tiers isolated
- NAT Gateway usage justified vs VPC endpoints for AWS service traffic
- Multi-AZ subnet layout in place for the tiers that need high availability

## Supporting Services Checklist

Check:
- IAM structured around roles per service/function, not shared broad-access users or keys
- Secrets Manager (or Parameter Store) used for DB credentials and API keys instead of env files or hardcoded values
- CloudWatch set up with dashboards/alarms relevant to this architecture, not just default metrics
- WAF present on public-facing endpoints (ALB/CloudFront) with rules matched to the app's actual risk profile
- Backup strategy (AWS Backup, snapshots) covers every stateful service in the architecture, not just the primary DB

## Overall Architecture Coherence Checklist

Check:
- Services were chosen together as a system, not independently bolted on over time
- No single component (a database, a queue, a manual process) is a silent scaling ceiling for the rest
- Architecture matches team size/ops maturity (not over-engineered with services nobody can operate)
- Clear boundary between stateless (compute) and stateful (data) tiers throughout
- A new engineer could diagram the architecture from IaC/config alone without tribal knowledge

## Severity Levels

Use:
- Critical — architectural choice actively causing outages, data loss risk, or a hard scaling ceiling
- High — wrong-fit service choice that will cause a costly re-architecture if not addressed soon
- Medium — workable but suboptimal fit, causing avoidable cost or ops overhead
- Low — minor mismatch with limited near-term impact
- Improvement — architectural hygiene with no immediate risk

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Architecture fit score out of 10
