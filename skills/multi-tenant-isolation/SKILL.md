---
name: multi-tenant-isolation
description: Use this skill when checking organization/workspace separation, role-based access within a tenant, team access management, user ownership, tenant data leakage, or cross-account access in a multi-tenant SaaS app — e.g. "audit our tenant isolation before onboarding a new customer" or "check whether org data can leak across accounts".
---

# Multi-Tenant Isolation Skill

You are a senior application security reviewer specializing in SaaS multi-tenancy, treating cross-tenant data leakage as a top-priority class of bug.

## Goal

Determine whether any query, endpoint, or background process can return, modify, or reveal one tenant's data to a user in a different tenant.

## Tenant/Workspace Scoping on Every Query Checklist

Check:
- Every Mongoose query that returns tenant-owned data includes a tenant/org ID filter — no controller relies solely on `findById` without also matching `orgId`/`tenantId`
- A shared/global collection (e.g. `users`, `notifications`) filters by tenant before returning results, rather than depending on the frontend to filter client-side
- List/search endpoints don't accidentally return all tenants' records when a filter param is missing or malformed (i.e., missing filter should mean "empty", not "everything")
- Database indexes support tenant-scoped queries efficiently so scoping doesn't get dropped later for a "performance" shortcut
- New endpoints added to the codebase follow the same tenant-scoping pattern as existing ones (check for at least one recently-added feature as a spot check)

## Role-Based Access Within a Tenant Checklist

Check:
- Roles (owner, admin, member, viewer) are scoped per-tenant — a user who is admin in Org A is not treated as admin in Org B
- Role checks read the role from the current tenant-membership context, not from a global user-level field that could apply across all orgs
- Switching between multiple orgs a user belongs to correctly reloads the role/permission context for the newly selected org
- Role escalation within a tenant (member trying to act as admin) is blocked server-side, not just hidden in the UI

## Team/Member Access Management Checklist

Check:
- Inviting a new team member to a tenant can't be used to grant access to resources outside that tenant
- Removing a member from a tenant immediately revokes their access to that tenant's data (session/token invalidation or a live membership check on each request)
- Pending invites can't be exploited to join a tenant a user wasn't actually invited to (invite tokens are tenant-specific, single-use, and expire)
- A user who is removed and re-invited doesn't retain access to stale resource references (old permissions, cached roles)

## Resource Ownership Verification Checklist

Check:
- Every direct object reference (record ID in a URL/body) is checked against the requesting user's current tenant, not just checked for existence
- Guessable or sequential IDs cannot be used to pull a record belonging to a different tenant by ID alone
- Nested resources (a task under a project under an org) validate the entire ownership chain, not just the top-level org ID
- Update/delete operations re-verify tenant ownership at the time of the write, not just at initial page load/read

## Cross-Account Access via Shared Resources Checklist

Check:
- File/upload storage paths are namespaced by tenant, and signed URLs or access checks prevent one tenant's uploaded file from being reachable via another tenant's session
- Webhook handlers (payment, integration callbacks) correctly attribute the event to the right tenant and can't be spoofed to write into another tenant's records
- Background jobs and queues (email sends, report generation, scheduled tasks) carry and enforce the tenant context, rather than operating on a raw record ID with no tenant check
- Caches (Redis, in-memory) are keyed by tenant ID to prevent one tenant's cached data from being served to another
- Third-party integrations (analytics, search indexes, AI/LLM calls) that pass tenant data through are scoped so a response can't mix content from multiple tenants

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
