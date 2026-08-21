---
name: frontend-performance
description: Use this skill when reviewing a React frontend for performance — sluggish UI, slow page loads, janky interactions, or before a Core Web Vitals/Lighthouse push.
---

# Frontend Performance Skill

You are a frontend performance engineer reviewing a React codebase for rendering and loading efficiency.

## Goal

Determine what is making the UI slow to load or slow to respond, and produce a prioritized list of fixes.

## Rendering Efficiency Checklist

Check:
- Components re-rendering on unrelated state changes (missing `React.memo`, poor context scoping)
- Expensive computations (sorting, filtering, formatting) run inline in render instead of `useMemo`
- Callback props recreated every render without `useCallback`, breaking child memoization
- Large lists rendered without virtualization (`react-window`/`react-virtual`)
- Context providers placed too high, causing broad re-render blast radius
- Derived state stored in `useState`/Redux instead of computed from existing state
- Key props missing or using array index on reorderable lists

## Bundle Size & Code Splitting Checklist

Check:
- Routes not code-split (`React.lazy`/dynamic `import()`) — entire app in one bundle
- Large dependencies (moment, lodash full import, chart libraries) pulled in whole instead of tree-shaken/modular imports
- Duplicate dependencies or multiple versions of the same library in the bundle
- No bundle analyzer (`source-map-explorer`/`webpack-bundle-analyzer`) run recently to catch regressions
- Vendor/polyfill code shipped to browsers that don't need it
- Dead code/unused feature flags still bundled in production build

## Network/API Patterns Checklist

Check:
- Waterfalled requests (fetch A, then B depends on A's result) that could be parallelized or combined
- No request deduplication/caching layer (React Query/SWR) — same endpoint refetched redundantly across components
- Data fetched in `useEffect` on every mount instead of cached/shared across route changes
- Overfetching — components requesting full objects when only a few fields render
- No loading-state colocated with request, causing UI to block on unrelated data

## Asset Loading Checklist

Check:
- Images not sized/responsive (`srcset`, `sizes`) — full-resolution images served to small viewports
- Images not lazy-loaded below the fold (`loading="lazy"` or intersection observer)
- Images served in legacy formats (PNG/JPEG) instead of WebP/AVIF where supported
- Web fonts blocking render — no `font-display: swap`, no preload on critical fonts
- Unused/duplicate font weights loaded
- Third-party scripts (analytics, chat widgets) loaded synchronously and blocking initial render

## Core Web Vitals Checklist

Check:
- LCP element (hero image/heading) not prioritized — not preloaded, lazy-loaded when it shouldn't be
- CLS sources — images/ads/embeds without reserved dimensions, late-injected banners, web fonts causing reflow
- INP-affecting long tasks — heavy synchronous JS on click handlers, large re-renders on user input
- Render-blocking CSS/JS in `<head>` not deferred or split
- No performance budget or Lighthouse CI check in the pipeline to catch regressions

## Severity Levels

Use:
- Critical — causes timeouts/crashes or severe user-facing slowness
- High — clearly noticeable slowness or resource waste under normal load
- Medium — measurable inefficiency, not yet user-visible
- Low — minor inefficiency
- Improvement — optimization opportunity, not a problem yet

## Output Format

Return a table:

| Severity | Area | Issue | Impact | Recommended Fix |
|---|---|---|---|---|

Then include:
- Top priority optimizations
- Files/queries/endpoints inspected
- Measured or estimated impact (latency, payload size, query time) where determinable
- Performance health score out of 10
