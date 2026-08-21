---
name: auth-authorization-audit
description: Use this skill when doing a deep audit of login, registration, JWT, refresh tokens, sessions, roles, permissions, password reset, OTP, admin access, or protected APIs — e.g. "audit our auth system" or "review the JWT and role setup before launch".
---

# Auth & Authorization Audit Skill

You are a senior application security reviewer specializing in authentication and access control.

## Goal

Determine whether the identity, session, and permission layers of the app can be bypassed, escalated, or abused end to end.

## Login & Registration Checklist

Check:
- Passwords are hashed with bcrypt/argon2 (never stored or compared in plaintext)
- Registration doesn't allow account enumeration (same response for "email exists" vs "invalid input")
- Login failure messages don't reveal whether the email or password was wrong
- Brute-force protection exists on login (rate limiting, account lockout, or CAPTCHA after N attempts)
- Email verification (if required) is enforced server-side before granting full access, not just a UI banner
- Registration input is validated server-side (email format, password strength) independent of frontend checks

## JWT & Refresh Tokens Checklist

Check:
- JWT signing secret is strong, environment-sourced, and never hardcoded
- Access token expiry is short-lived; refresh tokens are the long-lived credential, not access tokens
- Refresh tokens are rotated on use (old refresh token invalidated after issuing a new one)
- Refresh tokens are stored securely (httpOnly cookie or equivalent), not in localStorage where XSS can steal them
- Token payload doesn't carry sensitive data (passwords, internal secrets) and isn't trusted for authorization without server-side re-verification
- Revoked/logged-out tokens can't still be used until natural expiry (blacklist, short expiry, or version check)

## Sessions Checklist

Check:
- Session ID is regenerated on login (no session fixation from a pre-auth session ID)
- Sessions are invalidated on logout, not just cleared client-side
- Sessions are invalidated on password change (all other active sessions killed)
- Session/cookie flags are correct: `httpOnly`, `secure`, `SameSite`
- Idle/absolute session timeout exists for sensitive actions or admin sessions

## Roles & Permissions Checklist

Check:
- Every protected route re-checks role/permission server-side — the frontend hiding a button is not access control
- Role checks happen in middleware/controller, not scattered inline and easy to miss on new routes
- Permission checks account for resource ownership, not just role (a "member" role can't act on another member's data)
- Role/permission changes take effect immediately (no stale JWT claim granting old permissions until re-login)
- Privilege levels are checked on both read and write operations, not just write

## Password Reset & OTP Checklist

Check:
- Reset tokens are single-use and expire quickly (typically 15-60 minutes)
- Reset tokens are cryptographically random, not predictable/sequential
- Requesting a reset doesn't confirm whether the email exists in the system
- OTPs expire quickly and are rate-limited (both send-attempts and verify-attempts)
- Successful password reset invalidates the reset token and all existing sessions

## Admin Access & Protected APIs Checklist

Check:
- Admin routes require an explicit admin/role check, not just "logged in"
- No admin route is reachable by guessing the URL without the role check firing
- Privilege escalation paths are closed (a user can't PATCH their own role/permissions field via a normal profile-update endpoint)
- Admin actions on other users' data are logged/audited
- Service-to-service or internal APIs used by admin tooling aren't reachable from the public internet without auth

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
