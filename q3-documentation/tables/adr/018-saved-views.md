# ADR-018 — Saved views are named filter-and-column presets for primary working surfaces

**Status:** Accepted
**Date:** 2026-06-29

## Context

Users working with the same table daily develop a set of recurring filter, column, and sort configurations: a quality manager always filters to open items, a regional manager always filters by country, a buyer hides internal cost columns. Without saved views, users re-apply these configurations on every session.

Views also serve as a communication mechanism: a team lead can establish a "Review needed" view that gives the whole team a shared entry point into the same filtered dataset.

Views are implemented in composed-kit (`ViewTabs` component, `useViews` hook) but adoption is inconsistent — some tables have views, most do not, and there is no principle for when to offer them.

## Decision

**What a view is**

A saved view is a named combination of: active filter values, visible columns and their order, sort column and direction, and optionally the current search text. A view does not store the current page number.

A view is not a layout preference, a density setting, or a bookmark to a specific record.

**When to offer views**

Offer saved views when all of the following are true:
- The table is a primary working surface — a standalone page the user navigates to directly, not an embedded list, picker, or selector
- Users have meaningfully different recurring filter or column configurations
- The table has 6 or more configurable dimensions (combination of filterable columns and hideable columns)

Do not offer views for simple tables where one configuration serves all users, embedded tables inside other views, or tables in dialogs or drawers.

**Two view categories**

**System views** — defined by the product team, cannot be edited or deleted by users. They represent the canonical views for common workflows. Shown before user views with a visual distinction (e.g. a lock indicator). A table should have at most 4–5 system views. More than 5 system views suggests the table is trying to do too much.

**User views** — created by the user, renameable, and deletable by the user who created them. One user view per user can be set as the default for that table.

**Dirty state**

When the user's current table state (filters, columns, sort) differs from the saved state of the active view, the view tab shows a dirty indicator. The user can either: save the current state over the existing view, or discard changes and return to the saved state. If the active view belongs to the system (read-only), the user can save as a new view instead.

**View naming**

View names must describe what the view shows, not who owns it. "Open audits — EU region" is a correct view name. "My view", "View 1", and "Oscar's view" are not.

**Default view**

The default view loads automatically when the user opens the table. Each user can designate one of their own views as their default. System views can also be designated as the table-wide default — the view that loads for users who have not set a personal default.

**Persistence**

User views are persisted to localStorage under a stable key (`composed-kit:views:{entity}`). API-backed view persistence (server-side, per user) is supported where localStorage is insufficient (cross-device access to user views).

## Consequences

- Tables that meet the criteria above and do not currently offer views should adopt `ViewTabs`. Teams building new primary tables must evaluate the criteria at design time.
- Tables that do not meet the criteria must not add views — views on simple tables create unnecessary complexity and make the table harder to onboard.
- System views are the product team's responsibility. Adding too many system views or naming them poorly defeats their purpose.
- User views created with one storage key cannot be migrated to a different key. Changing the `entity` key in `composed-kit:views:{entity}` will silently discard all existing user views. Treat the entity key as a stable identifier — version it (e.g. `suppliers-v2`) only when breaking changes to the view shape require it.
