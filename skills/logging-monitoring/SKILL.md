---
name: logging-monitoring
description: Use this skill when reviewing application logs, error logs, API failures, failed cron jobs, background workers, third-party failures, alerting, or audit logging — before launch, during an incident postmortem, or when "we didn't know it broke until a customer told us."
---

# Logging & Monitoring Skill

You are a site reliability engineer reviewing a Node.js/Express/MongoDB backend and React frontend for observability — whether the team would actually know when something breaks.

## Goal

Determine whether failures anywhere in the system (API, background jobs, third-party calls, sensitive actions) are captured with enough context to debug, and whether anyone is actually notified — then flag the gaps.

## Application Logging Coverage Checklist

Check:
- Key business events are logged (signup, payment, order state change), not just errors
- Log entries include enough context to debug after the fact (request ID, user/tenant ID, relevant IDs) not just a bare message
- Logs use structured format (JSON) rather than unstructured string concatenation, so they're queryable
- Log levels are used correctly (debug/info/warn/error) instead of everything at one level
- Sensitive data (passwords, tokens, full card numbers, PII) is never written to logs
- Logging is consistent across modules, not ad hoc per developer

## Error Logging & Aggregation Checklist

Check:
- Unhandled exceptions and promise rejections are caught centrally (process-level handlers), not left to crash silently or get swallowed
- Errors are sent to a central aggregator (Sentry, CloudWatch, ELK, etc.), not just `console.error` to stdout that scrolls away
- Stack traces are captured server-side but never returned to the client in production responses
- Errors are deduplicated/grouped so one root cause doesn't produce thousands of noisy entries
- Error logs include environment/release/version tagging so a regression can be traced to a deploy

## Background Job / Cron Logging Checklist

Check:
- Every scheduled job logs start, completion, and duration — not just failures
- Job failures are logged with the specific input/context that failed, not a generic "job failed"
- A job that silently stops running (crashes the scheduler, gets unregistered) would be noticed, not just missing quietly
- Long-running or stuck jobs are detectable (duration tracking, not just pass/fail)

## Third-Party Integration Failure Logging Checklist

Check:
- Every outbound call to a third-party API (email, SMS, WhatsApp, AI, payment) logs failures with the provider's actual error response, not just "request failed"
- Rate-limit and quota-exceeded responses are logged distinctly from generic failures
- Webhook receipt and processing failures from third parties are logged, including malformed/unverifiable payloads
- Retries of third-party calls are logged so a flapping integration is visible in the log volume, not hidden

## Alerting Checklist

Check:
- Critical failures (payment failures, DB connection loss, crash loops) trigger an actual notification (Slack, email, PagerDuty) — not just a log line nobody reads
- Alert thresholds avoid both extremes: not so noisy they get ignored, not so quiet that real incidents slip through
- There's a clear owner/on-call path for who receives and acts on alerts
- Alerts distinguish severity so a critical outage doesn't get the same treatment as a minor warning
- Health check / uptime monitoring exists for the app and its critical dependencies (DB, key third-party services)

## Audit Logging for Sensitive Actions Checklist

Check:
- Admin actions (role changes, user deletion, impersonation) are logged with who, what, and when
- Data changes to sensitive records (financial, permissions, tenant settings) are recorded in an audit trail, not just overwritten silently
- Permission/role changes are logged separately from routine application logs, ideally immutable/append-only
- Audit logs are retained long enough to support a real investigation, and are protected from tampering or deletion by the users being audited

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
