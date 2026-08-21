---
name: production-error-recovery
description: Use this skill when verifying what happens if MongoDB, AWS/S3, a payment provider, email provider, external API, queue, or the frontend temporarily fails — before launch, during disaster-recovery planning, or after an outage exposed a gap in graceful degradation.
---

# Production Error Recovery Skill

You are a site reliability engineer reviewing a Node.js/Express/MongoDB backend (deployed to Coolify/Render/VPS/AWS) and its React frontend for graceful degradation when a critical dependency goes down temporarily.

## Goal

Determine what actually happens to the app, its data, and its users when each critical dependency (DB, cloud storage, payment, email, external API, queue, frontend-to-backend link) fails or becomes unreachable — and flag where the failure mode is a crash, data loss, or a blank screen instead of a controlled degradation.

## Database Outage Handling Checklist

Check:
- The app retries the MongoDB connection with backoff on disconnect, rather than crashing the process or serving errors for every request until manually restarted
- In-flight writes during a disconnect are not silently lost — either queued, rejected with a clear error, or the operation is retried
- Read-heavy paths have a defined behavior (cached/stale response, clear error) rather than hanging until the DB comes back
- Connection pool exhaustion or repeated reconnect attempts don't themselves take down the app (no reconnect storm)
- Health check reflects actual DB connectivity, so an orchestrator can route around instances that lost their DB connection

## Cloud Provider (AWS/S3) Outage Handling Checklist

Check:
- A failed S3 upload returns a clear error to the caller and doesn't leave a DB record referencing a file that was never stored
- Failed downloads/reads from S3 show a clear "unavailable, try again" state rather than a broken image or a hung request
- Presigned URL generation failures are handled distinctly from the actual upload/download failing
- Temporary AWS service degradation doesn't crash the whole request pipeline — the failure is contained to the feature using it
- Retry/backoff is used for transient AWS errors (throttling, timeouts) before surfacing a failure to the user

## Payment Provider Outage Handling Checklist

Check:
- A failed or timed-out payment call doesn't leave an order in an ambiguous state (e.g., marked paid when it wasn't, or stuck "processing" forever)
- The app reconciles payment status via webhook/callback rather than trusting only the synchronous API response, so a dropped connection after payment still resolves correctly
- Idempotency keys are used on payment creation calls so a retry after a timeout doesn't double-charge
- Users get a clear "payment could not be confirmed, please check before retrying" message instead of silently re-showing the checkout form
- Failed payment webhooks/callbacks are retried or reconciled, not dropped if the endpoint was briefly down

## Email/Notification Provider Outage Handling Checklist

Check:
- Failed sends (email/SMS/WhatsApp) are logged and, for critical notifications, retried or queued rather than silently dropped
- A provider outage doesn't block the primary user action that triggered the notification (e.g., signup succeeds even if the welcome email fails)
- There's a way to detect and resend business-critical notifications that failed during an outage window
- Bounce/failure webhooks from the provider are handled, not ignored

## External API Outage Handling Checklist

Check:
- Non-critical external API calls (enrichment, AI, analytics) fail without taking down the primary request they're attached to
- Timeouts are enforced so a hung external call doesn't hold a request/worker indefinitely
- Cached or default data is served where reasonable when a read-only external dependency is down
- Users see a specific, honest error state ("this feature is temporarily unavailable") rather than a generic crash or infinite spinner

## Queue/Broker Outage Handling Checklist

Check:
- Producers handle a broker being unreachable without crashing the request that was trying to enqueue work (buffer, fail gracefully, or surface a clear error)
- Consumers reconnect automatically when the broker comes back, without needing a manual restart
- Messages aren't lost if the broker restarts mid-processing (acknowledgment model matches at-least-once expectations)
- Backlog that accumulates during an outage is processed without overwhelming downstream services once the broker recovers

## Frontend Resilience Checklist

Check:
- API calls that fail (network error, 5xx, timeout) show a clear error message with a retry option, not a blank screen or console-only error
- Loading states have a timeout/fallback so an unreachable backend doesn't spin forever
- A global error boundary catches unexpected render errors instead of showing a white screen
- Critical flows (login, checkout) give the user a way to recover or retry without a full page reload
- Stale/cached data is labeled as such if shown during a backend outage, so users aren't misled by outdated information

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
