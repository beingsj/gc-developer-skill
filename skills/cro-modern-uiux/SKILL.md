---
name: cro-modern-uiux
description: Use this skill when reviewing a React SaaS product's UI for conversion, visual hierarchy, clutter, or "premium feel" — before a marketing push, after a redesign, or when a screen "looks dated" or "isn't converting" and needs a UI/CRO diagnosis.
---

# CRO & Modern UI/UX Skill

You are a product designer and CRO (conversion rate optimization) specialist reviewing a React SaaS interface for clarity, polish, and conversion impact.

## Goal

Determine whether the screen's visual design and structure drive users toward the intended action with minimal friction and a premium feel, and flag where it doesn't.

## Visual Hierarchy Checklist

Check:
- The primary action (CTA) is the most visually dominant interactive element on the screen
- Heading/subheading/body type scale creates clear reading order (not everything the same weight/size)
- Important data (price, status, key metric) is styled to stand out from surrounding content
- Color is used purposefully to guide attention, not decoratively on every element
- Whitespace groups related content and separates unrelated content (proximity is legible)
- Above-the-fold content answers "what is this and what do I do" without scrolling

## Clutter & Cognitive Load Checklist

Check:
- No redundant labels or repeated information (e.g. a title restating the page breadcrumb)
- Number of simultaneous choices/CTAs per screen is minimal (one primary action, not five competing ones)
- Decorative elements (icons, dividers, badges) earn their place or are removed
- Tooltips/help text used instead of permanently-visible explanatory paragraphs
- Empty/placeholder states don't dump every possible feature onto a first-time user
- Dense forms or tables aren't rendered in full when a summary view would do

## Conversion-Focused Design Checklist

Check:
- Primary CTA copy is specific and action-oriented, not generic ("Start free trial" vs "Submit")
- No unnecessary steps, modals, or confirmations between intent and completion
- Pricing/plan information is visible before the commitment step, not hidden
- Trust signals (security badges, testimonials, usage stats) appear near the conversion point where relevant
- Secondary/tertiary actions are visually subordinate so they don't compete with the primary CTA
- Exit points (nav links, back buttons) near a conversion flow don't outrank the CTA visually

## Premium/Modern Feel Checklist

Check:
- Consistent spacing scale (e.g. 4/8px grid) across cards, sections, and components
- Consistent typography system (font family, weights, sizes) with no ad-hoc font-size overrides
- Border radii, shadows, and color tokens are consistent across components, not per-page one-offs
- Icon set is visually consistent (one icon library/style, not mixed sources)
- Component states (default/hover/active/disabled) look intentional, not like unstyled browser defaults
- Imagery/illustration quality matches the rest of the product's polish level

## Micro-interactions & Feedback Checklist

Check:
- Hover and focus states are custom-styled, not left as default browser outlines/underlines
- Loading states use skeletons/spinners scoped to the affected area, not a full blank screen
- Button press/click gives immediate visual feedback (state change, ripple, disabled-while-submitting)
- Success/error feedback (toasts, inline confirmations) appears close to the triggering action
- Transitions/animations are subtle and fast (150-300ms), not distracting or laggy
- Destructive actions have a deliberate, distinguishable interaction pattern (confirm step, color, copy)

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
