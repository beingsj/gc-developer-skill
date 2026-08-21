---
name: funnel-analysis
description: Use this skill when reviewing where users drop off between entry and conversion in a SaaS product's funnel — after a redesign, during a conversion-rate investigation, or when a funnel report shows an unexplained drop at a specific step.
---

# Funnel Analysis Skill

You are a growth/analytics engineer diagnosing where and why users drop off in a product funnel, using existing event data and instrumentation rather than proposing a new feature.

## Goal

Determine where the largest drop-offs occur between funnel entry and conversion, whether each drop is technical or behavioral, and whether the instrumentation is good enough to trust the diagnosis.

## Funnel Definition Completeness Checklist

Check:
- The full intended funnel (landing → signup → activation → key action → conversion) is explicitly defined step by step, not assumed
- Every defined step has a corresponding tracked event with consistent naming and ordering
- No steps are skipped or merged in tracking that are meaningfully distinct in the actual user flow (e.g. "viewed pricing" and "clicked plan" collapsed into one event)
- Funnel definition matches the current product flow, not a stale version from before a redesign
- Optional/branching paths (e.g. skip onboarding, use social login) are accounted for so the funnel isn't artificially narrowed to one path

## Drop-Off Point Identification Checklist

Check:
- Step-over-step conversion rates are calculated correctly (each step as % of previous step, not % of total entrants) to find the true relative drop
- The step with the largest relative drop is identified and distinguished from steps with large absolute drop but normal relative rate
- Plausible UX reasons are considered for the top drop point (confusing copy, too many form fields, unexpected paywall, slow page load)
- Plausible technical reasons are considered for the top drop point (broken button, API error, validation bug, mobile layout issue)
- Drop-off is checked against historical baseline to confirm it's a real change, not normal variance

## Technical vs Behavioral Drop-Off Checklist

Check:
- Error rates/logs (API 4xx/5xx, JS console errors, failed form submissions) are checked for the drop-off step before concluding it's user choice
- Session recordings or equivalent qualitative signal are reviewed for the step to see if users are stuck vs. actively leaving
- A/B test or recent deploy history is checked for changes around the time the drop-off appeared or worsened
- Page load performance (especially on the drop-off step) is ruled out as a technical cause
- If no technical cause is found, the behavioral explanation is stated as a hypothesis, not a confirmed fact

## Segment Differences Checklist

Check:
- Drop-off rate is compared across device type (mobile vs desktop) to catch device-specific technical or UX issues
- Drop-off rate is compared across acquisition channel (paid vs organic vs referral) to catch expectation-mismatch or targeting issues
- Drop-off rate is compared across new vs returning users, and by plan/tier where relevant
- Any segment showing a materially worse drop-off is called out with a specific plausible fix, not just noted as "different"
- Segment sample sizes are large enough to be meaningful before drawing conclusions

## Instrumentation Gaps Checklist

Check:
- No funnel step is missing a tracked event, which would make drop-off at that step invisible rather than measured
- Step-order/sequence data (event timestamps, session ID) is available so steps can be reconstructed per user, not just aggregated counts
- Parameters needed to segment the funnel (device, channel, plan) are present on funnel events, not only on unrelated events
- There's no double-counting or missing dedup that would distort a step's apparent conversion rate
- If a gap is found, it's flagged as blocking accurate diagnosis rather than papered over with an assumption

## Severity Levels

Use:
- Critical — actively blocks indexing/tracking or produces materially wrong data
- High — significant gap in visibility/measurement
- Medium — noticeable gap, moderate impact
- Low — minor/cosmetic gap
- Improvement — enhancement suggestion

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority fixes
- Pages/events/flows inspected
- SEO/tracking health score out of 10
