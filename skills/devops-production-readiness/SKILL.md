---
name: devops-production-readiness
description: Use this skill when reviewing Docker, Nginx/reverse proxy, environment variables, SSL, process managers, container health, server restarts, or deployment/rollback setup — before a production deploy, after infra changes, or when a deploy has gone wrong and needs a structural diagnosis.
---

# DevOps Production Readiness Skill

You are a DevOps engineer reviewing a Node.js/Express/MongoDB backend (deployed via Docker to Coolify, Render, a VPS, or AWS) and its React frontend for deployment and infrastructure health.

## Goal

Determine whether the deployment pipeline, container setup, and server configuration can survive a bad deploy, a crash, or a certificate expiry without manual firefighting — and flag where they can't.

## Containerization Checklist

Check:
- Dockerfile uses a pinned base image tag, not `latest`
- Multi-stage build used so dev dependencies and build tools don't ship in the final image
- Image runs as a non-root user, not root
- `.dockerignore` excludes `node_modules`, `.env`, `.git`, and build artifacts
- Final image size is reasonable for the app (no unnecessary layers, caches, or dev tooling baked in)
- Container exposes the correct port and the app binds to `0.0.0.0`, not `localhost`
- Build args/secrets aren't baked into image layers (no `ARG`/`ENV` leaking credentials into `docker history`)

## Reverse Proxy / Nginx Checklist

Check:
- Routing correctly separates API traffic from static frontend assets
- Required headers are forwarded (`X-Forwarded-For`, `X-Forwarded-Proto`, `Host`) so the app sees real client IP/protocol
- Gzip/Brotli compression enabled for text assets
- Proxy timeouts are set explicitly and long enough for slow endpoints (file upload, report generation) without hanging forever
- Client body size limit (`client_max_body_size`) matches what the app's upload limits expect
- WebSocket/long-lived connection upgrade headers configured if the app uses them

## Environment Variable Management Checklist

Check:
- All required env vars are documented (`.env.example` kept in sync with actual usage)
- App fails fast with a clear error at startup if a required var is missing, rather than crashing later mid-request or silently using `undefined`
- No secrets committed to the repo or baked into the Docker image
- Different values correctly scoped per environment (dev/staging/prod), especially API base URLs and DB connection strings
- Secrets are injected via the platform's secret store (Coolify/Render/AWS Secrets Manager), not plain env files on disk where avoidable

## SSL/TLS Checklist

Check:
- Valid certificate for the production domain (and any subdomains in use)
- Renewal is automated (Let's Encrypt/Certbot cron or platform-managed), not a manual yearly task
- HTTP requests are force-redirected to HTTPS, not left accessible in parallel
- HSTS header set appropriately
- Certificate covers all domains the app actually serves (API subdomain, www/non-www variants)

## Process Management Checklist

Check:
- A process manager (PM2, systemd, or the container orchestrator's own restart policy) is configured to auto-restart the app on crash
- Restart policy has backoff/limits so a crash loop doesn't hammer the CPU or DB indefinitely
- Multiple app instances/cluster mode used if the host has multiple cores worth exploiting
- Logs from the process manager are captured, not lost on restart
- Zero-downtime restart (graceful reload) used for deploys where the platform supports it

## Container/Service Health Checks Checklist

Check:
- A dedicated health check endpoint exists and verifies real dependencies (DB connectivity), not just "process is alive"
- Docker/orchestrator health check is configured with sane interval, timeout, and retry values
- Unhealthy containers are actually removed from rotation/restarted, not left serving traffic
- Health check doesn't itself become a load-bearing bottleneck (e.g., hammering the DB every second)

## Deployment & Rollback Checklist

Check:
- A bad deploy can be reverted to the previous working image/build quickly, without a manual rebuild
- Previous image/build artifacts are retained (not overwritten immediately) so rollback has something to roll back to
- Deploys run required migrations in the correct order relative to app restart
- There's a documented or scripted rollback procedure, not tribal knowledge
- Deploy pipeline runs a smoke test (or at least a health check) before routing full traffic to the new version

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
