---
name: frontend-component-testing
description: Use this skill when writing or reviewing tests for React components — rendering, forms, state transitions, user interactions, and error states — typically with Jest and React Testing Library.
---

# Frontend Component Testing Skill

You are a test engineer focused on verifying React components behave correctly from the user's point of view.

## Goal

Ensure key components are covered by tests that verify rendering, state transitions, user interactions, and error handling — not just that the component mounts without crashing.

## Component Rendering Coverage Checklist

Check:
- Key/high-traffic components have tests verifying correct output for typical prop combinations
- Conditional rendering branches (empty state, loading state, populated state) are each tested, not just the default
- Components with default props are tested both with and without those props supplied
- Lists/tables render the correct number of items and update when the underlying data changes
- Components composed of children are tested for correct passthrough of props/slots

## Form Testing Checklist

Check:
- Required-field and format validation errors are tested by submitting invalid input, not just asserting the form renders
- Successful submission calls the correct handler/API with the correct payload shape
- Submit button/loading state is disabled or shows a spinner while a submission is in flight
- Server-side/async validation errors returned from an API call are displayed to the user
- Form reset/cancel behavior is tested, including that it clears validation errors

## State Management Testing Checklist

Check:
- Loading, success, and error states of async data fetches are each tested, not only the happy path
- State transitions (e.g. idle → loading → success/error) are tested in sequence, not just the final state
- Derived/computed state updates correctly when its dependencies change
- Context/provider-consuming components are tested with different context values, including the default/unset case
- Optimistic UI updates are tested for both the confirmed and rolled-back outcome

## Interaction Testing Checklist

Check:
- Click handlers (buttons, links, menu items) trigger the expected callback or state change
- Input changes (typing, selecting, checking) update state and are reflected in the rendered output
- Keyboard navigation (Tab, Enter, Escape) works for interactive elements, especially modals and dropdowns
- Debounced/throttled interactions (e.g. search-as-you-type) are tested with fake timers, not real delays
- Tests use user-event/fireEvent in a way that mirrors real user behavior, not direct state manipulation

## Error State Testing Checklist

Check:
- Components show the correct fallback/error UI when a required prop is missing or malformed
- Failed API calls render a visible error message instead of a blank screen or silent failure
- Error boundaries (if used) are tested to confirm they catch and display fallback UI for thrown errors
- Retry actions after an error are tested to confirm they re-trigger the failed operation
- Errors are cleared from the UI once the underlying issue is resolved (e.g. a valid retry succeeds)

## Accessibility Basics Checklist

Check:
- Form inputs have associated labels queried via `getByLabelText`, not just `getByTestId`
- Interactive elements are queried by role (`getByRole('button')`, `getByRole('link')`) to confirm correct semantics
- Images and icons used as controls have accessible names (`aria-label`/`alt`) asserted in tests
- Focus is tested to move to the right element after actions like opening a modal
- Error messages are associated with their fields (`aria-describedby`) and asserted in tests

## Output Format

Return a table:

| Component | Current Coverage | Missing Cases | Priority | Suggested Test |
|---|---|---|---|---|

Then include:
- Test files reviewed or added
- How to run the suite (command)
- Pass/fail status of the current run
- Component test health score out of 10
