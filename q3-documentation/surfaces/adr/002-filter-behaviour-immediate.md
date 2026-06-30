# ADR-002 — Filter application behaviour is Immediate

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Filter panels on data tables have two common UX models:

- **Immediate** — each filter change (checkbox tick, dropdown selection) applies instantly and the list updates in real time. No Apply button.
- **Deferred** — the user sets up the full filter state and clicks Apply to commit.

Deferred filtering requires less network traffic per interaction but introduces friction: the user cannot see how their choices affect the list until they commit. In data-dense supply chain workflows, seeing the live result as you filter is essential to the task — the user is often exploring, not following a predetermined filter plan.

The Foods Connected `FilterSidebar` component confirms the Immediate model — it has no Apply button and no debounce on checkbox changes.

## Decision

Filter application in Foods Connected is **Immediate**. Every discrete filter change applies instantly with no Apply button and no debounce.

- Checkbox changes apply immediately — they are discrete choices, not continuous input. Unlike search text (which benefits from debounce to suppress intermediate states), a checkbox has no intermediate state to suppress.
- The zero-results warning is surfaced inside the sheet while it is open — not after closing.
- Filter state persists when the sheet is closed — closing the sheet does not clear the filters.
- "Clear all" is immediate — it resets state and the list without a separate confirm step.
- Filter configuration sheets (managing which filters are visible and their order) are distinct from filter application sheets. This Immediate rule does not apply to configuration sheets, which may have an explicit commit step.

## Consequences

- All filter application UIs must be built without an Apply button.
- Engineers may not add debounce to checkbox-driven filter changes.
- Filter pills must appear in the page chrome when the filter sheet is closed, so the active state remains visible without reopening.
