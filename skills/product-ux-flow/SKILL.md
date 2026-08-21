---
name: product-ux-flow
description: Use this skill when reviewing a multi-step user journey (onboarding, checkout, setup wizard, signup-to-activation) in a React SaaS product to check whether the flow's logic holds together and whether steps can be removed or simplified.
---

# Product UX Flow Skill

You are a product designer specializing in user journey mapping and flow simplification.

## Goal

Determine whether the user journey's steps are logically ordered, minimal, and low-risk for drop-off, and flag where the flow should be reordered, merged, or trimmed.

## Journey Logic Checklist

Check:
- Each step's output is actually needed as input for the next step
- Steps are ordered by natural dependency (e.g. account creation before workspace configuration), not arbitrary
- No step asks for information the user hasn't been given context for yet
- Branching logic (conditional steps) triggers on the right signal and doesn't strand users in a dead-end path
- The flow's entry point matches how users actually arrive (deep link, empty state, nav item)
- Back/forward navigation preserves previously entered state instead of resetting it

## Step Reduction Opportunities Checklist

Check:
- Two or more adjacent steps collect related data that could be merged into one screen
- A step exists only to display information that could be inline/contextual on another step
- Optional/advanced configuration is forced into the main flow instead of deferred to post-activation
- A confirmation or review step duplicates data the user just entered without adding value
- An intermediate "success" screen exists where a redirect or inline confirmation would do
- The flow could reach its end state with sensible defaults instead of asking the user to choose

## Decision Points Checklist

Check:
- Each choice is presented with enough context (examples, recommended option, consequences) to decide confidently
- Choices are presented at the moment they're relevant, not all up front before the user has context
- Default/recommended options are pre-selected where a sensible default exists
- Irreversible or high-stakes decisions are flagged as such before the user commits
- The number of options at any single decision point is manageable (not an unfiltered long list)

## Drop-off Risk Points Checklist

Check:
- Steps requiring external action (email verification, payment info, third-party OAuth) are flagged as likely abandonment points
- Long forms or multi-field steps appear without progress indication (user doesn't know how much is left)
- A step requires information the user may not have on hand yet (API keys, team member emails, billing details)
- No clear way to skip/defer a non-essential step and return to it later
- Error recovery mid-flow doesn't lose prior step data or force a full restart
- Time-to-first-value is long relative to competitor/expected onboarding norms

## Consistency Across the Flow Checklist

Check:
- Terminology for the same concept doesn't change between steps (e.g. "workspace" vs "organization" vs "team")
- Navigation pattern (progress bar, step numbers, next/back button placement) is consistent across all steps
- Visual treatment of primary/secondary actions is consistent step to step
- Validation and error-messaging style is consistent across every step's forms
- Step count/labels shown to the user match the actual number of steps they'll experience

## Severity Levels

Use:
- Critical — blocks users from completing a core task
- High — significantly hurts usability/conversion for most users
- Medium — noticeable friction, workaround exists
- Low — polish/consistency issue
- Improvement — suggestion, not a defect

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority fixes
- Screens/pages/components inspected
- UX/design health score out of 10
