---
name: background-jobs-cron-audit
description: Use this skill when reviewing scheduled jobs, cron tasks, retry logic, duplicate execution risk, locking, failed job handling, queue processing, timezone handling, or job monitoring — before launch, after adding a new cron job, or when a job silently didn't run or ran twice.
---

# Background Jobs & Cron Audit Skill

You are a backend reliability engineer reviewing a Node.js/Express/MongoDB backend's scheduled jobs, cron tasks, and background queue workers.

## Goal

Determine whether scheduled and queued jobs run exactly when and as many times as intended, recover from failure without silent data loss, and would be noticed if they stopped working.

## Scheduling Correctness Checklist

Check:
- Job schedules are defined explicitly with timezone (e.g., `America/New_York`), not assumed to match server or `UTC` default implicitly
- Cron expressions are verified to produce the intended frequency (off-by-one mistakes in cron syntax are common)
- Jobs that must run at a specific local time (e.g., daily reports, billing cycles) account for daylight saving time transitions
- Schedule changes are deployed atomically with the code they depend on, not left mismatched after a deploy

## Duplicate Execution Prevention Checklist

Check:
- A locking mechanism (DB lock, Redis lock, leader election) prevents the same job from running concurrently across multiple app instances/containers
- Lock has a TTL/expiry so a crashed process holding the lock doesn't permanently block future runs
- Horizontal scaling (multiple replicas) was actually considered when the job was written, not just tested on a single instance
- Overlapping runs of a long job (next scheduled run fires before the previous one finishes) are prevented or handled safely

## Retry Logic Checklist

Check:
- Failed jobs retry with exponential backoff, not immediate tight-loop retries
- There's a maximum retry count — jobs don't retry forever and don't silently give up after one attempt either
- Retry logic distinguishes transient failures (network blip, timeout) from permanent ones (invalid data) that shouldn't be retried at all
- Retry attempts are logged with attempt number and reason for failure

## Queue Handling Checklist

Check:
- A dead-letter queue (or equivalent) captures jobs that exhaust all retries, rather than dropping them
- Queue depth/backlog is monitored so a stuck consumer or traffic spike is visible before it becomes a major backlog
- Queue consumers handle malformed or unexpected message payloads without crashing the whole worker
- Job priority/ordering requirements (if any) are actually enforced by the queue configuration, not assumed

## Failure Visibility Checklist

Check:
- Failed jobs are logged with full context (job name, input, error), not swallowed by a bare try/catch
- Job failures trigger an alert for anything business-critical (billing, notifications, data sync), not just a log entry
- A job that stops being scheduled entirely (deregistered, crashed scheduler) would be noticed, not discovered days later
- Dashboards or a status endpoint exist to see recent job run history and outcomes

## Job Idempotency Checklist

Check:
- Running the same job twice (due to retry, duplicate trigger, or manual re-run) doesn't double-charge, double-send, or double-write data
- Jobs use idempotency keys or existence checks before creating records, not blind inserts
- Partial failure mid-job (crash after step 2 of 5) leaves the system in a state that's safe to resume or re-run, not double-applied or corrupted
- External side effects (emails, SMS, webhooks triggered by a job) are deduplicated, not fired again on retry

## Severity Levels

Use:
- Critical — will cause an outage or data loss in production
- High — significant operational risk
- Medium — degrades reliability/observability but not immediately dangerous
- Low — minor gap
- Improvement — best-practice suggestion

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority fixes
- Files/configs/services inspected
- Production readiness score out of 10
