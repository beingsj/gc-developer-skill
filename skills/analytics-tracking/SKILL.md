---
name: analytics-tracking
description: Use this skill when auditing a MERN app's analytics implementation — GA4, Meta Pixel, GTM, conversion/funnel events, duplicate firing, and consent handling — after adding new pages/features, migrating tag managers, or when reported numbers look inflated, deflated, or incomplete.
---

# Analytics Tracking Skill

You are a growth/analytics engineer auditing an existing tracking implementation for correctness, not designing a new measurement plan from scratch.

## Goal

Determine whether GA4, Meta Pixel, and GTM are installed correctly, firing the right events exactly once, and producing trustworthy data end to end.

## Base Tracking Setup Checklist

Check:
- GA4 tag, Meta Pixel, and GTM container are all installed (directly or via GTM) and firing on every public page, not just a subset
- Tags load via GTM where possible rather than hardcoded snippets scattered across components (single source of truth)
- Base pageview/PageView events fire exactly once per route change, including client-side (SPA) navigation, not just on hard reloads
- IDs/container IDs match the correct GA4 property, Pixel ID, and GTM container for the environment (no dev/staging IDs leaking to production or vice versa)
- Tag firing verified in GA4 DebugView / Meta Pixel Helper / GTM Preview mode, not just assumed from code review
- Environment-specific tags (staging, dev) are excluded from firing into production analytics properties

## Conversion Event Configuration Checklist

Check:
- Key conversion events (signup, trial start, purchase, lead submit) are marked as conversions in GA4 and as standard/custom events in Meta Events Manager
- Events fire at the true success point (API 200 response / confirmation screen), not optimistically on button click
- Event triggers are tied to the actual DOM element/state change relevant to the action, not a loosely-matched CSS selector that could misfire
- No conversion events fire on page load or on component mount when they should be interaction-triggered

## Funnel Event Completeness Checklist

Check:
- Every step of the intended user funnel (landing → signup → activation → conversion) has a corresponding tracked event
- Step events are sequential and named/ordered so a funnel report can be built without custom stitching
- No funnel step relies solely on a pageview as a proxy for an action when a discrete event would be more accurate
- Multi-step forms/wizards emit a step-level event per screen, not only a final submit event

## Data Accuracy Checklist

Check:
- Event parameters (value, currency, item_id, plan, method) are populated with real data, not hardcoded defaults or empty strings
- No test/placeholder values (e.g. `test@test.com`, `value: 0`) shipped in production event payloads
- Parameter data types match GA4/Meta expectations (numbers as numbers, ISO currency codes, consistent casing)
- User/session identifiers are set correctly so cross-device/cross-session stitching isn't broken

## Duplicate Tracking Checklist

Check:
- Same event isn't fired twice due to a component mounting more than once (React StrictMode, double-rendered effects) without dedupe/guard logic
- Only one tag manager or one direct-install path is pushing a given tag (no GTM-installed GA4 tag AND a hardcoded gtag script both firing)
- Server-side and client-side tracking (if both exist, e.g. Meta Conversions API + Pixel) are deduplicated via event ID matching
- Single-page app route changes don't cause legacy full-page tags to double-fire alongside SPA-aware tags

## Cross-Domain/Consent Handling Checklist

Check:
- Consent Mode (or equivalent) is implemented so tags don't fire (or fire in a limited/anonymized mode) before consent is granted where legally required
- Cross-domain tracking (marketing site to app subdomain, or checkout on a different domain) is configured so sessions aren't split
- Consent banner state changes correctly update tag firing behavior in real time, not only on next page load
- No tracking scripts load before the consent management platform initializes on pages where required

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
