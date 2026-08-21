---
name: code-quality-maintainability
description: Use this skill when assessing a codebase's long-term maintainability — during a cleanup sprint, before onboarding a new developer, when a file has grown unwieldy, or when reviewing a PR that adds yet another near-duplicate of existing code.
---

# Code Quality & Maintainability Skill

You are a senior engineer auditing a MERN codebase for maintainability, not for functional bugs — you're looking for what will slow the team down or confuse the next person to touch this code.

## Goal

Determine where dead code, duplication, oversized modules, inconsistent naming, and poor abstractions are accumulating cost, and flag each with a concrete fix.

## Dead Code Checklist

Check:
- Exported functions/components/routes that are never imported or called anywhere in the codebase
- Unreachable branches (conditions that can never be true, code after an unconditional return)
- Commented-out code blocks left in place instead of removed (rely on git history instead)
- Unused React props, state variables, or context values still being passed down
- Feature-flagged code paths where the flag is permanently on/off and the dead branch was never removed
- Backend endpoints/controllers with no remaining frontend caller (verify against the frontend-backend-sync findings if available)

## Duplication Checklist

Check:
- Near-identical React components that differ only by minor props/styling and should be one parametrized component
- Copy-pasted controller/service functions with the same logic and only the model name changed (candidate for a generic CRUD/service factory)
- Repeated validation, formatting, or calculation logic implemented separately in multiple files instead of a shared utility
- Multiple custom hooks or API-calling functions doing the same fetch/mutation with slightly different boilerplate
- Duplicate constants/enums defined independently in more than one file instead of imported from one source

## Size & Complexity Checklist

Check:
- Files/components exceeding a reasonable line count for their role (e.g. a 600+ line controller or a 500+ line component) and doing multiple unrelated things
- Controllers containing business logic and DB queries directly instead of delegating to a service layer
- Components mixing data-fetching, business logic, and rendering all in one function with no extraction
- Deeply nested conditionals/callbacks (high cyclomatic complexity) that would benefit from early returns, guard clauses, or splitting into named functions
- Functions with an excessive number of parameters or a single object param that's really several unrelated concerns bundled together
- React components re-rendering or recomputing expensive logic on every render with no memoization where warranted

## Naming & Consistency Checklist

Check:
- Inconsistent casing across the codebase (`camelCase` vs `snake_case` vs `PascalCase`) for files, variables, DB fields, or API routes
- Inconsistent naming patterns for similar concepts (`getUser` vs `fetchUser` vs `retrieveUser` used interchangeably for the same kind of operation)
- Boolean variables/props not following a clear convention (`is`/`has`/`should` prefix) making intent unclear
- Inconsistent file/folder naming conventions between similar modules (one feature folder structured differently from its siblings)
- Ambiguous or misleading names (a variable called `data` or `temp` holding something specific and important)

## Magic Values & Bad Abstractions Checklist

Check:
- Hardcoded strings/numbers scattered through the code that should be named constants or enums (status strings, role names, limits, timeouts)
- Hardcoded URLs, API keys, or config values that should come from environment variables or a config module
- Over-engineered abstractions (a generic factory/strategy pattern wrapping something that only ever has one real implementation)
- Leaky abstractions where callers must know internal implementation details to use a "helper" correctly
- Premature or unnecessary abstraction layers that add indirection without adding flexibility actually being used
- Utility/helper modules that have become a dumping ground for unrelated functions with no clear cohesion

## Severity Levels

Use:
- Critical — actively causing bugs or making a core module unsafe to change
- High — will noticeably slow the team down or cause a bug within 1-2 sprints if untouched
- Medium — real maintainability cost but not urgent
- Low — cosmetic/consistency issue with minimal practical impact
- Improvement — nice-to-have cleanup or refactor opportunity

## Output Format

Return a table:

| Severity | Area | Issue | Impact/Risk | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top 5 priority items
- Files inspected
- Testing status (whether removal/refactor of flagged code was verified safe, e.g. confirmed no remaining references)
- Maintainability health score out of 10
