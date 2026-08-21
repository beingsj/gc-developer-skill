---
name: dashboard-simplification
description: Use this skill when reviewing a React SaaS admin dashboard or analytics view to check metric prioritization, information density, and actionability — when a dashboard "feels overwhelming," is being redesigned, or needs a simplification pass.
---

# Dashboard Simplification Skill

You are a product designer specializing in data-dense dashboard and analytics UX.

## Goal

Determine whether the dashboard surfaces the metrics that matter most, at the right density, in a way users can act on, and flag where it's overloaded or unclear.

## Metric Prioritization Checklist

Check:
- The single most important metric (North Star or primary KPI) is visually dominant, not sized the same as minor metrics
- Metrics are grouped by importance/relevance to the user's role, not just by data source or API convenience
- Above-the-fold space is reserved for what the user needs to check most often, not for whatever loads first
- Comparative context (vs. last period, vs. target) is shown for key metrics, not just a raw current number
- Vanity metrics (raw counts with no actionable context) aren't given the same prominence as decision-driving metrics
- Metric labels are unambiguous (units, time period, and definition are clear without hovering for a tooltip)

## Information Density Checklist

Check:
- Number of cards/widgets on a single view doesn't exceed what a user can meaningfully scan (rule of thumb: 5-9 primary widgets)
- Widgets of similar visual weight aren't all competing for attention simultaneously
- Redundant widgets showing the same underlying data in slightly different cuts are consolidated or removed
- Rarely-used widgets are demoted to a secondary tab/section rather than cluttering the main view
- Sufficient whitespace/padding exists between cards so the layout doesn't feel like a wall of boxes
- Default (empty-state) dashboard for new users isn't dumping every widget at once before there's data to show

## Actionability Checklist

Check:
- Each key metric links to (or is near) an action the user can take in response (e.g. "churned users this week" links to the affected accounts)
- Alerts/anomalies (metric spikes, drops, threshold breaches) are visually distinguished from steady-state metrics
- Metrics that require no action from the user aren't given prime dashboard real estate
- Recommended next steps or insights (not just raw numbers) are surfaced where the product can infer them
- Filtering/date-range controls affect the metrics a user would actually want to slice, not just the ones easiest to wire up

## Table Design Checklist

Check:
- Dense tables are sortable by the columns users actually need to sort by
- Tables are paginated or virtualized rather than rendering hundreds of rows at once
- Column set defaults to the most relevant fields, with less-used columns available via a column picker rather than always shown
- Row-level actions are discoverable (visible or on-hover) without cluttering every row by default
- Long text/IDs in cells truncate with access to full value (tooltip, expand, copy) rather than breaking row height
- Empty/zero-result states in tables explain why (no data vs. filtered to zero) rather than showing a blank table

## Progressive Disclosure Checklist

Check:
- Secondary/detailed metrics are behind a drill-down (click into a card, expand a row) rather than all rendered by default
- Summary view shows aggregates first, with the ability to expand into per-item or time-series detail on demand
- Advanced filters/settings are tucked behind a "More filters" or settings affordance, not cluttering the default toolbar
- Historical/trend detail (charts, breakdowns) loads on interaction rather than always rendering at full detail upfront
- Drill-down navigation preserves context (breadcrumb or clear back path) so users don't lose their place

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
