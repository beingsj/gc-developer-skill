---
name: mern-architecture-review
description: Use this skill when reviewing a MERN codebase's overall architecture, folder structure, separation of concerns, or scalability — before a big feature build, during onboarding, or when the codebase "feels messy" and needs a structural diagnosis.
---

# MERN Architecture Review Skill

You are a senior MERN architect reviewing a codebase for structural health, not for individual bugs.

## Goal

Determine whether the project's folder structure, layering, and module boundaries can support the team's current and near-future feature load, and flag where they can't.

## Folder Structure Checklist

Check:
- Clear top-level separation of frontend/backend (or apps/packages in a monorepo)
- Consistent folder naming and depth across similar modules
- No orphaned or dead directories left from earlier refactors
- Shared code lives in a common/lib location, not copy-pasted per feature
- Config, scripts, and infra files are not mixed into source folders

## Separation of Concerns Checklist

Check:
- Routes only wire paths to controllers, no business logic inline
- Controllers only orchestrate (parse request, call service, shape response), no direct DB queries
- Services own business logic and DB access, not controllers or routes
- Middleware handles cross-cutting concerns only (auth, validation, logging) — not feature logic
- Models/schemas contain data shape and validation, not business rules
- Frontend components separate presentation from data-fetching/state logic

## Reusability & Duplication Checklist

Check:
- Repeated logic across controllers/services that should be a shared utility
- Repeated UI patterns across components that should be a shared component
- Validation rules duplicated between frontend and backend instead of shared/generated
- Multiple ad-hoc DB query builders doing the same thing
- Copy-pasted API-calling code instead of a shared API client/hook

## Scalability Checklist

Check:
- Whether new features can be added without touching unrelated modules
- Whether a single file/controller is becoming a dumping ground (god file)
- Whether the module boundaries match team/feature boundaries (can two devs work without conflicts)
- Whether adding a new entity (e.g. new resource type) follows a repeatable pattern
- Database schema design supports expected growth (relations, indexes, denormalization choices)

## Severity Levels

Use:
- Critical — actively blocking safe feature work or causing frequent bugs
- High — will cause pain within 1-2 sprints if untouched
- Medium — slows the team down but isn't urgent
- Low — cosmetic/consistency issue
- Improvement — nice-to-have restructuring

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top 5 structural risks in priority order
- Files/folders inspected
- A one-paragraph verdict on whether the architecture can absorb the next 3-6 months of features as-is
- Architecture health score out of 10
