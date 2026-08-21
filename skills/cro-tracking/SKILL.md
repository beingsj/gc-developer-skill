---
name: cro-tracking
description: Use this skill when auditing whether a SaaS product's key conversion actions — signup, login, start trial, add to cart, checkout, payment, booking, contact/lead submission — are correctly and consistently tracked for CRO analysis, before running experiments or when CRO reports don't reconcile with actual product usage.
---

# CRO Tracking Skill

You are a conversion-rate-optimization engineer auditing whether a SaaS product's important user actions are measurable enough to run reliable experiments and reports on.

## Goal

Determine whether every important conversion action in the product is tracked accurately, consistently, and with enough detail to drive CRO decisions.

## Signup/Login Tracking Checklist

Check:
- Signup event fires only on confirmed account creation (API success / DB record created), not on form-submit-click regardless of outcome
- Failed signup attempts (validation error, duplicate email, server error) are not counted as successful signups
- Login event fires on true authenticated session start, distinguishing first-time login (post-signup auto-login) from returning-user login
- Social/OAuth signup and login paths (Google, GitHub, etc.) fire the same events as email/password paths, not a separate untracked path
- Email verification step (if required before full access) has its own tracked completion event, not conflated with signup

## Trial/Subscription Tracking Checklist

Check:
- Start Trial event fires distinctly from Signup when trial activation is a separate step
- Plan upgrade, downgrade, and cancellation events are all tracked, not just the initial subscribe
- Trial-to-paid conversion is tracked as its own event, not inferred only from billing system reports
- Failed payment/renewal events are captured separately from successful ones so churn causes aren't conflated with voluntary cancellation

## Commerce/Booking Tracking Checklist

Check:
- Add to Cart fires per item with product/plan identifier, not just a generic "cart updated" event
- Each checkout step (cart view, shipping/billing info, payment method selected, order review) has its own distinctly named event
- Payment Success and Payment Failure are tracked as separate, distinguishable events, not inferred from the absence of a success event
- Booking/scheduling flows (date selected, slot confirmed, booking completed) are tracked step by step, not only on final confirmation
- Refunds/cancellations post-purchase are tracked so net conversion numbers aren't overstated

## Lead/Contact Tracking Checklist

Check:
- Every lead-gen form (contact, demo request, newsletter, gated content) fires a submit event only on confirmed successful submission
- Lead events carry enough parameters (form name/location, source page) to attribute which page/campaign generated the lead
- Multi-step lead forms track intermediate step completion, not only final submit, to diagnose drop-off
- Chat widget or calendar-booking (e.g. Calendly) conversions are captured in the same analytics property as other leads, not siloed in a separate unlinked tool

## Event Naming Consistency Checklist

Check:
- Event names follow one consistent convention (e.g. `snake_case` verb_noun: `trial_started`, `payment_failed`) across the whole codebase, not mixed conventions per feature
- No near-duplicate events with slightly different names for the same action (`signup_complete` vs `sign_up_completed` vs `user_registered`)
- Event and parameter names match what's documented in the tracking plan/spec, so reports don't require ad-hoc renaming/cleanup
- Naming distinguishes similar-but-different actions clearly (e.g. `trial_started` vs `subscription_started`)

## Value/Parameter Completeness Checklist

Check:
- Revenue-bearing events (checkout, payment, subscription) include value and currency parameters populated from real transaction data
- Plan/tier, billing interval (monthly/annual), and quantity are attached to subscription and upgrade events
- Lead/booking events include enough context (service type, requested date, estimated value where known) to prioritize follow-up and analyze by segment
- No revenue or plan parameters default to placeholder values (e.g. `0`, `"unknown"`) in production when real data is available

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
