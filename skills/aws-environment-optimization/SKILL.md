---
name: aws-environment-optimization
description: Use this skill when reviewing separation between Development, Staging, and Production environments — ensuring production never shares secrets, databases, or infrastructure with lower environments.
---

# AWS Environment Optimization Skill

You are a cloud infrastructure engineer auditing whether Development, Staging, and Production are genuinely isolated from each other.

## Goal

Determine whether production infrastructure, data, and secrets are fully isolated from development and staging, and flag any point where a lower environment could affect or expose production.

## Environment Isolation Checklist

Check:
- Dev, staging, and production run on genuinely separate infrastructure (separate EC2/ECS resources, not shared instances toggled by an env flag)
- Separate AWS accounts (or at minimum separate VPCs) used per environment rather than one flat account for everything
- Networking (VPC, security groups) between environments has no implicit trust or open routes
- Resource naming/tagging makes it unambiguous which environment a given resource belongs to, preventing accidental cross-environment changes

## Secrets Separation Checklist

Check:
- Production secrets (DB credentials, API keys, third-party tokens) never appear in dev/staging config, `.env` files, or CI variables
- Dev/staging use entirely separate third-party API keys (payment, email, etc.) from production, using sandbox/test modes where available
- Secrets Manager/Parameter Store paths are namespaced per environment, with IAM policies preventing a dev role from reading prod secrets
- No developer's local machine or lower-environment CI job holds production credentials "just in case"

## Database Separation Checklist

Check:
- Production database is a separate instance from dev/staging, never a shared instance with logical separation only
- Developers and lower-environment services have no network path or credentials to reach the production database
- Staging/dev databases are seeded with synthetic or anonymized data, not a live copy of production customer data
- Any process that copies production data down to lower environments anonymizes/strips PII before it lands

## Access Control Separation Checklist

Check:
- IAM roles/policies distinguish who can access production resources vs who can access dev/staging
- Production access requires additional controls (MFA, approval, break-glass process) beyond lower-environment access
- CI/CD deploy credentials for production are separate from those used for dev/staging pipelines
- Engineers' default access level does not include production by default; it's granted deliberately

## Configuration Drift Checklist

Check:
- Staging is similar enough to production (instance types, scaled-down but representative topology) that passing tests there is meaningful
- Infrastructure-as-code (Terraform/CDK/CloudFormation) defines all environments from the same templates with environment-specific parameters, not hand-diverged configs
- Feature flags and environment variables are tracked so staging and production don't silently diverge in behavior
- Dependency/package versions are kept in sync across environments to avoid "works in staging, breaks in prod" surprises

## Promotion Process Checklist

Check:
- Code and config promotion follows a defined path: dev to staging to production, not ad hoc direct-to-prod changes
- Database migrations are tested in staging before being applied to production, with a clear promotion gate
- Configuration changes (env vars, feature flags) go through the same review/promotion process as code
- Rollback of a bad promotion is possible without needing to re-derive what changed between environments

## Severity Levels

Use:
- Critical — production data, secrets, or infrastructure is directly reachable or shared with a lower environment right now
- High — a lower-environment failure or compromise could plausibly affect production
- Medium — isolation exists but has gaps that weaken the boundary
- Low — minor separation gap with limited exposure
- Improvement — environment hygiene (naming, IaC consistency) with no direct exposure risk

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Environment isolation score out of 10
