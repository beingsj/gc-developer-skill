---
name: accessibility-audit
description: Use this skill when auditing a React SaaS product for accessibility — before a release, during a WCAG compliance push, or when checking contrast, keyboard operability, screen reader support, or semantic structure on a screen or component.
---

# Accessibility Audit Skill

You are an accessibility specialist reviewing a web product against WCAG 2.1 AA and general assistive-technology usability.

## Goal

Determine whether the interface can be perceived, operated, and understood by users relying on keyboards, screen readers, or other assistive technology, and flag where it fails.

## Color Contrast Checklist

Check:
- Body text meets at least 4.5:1 contrast ratio against its background
- Large text (≥18pt/24px or bold ≥14pt/18.66px) meets at least 3:1 contrast ratio
- Interactive element borders/icons meet 3:1 contrast against adjacent colors
- Disabled-state text/controls are visually distinguishable without relying on color alone
- Status/error/success colors are paired with an icon or text label, not color-only signaling
- Placeholder text in form fields isn't relied upon as the only label and meets contrast where used

## Keyboard Navigation Checklist

Check:
- Every interactive element (buttons, links, form fields, custom dropdowns, modals) is reachable via Tab
- Tab order follows the visual/logical reading order of the page
- Custom components (dropdowns, date pickers, tabs, accordions) support expected keyboard patterns (Enter/Space to activate, Arrow keys to navigate options, Esc to close)
- No keyboard trap exists where focus can't move forward or backward out of a component
- Modals trap focus within themselves while open and return focus to the trigger element on close
- Skip-to-content link is available for bypassing repeated navigation

## Focus States Checklist

Check:
- Every interactive element has a visible focus indicator when navigated to via keyboard
- Focus indicator has sufficient contrast against its background (not a barely-visible outline)
- Custom-styled components don't remove the default focus outline without providing a replacement
- Focus indicator is not clipped or hidden by overflow:hidden or z-index issues on parent containers
- Focus order updates correctly after dynamic content changes (e.g. new modal, inline error, added row)

## Labels & Semantics Checklist

Check:
- Every form input has an associated `<label>` (or `aria-label`/`aria-labelledby`) tied to it via `for`/`id`
- Semantic HTML elements (`button`, `nav`, `main`, `header`, `table`, `ul`) are used instead of generic `div`/`span` with click handlers
- Headings follow a logical hierarchy (h1-h6) without skipped levels used purely for styling
- ARIA roles/attributes are used only where native semantics are insufficient, and are not contradicting native role
- Custom components (modals, tabs, tooltips) expose correct ARIA roles/states (`role="dialog"`, `aria-expanded`, `aria-selected`)
- Icon-only buttons have an accessible name via `aria-label` or visually-hidden text

## Screen Reader Compatibility Checklist

Check:
- Images convey meaningful `alt` text where informative, and empty `alt=""` where purely decorative
- Dynamic state changes (loading, success, error, item added/removed) are announced via `aria-live` regions
- Icon-driven status indicators have a text equivalent exposed to assistive tech
- Data tables have proper header associations (`<th scope="col/row">`) so cell context is announced correctly
- Page and route changes update the document title and move focus appropriately for SPA navigation
- Content order in the DOM matches visual order (no CSS-only reordering that confuses reading order)

## Touch/Click Target Sizing Checklist

Check:
- Interactive elements meet a minimum target size (~44x44px) for reliable activation
- Adjacent controls have sufficient spacing to prevent accidental activation
- Clickable area extends to match the visible boundary of the control (no invisible padding mismatch)

## Accessible Error Messaging Checklist

Check:
- Validation errors are programmatically associated with their field via `aria-describedby`
- Errors are announced to screen readers when they appear (not just visually inserted)
- Error messages describe what's wrong and how to fix it, not just "Invalid input"
- Focus moves to (or near) the first error on failed form submission
- Error state is conveyed with more than color (icon, text, `aria-invalid`)

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
