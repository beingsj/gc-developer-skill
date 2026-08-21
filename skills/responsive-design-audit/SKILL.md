---
name: responsive-design-audit
description: Use this skill when auditing a React SaaS product across desktop, tablet, and mobile viewports — before a release, after a layout change, or when users report broken layouts, overflow, or unusable forms/tables/modals on smaller screens.
---

# Responsive Design Audit Skill

You are a frontend engineer and UX reviewer specializing in responsive and cross-device design.

## Goal

Determine whether the product's layouts, components, and interactions hold up correctly across desktop, tablet, and mobile viewports, and flag where they break down.

## Layout Breakpoints Checklist

Check:
- Desktop (≥1280px), tablet (~768-1024px), and mobile (~375-428px) each render a coherent, intended layout, not just a shrunk desktop view
- No content is clipped, hidden, or unreachable at any standard breakpoint
- Breakpoint transitions don't have a "dead zone" width range where the layout looks broken between two defined breakpoints
- Sidebar/nav collapses to an appropriate pattern (hamburger, bottom nav, drawer) below tablet width
- Multi-column layouts (dashboard cards, split panes) stack in a sensible priority order on narrow screens
- Font sizes and line lengths remain readable (not oversized or cramped) at each breakpoint

## Overflow & Stacking Issues Checklist

Check:
- No unintended horizontal scroll on the page body at any viewport width
- Fixed-width elements (tables, code blocks, images) are wrapped in their own scroll container instead of breaking page layout
- Long unbroken strings (emails, IDs, URLs) wrap or truncate instead of forcing overflow
- Z-index stacking is correct for overlapping elements (dropdowns, tooltips, sticky headers, modals) at every breakpoint
- Sticky/fixed headers or footers don't overlap page content or get hidden behind other fixed elements
- Absolutely positioned elements reposition correctly rather than drifting off-screen on smaller viewports

## Forms on Mobile Checklist

Check:
- Correct input types are used (email, tel, number) so mobile keyboards match the expected input
- Input fields are large enough (min ~44px height) to tap accurately without zooming
- Field width uses available screen space rather than leaving oversized side margins or cramped inputs
- Multi-column form layouts collapse to single-column on mobile
- Date/time/select pickers use native or touch-friendly components rather than tiny desktop-style dropdowns
- Keyboard appearance doesn't obscure the field being edited or the submit button

## Tables/Data-Dense Views on Small Screens Checklist

Check:
- Wide tables sit inside a horizontal scroll container rather than squeezing all columns or breaking layout
- Column priority is considered: least-important columns are hidden or collapsible on narrow screens
- A card-based fallback view is used where a full table is unreadable on mobile
- Row actions (edit/delete/menu) remain reachable and legible at mobile width
- Sorting/filtering controls remain usable (not cut off or requiring horizontal scroll to reach) on mobile
- Pagination/infinite scroll controls are visible and tappable at the bottom of the viewport

## Modals & Navigation on Mobile Checklist

Check:
- Modals expand to full-screen (or near full-screen) on mobile rather than rendering as a tiny centered desktop dialog
- Modal close targets are large enough and positioned where a thumb can reach them
- Modals don't trap scroll or cause background content to scroll simultaneously
- Primary navigation (top nav, sidebar) has a clear mobile equivalent (drawer, bottom bar, hamburger) that's discoverable
- Nested navigation (breadcrumbs, tabs within a page) doesn't overflow or get cut off on narrow screens
- Back navigation within a mobile flow (modal-in-modal, drill-down) is unambiguous and consistent

## Touch Target Sizing and Spacing Checklist

Check:
- Interactive elements meet a minimum touch target size (~44x44px per WCAG/Apple/Material guidance)
- Adjacent tappable elements (icon buttons, list row actions) have enough spacing to avoid mis-taps
- Hover-dependent interactions (tooltips, hover-to-reveal actions) have a touch-accessible equivalent
- Swipe/drag interactions (carousels, reorder lists) don't conflict with native scroll gestures
- Small icon-only buttons have adequate padding beyond the icon's visual bounds

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
