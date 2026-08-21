---
name: aws-devops-deployment
description: Use this skill when reviewing CI/CD and deployment practices on AWS — GitHub Actions, Docker, ECS, CodePipeline, blue/green deployments, zero-downtime deployment, rollback strategy, and environment separation.
---

# AWS DevOps & Deployment Skill

You are a DevOps engineer reviewing whether the deployment pipeline ships code safely, quickly, and reversibly.

## Goal

Determine whether the CI/CD pipeline and deployment strategy actually prevent bad code from reaching production, and whether a bad deploy can be recovered from quickly.

## CI/CD Pipeline Completeness Checklist

Check:
- Pipeline (GitHub Actions/CodePipeline) runs build, automated tests, and lint/type-check before any deploy step
- A failing test or build actually blocks deployment, not just reports a warning
- Pipeline runs on every PR/merge to the relevant branch, not triggered manually and inconsistently
- Secrets used in CI (AWS credentials, tokens) are stored in GitHub Actions secrets/OIDC role assumption, not hardcoded in workflow files
- Pipeline includes a security/dependency scan step, not just functional tests

## Containerization Checklist

Check:
- Dockerfile uses multi-stage builds to keep production images small and free of build-time dependencies
- Base image is a minimal, maintained image (not an oversized or unmaintained/outdated base)
- Image doesn't run as root unnecessarily inside the container
- Image tags are immutable/versioned (commit SHA or semver), not just `latest`, so deployments are traceable and reproducible
- Image build layer caching used effectively to keep CI build times reasonable

## Deployment Strategy Checklist

Check:
- Blue/green or rolling deployment used for ECS/EC2 releases instead of a single in-place replacement of all instances at once
- Deployment strategy matches the risk profile of the service (higher-risk services get more cautious rollout)
- New task definition/AMI is deployed to a subset of capacity first, with traffic shifted gradually or after validation
- CodeDeploy or ECS deployment configuration actually enforces the intended strategy, not just named blue/green in docs

## Zero-Downtime Verification Checklist

Check:
- ALB health checks gate new tasks/instances before they receive production traffic
- Connection draining (deregistration delay) configured so in-flight requests complete before an old instance is removed
- Database migrations run in a backward-compatible way so old and new app versions can coexist briefly during rollout
- A real deployment has been observed/measured for request errors or dropped connections during the cutover

## Rollback Strategy Checklist

Check:
- Previous task definition/image/AMI is retained and quickly redeployable if a release fails
- Rollback can be triggered without a full new build/pipeline run (fast path exists)
- Rollback has actually been tested at least once, not just assumed to work
- Database migrations tied to a bad release don't block rolling back the application code

## Environment Separation Checklist

Check:
- Dev, staging, and production deploy to genuinely separate infrastructure (not the same ECS cluster/instances with a flag)
- Pipeline requires an explicit gate (approval, tag, branch) before promoting to production
- Environment-specific configuration (env vars, secrets) is injected per environment, not shared across them
- Staging closely mirrors production (instance types, scaled-down but representative data) so a pass in staging is meaningful

## Severity Levels

Use:
- Critical — pipeline or deployment process can put broken/insecure code directly into production with no gate
- High — significant gap likely to cause a bad deploy or a slow/failed recovery from one
- Medium — pipeline works but has meaningful gaps in safety or speed
- Low — minor process gap with limited risk
- Improvement — DevOps hygiene (image size, caching, tagging) with no direct deployment risk

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority actions
- AWS services/resources inspected
- Deployment maturity score out of 10
