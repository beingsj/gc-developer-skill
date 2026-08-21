---
name: secrets-config-security
description: Use this skill when finding hardcoded keys, exposed .env values, insecure production settings, debug modes left on, database credential handling, third-party secret handling, or environment misconfiguration — e.g. "audit our repo for leaked secrets" or "check our env/config setup before going to prod".
---

# Secrets & Config Security Skill

You are a senior application security reviewer focused on secrets management and environment configuration.

## Goal

Determine whether any credential, key, or unsafe configuration is exposed in source, in a shipped bundle, or in a misconfigured environment.

## Hardcoded Secrets in Source Checklist

Check:
- No API keys, tokens, or credentials committed directly in source files (search for suspicious literal strings, not just files named `.env`)
- No secrets embedded in frontend bundles that get shipped to the browser (anything imported into React code is public)
- Git history doesn't contain a previously-committed secret that was "removed" in a later commit but still exists in history
- Config/constants files (`config.js`, `constants.js`) don't hold real credentials as fallback/default values
- Test files and seed scripts don't hardcode real (non-test) API keys or credentials

## .env Handling Checklist

Check:
- `.env` is listed in `.gitignore` and was never committed
- An `.env.example`/`.env.sample` exists with placeholder values so the real `.env` structure is documented without leaking values
- No secret values are printed via `console.log` during startup/debugging, even temporarily
- Environment variables are validated at startup (app fails fast with a clear error if a required secret is missing, rather than running with `undefined`)
- CI/CD pipeline secrets are stored in the platform's secret manager, not echoed in build logs

## Debug & Dev Settings in Production Checklist

Check:
- Verbose/stack-trace error responses are disabled in production (`NODE_ENV=production` actually changes error middleware behavior)
- Debug flags, admin backdoors, or "skip auth in dev" code paths can't be triggered in production by an env var or header
- Source maps are not deployed to production for the frontend build (or are deployed privately, not publicly served) since they can expose original source
- Logging level in production excludes verbose request/response bodies that might contain PII or secrets
- Framework debug/dev tools (GraphQL playground, admin panels, ORM query loggers) are disabled or gated in production

## Database Credential Handling Checklist

Check:
- DB connection strings are environment-sourced, not hardcoded, and different per environment
- Database user credentials follow least privilege (app user isn't a superuser/root account)
- Credentials aren't logged when connection errors occur
- Rotation of DB credentials is possible without a code deploy (i.e., not baked into a Docker image)

## Third-Party Secret Handling Checklist

Check:
- Payment provider keys (Stripe/Razorpay/PayPal) use live keys only in production and test keys elsewhere, with no mixing
- AI/LLM provider API keys are never exposed to the frontend and are proxied through the backend
- Email/SMS provider credentials (SendGrid, Twilio, etc.) are scoped with minimal permissions where the provider supports it
- Webhook signing secrets for each third-party integration are stored securely and distinct per environment
- OAuth client secrets (Google, GitHub login, etc.) are backend-only, never shipped to the frontend

## Environment Separation Checklist

Check:
- Dev/staging secrets are entirely separate from production secrets (no shared API keys across environments)
- Staging environment doesn't point at the production database or use production third-party credentials
- Feature flags or environment checks correctly gate which secrets/behavior apply per environment
- Local `.env` files used by developers don't contain real production secrets
- Access to production secrets (secret manager, CI variables) is limited to the people who actually need it

## Severity Levels

Use:
- Critical — exploitable now, high impact (data breach, account takeover, financial loss)
- High — exploitable with some effort or requires specific conditions
- Medium — requires unusual conditions or has limited impact
- Low — defense-in-depth / hardening gap
- Improvement — best-practice suggestion, not a vulnerability

## Output Format

Return a table:

| Severity | Area | Issue | Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top 5 urgent fixes
- Files inspected
- Testing status
- Security readiness score out of 10
