# ADR-015 — No-data and no-results empty states are distinct

**Status:** Accepted
**Date:** 2026-06-29

## Context

A table can appear empty for two entirely different reasons:

1. **No data**: the table has no records at all, or the current user has permission to see zero records. The data does not exist.
2. **No results**: the current filter configuration or search query produced zero matching records, but records do exist in the system.

The two situations require different responses from the user. In the first case, the correct action is to create a record. In the second, the correct action is to change or clear the filters.

Tables across the platform currently use a single generic empty state — "There are no results to display." — regardless of which situation applies. This is ambiguous. When the no-results state shows a "Create" call to action, users interpret the absence of results as meaning no records exist and create duplicates.

## Decision

No-data and no-results empty states must have distinct content and distinct primary actions.

**No-data state:**
- Message: describes what the table holds and that it is empty. Example: "No suppliers yet. Add your first supplier to get started."
- Primary action: a button that initiates the create flow. This is the only context in which the create CTA appears inside the table body.
- An illustration is optional.

**No-results state:**
- Message: indicates that the current filters or search returned no matches. Example: "No suppliers match your current filters."
- Primary action: a "Clear filters" link or button that clears the active filter configuration.
- No create CTA. No illustration.

The create CTA must never appear in the no-results state. Records exist — the filter configuration is wrong, not the data.

## Consequences

- Tables must detect which state applies. The canonical approach: if no filters or search are active and the result count is zero, it is a no-data state. If filters or search are active, it is a no-results state.
- The empty state component accepts a `hasActiveFilters` (or equivalent) flag to discriminate.
- Teams reviewing tables must check both states — it is a defect if the no-results state shows a create CTA, or if the no-data state shows only a filter-clear action when no filters are active.
- Tables with `lockedFilters` that cannot be cleared by the user may produce a permanent no-results state if the locked filter matches nothing. In this case the no-results message should reflect the locked filter context, not imply a user error.
