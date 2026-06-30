# ADR-014 — Filter, sort, and pagination state is encoded in the URL

**Status:** Accepted
**Date:** 2026-06-29

## Context

Table state — active filters, sort column, sort direction, current page, page size — is ephemeral state that has historically been managed in component state (`useState`, `useReducer`). Component state is lost on navigation, cannot be shared via URL, and is inconsistent across tables: some tables encode state in the URL, others do not.

This creates user experience problems:
- Navigating to a record and pressing back resets the filter configuration the user had applied.
- A user who has filtered to a specific subset cannot send that view to a colleague via link.
- Filter state visible in the URL can be bookmarked or pasted; filter state in component state cannot.

## Decision

All table filter state, sort state, and pagination state is managed by `useSynchronisedSearchState` from `@connected/composed-kit`.

`useSynchronisedSearchState` serializes the full `SearchState` object to URL query parameters on every change, and reads the initial state from the URL on mount. This means:

- Filter state survives browser back/forward navigation within a session.
- Any filtered view is shareable as a URL — the recipient opens the same table in the same configuration.
- Bookmarks capture filter state.
- Filter state is **not** persisted across sessions. A fresh visit to the URL (no query params) loads the table in its default state, as defined by `defaultSort`, `defaultFilters`, and `defaultVisibleFilters` props.

The exception is saved views: when a user has a saved view selected, that view's configuration is the persistent default. Saved views are managed separately — see ADR-018.

## Implementation

`ApiDataTable` accepts `defaultSort`, `defaultFilters`, `lockedFilters`, `defaultVisibleFilters`, and `nonClearableFilters` props. These define the table's initial state when no URL params are present. The component wires `useSynchronisedSearchState` internally — consumers do not manage URL state directly.

Filter customization visibility (which filters the user has chosen to show or hide) is persisted to localStorage separately, keyed by `filterCustomizationStorageKey`. This persistence is about which filter controls are visible, not what values they contain. It survives sessions and is not reset on fresh visits.

## Consequences

- Every table that uses `ApiDataTable` automatically gets URL-encoded state.
- Engineers must not add `useState` or `useReducer` for table filter, sort, or pagination state — all of this is owned by `ApiDataTable`.
- The `filterCustomizationStorageKey` prop must be a stable, unique string per table. Changing it will reset the user's filter visibility preferences. Convention: `{entity}-{purpose}-filters-v1` (e.g. `complaints-templates-filters-v1`).
- Tables that share a route but show different data must use different storage keys.
- URL state is safe to share: it contains filter values but no credentials or sensitive tokens.
