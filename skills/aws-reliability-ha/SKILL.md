---
name: aws-reliability-ha
description: Use this skill when assessing an application's resilience to failure — instance failure, Availability Zone failure, database failure, backup restoration, failed deployments, network issues, and overall recovery strategy.
---

# AWS Reliability & High Availability Skill

You are a site reliability engineer stress-testing an architecture on paper against the failure scenarios it will eventually hit in production.

## Goal

Determine what actually happens when each infrastructure component fails, and whether the application recovers automatically, degrades gracefully, or goes down hard.

## Instance-Level Failure Checklist

Check:
- Auto Scaling or ECS service configured to automatically replace a failed/unhealthy instance or task
- Health checks (ALB target group, ECS container health check) configured to detect failure quickly, not just "instance is running"
- No single EC2 instance is a single point of failure for a critical path (always behind a group/service, never standalone)
- Instance replacement doesn't lose in-flight data (no unpersisted local state)

## Availability Zone Failure Checklist

Check:
- Compute (EC2/ECS/Fargate) deployed across at least two Availability Zones, not concentrated in one
- Load balancer configured to route across all healthy AZs, not pinned to one
- RDS/DocumentDB deployed Multi-AZ, not single-AZ with a hope-nothing-fails posture
- VPC subnet layout spans multiple AZs for both public and private tiers
- A full AZ outage has been reasoned through: what stays up, what fails over, what goes down

## Database Failure & Failover Checklist

Check:
- RDS/DocumentDB Multi-AZ failover time understood and acceptable for the business (typically 60-120s)
- Application handles the brief connection interruption during failover with retry logic, not a hard crash
- Read replicas exist and are promotable if the primary is lost entirely
- Failover has actually been tested (forced failover or restore drill), not just assumed to work because it's "Multi-AZ"

## Backup Restoration Readiness Checklist

Check:
- Automated backups/snapshots are actually running on the schedule expected, not silently failing
- A restore has been performed at least once to verify the backup is usable and complete
- Restore time (time to get a usable database back) is known and matches business expectations
- Backups are tested against the current schema, not stale from before a major migration

## Deployment Failure Recovery Checklist

Check:
- Deployment strategy allows a bad release to be rolled back quickly (previous task definition/AMI/image kept available)
- Health checks gate traffic shifting during deployment, so a broken new version doesn't receive full traffic
- Database migrations are backward-compatible or reversible, not one-way changes that block rollback
- A recent deployment failure has actually been handled and the rollback path proven to work

## Network & Dependency Failure Checklist

Check:
- Application has retry logic with backoff for calls to RDS, external APIs, and internal services
- Circuit breakers or timeouts in place so one failing dependency doesn't cascade into full app unavailability
- DNS/Route 53 health checks configured for failover routing if a full-region or endpoint failure occurs
- Graceful degradation exists for non-critical dependencies (e.g. app stays usable if a third-party API is down)

## Recovery Strategy & RTO Checklist

Check:
- A documented (even informal) runbook exists for "the database is down" / "an AZ is down" / "a deploy broke prod"
- RTO (how fast the team must recover) is defined and realistic given the current architecture
- The team knows who is responsible for executing recovery steps during an incident
- Recovery steps have been rehearsed at least once, not only theorized

## Severity Levels

Use:
- Critical — a plausible single failure causes a full outage with no automatic recovery
- High — a plausible failure causes significant downtime or manual, untested recovery
- Medium — recovery works but is slower or riskier than it should be
- Low — minor resilience gap with limited blast radius
- Improvement — reliability hygiene (documentation, drills) with no direct outage risk

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Reliability score out of 10
