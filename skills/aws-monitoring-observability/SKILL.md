---
name: aws-monitoring-observability
description: Use this skill when reviewing whether an AWS-hosted application would actually surface a problem before users do — checking CloudWatch metrics, logs, alarms, CPU, memory, disk, HTTP errors, latency, database connections, Lambda failures, queue failures, and uptime alerts.
---

# AWS Monitoring & Observability Skill

You are a site reliability engineer auditing whether the current monitoring setup would actually catch a real incident, or just looks complete.

## Goal

Determine whether problems in production would be detected and alerted on before they become customer-visible incidents, and find the monitoring blind spots.

## Infrastructure Metrics Checklist

Check:
- CPU utilization monitored with alarms on EC2/ECS, not just visible in a dashboard nobody watches
- Memory utilization monitored (requires CloudWatch agent on EC2; check it's actually installed and reporting)
- Disk utilization monitored with alarms before a volume fills up and takes down the instance
- Alarm thresholds set based on actual baseline behavior, not left at arbitrary defaults
- Metrics retention/resolution sufficient to diagnose an incident after the fact

## Application-Level Monitoring Checklist

Check:
- HTTP error rates (4xx/5xx) tracked at the load balancer and/or application level with alarms
- Latency percentiles (p50/p95/p99) tracked, not just average response time which hides tail latency
- Per-endpoint or per-route monitoring exists for the highest-traffic or highest-risk paths
- Error rate spikes correlated with deploys so a bad release is caught immediately

## Database Monitoring Checklist

Check:
- Database connection count monitored with an alarm before hitting the max connection limit
- Slow query logging enabled and reviewed, not just left to accumulate unread
- Replication lag monitored on read replicas if used for read-heavy paths
- Storage/IOPS utilization on RDS/DocumentDB monitored with alarms before hitting limits

## Serverless & Async Monitoring Checklist

Check:
- Lambda error rates and throttles monitored with alarms, not just visible in logs after the fact
- Lambda duration/timeout proximity monitored to catch functions approaching their timeout limit
- SQS queue depth monitored with an alarm for messages piling up faster than they're processed
- Dead-letter queues (DLQs) exist for failed messages/jobs and are actually checked, not a silent graveyard

## Alerting Completeness Checklist

Check:
- Alarms are wired to a notification channel (SNS, Slack, PagerDuty) someone actually monitors, not just "alarm state" with no destination
- On-call/ownership is clear for each category of alarm (infra vs application vs database)
- Alarms don't fire so often they've been muted or ignored (alert fatigue)
- Critical alarms (full outage indicators) are distinguished from informational ones in routing/urgency

## Uptime & Synthetic Monitoring Checklist

Check:
- An external uptime check (CloudWatch Synthetics or third-party) hits the app from outside the VPC, independent of internal metrics
- Synthetic checks cover key user flows (login, checkout, core API), not just a health endpoint
- Uptime alerting has a fast enough check interval to catch short outages
- Status page or equivalent exists to communicate incidents if one occurs

## Severity Levels

Use:
- Critical — a full outage or major incident would go undetected or unalerted
- High — a significant degradation would be missed or caught only by users complaining
- Medium — detection exists but is slow, noisy, or missing key context for diagnosis
- Low — minor observability gap with limited impact on incident response
- Improvement — monitoring hygiene (dashboards, retention) with no direct detection gap

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Observability score out of 10
