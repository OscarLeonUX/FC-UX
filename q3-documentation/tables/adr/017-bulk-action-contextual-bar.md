# ADR-017 — Bulk actions appear in a contextual bar that replaces the toolbar

**Status:** Accepted
**Date:** 2026-06-29

## Context

Tables that support row selection require a way to surface bulk actions — actions that apply to all selected rows simultaneously (bulk export, bulk approve, bulk delete). Bulk action placement varies across the platform: some tables show bulk actions in a persistent toolbar alongside normal controls; some show them in a floating footer at the bottom of the viewport; some mix bulk and row-level actions in the same row.

Persistent toolbars that show bulk controls at all times (even when nothing is selected) create confusion — users see disabled or context-sensitive controls with no clear reason. Floating footers require the user to scroll to act. Mixing bulk and row actions on the same row creates ambiguity about which actions apply to the selection and which apply to the hovered row.

## Decision

When one or more rows are selected, a contextual action bar appears above the table and replaces the normal toolbar. The bar disappears and the normal toolbar is restored when selection is cleared.

The contextual bar contains, from left to right:
- Selection count: "[N] [entity] selected" (e.g. "14 suppliers selected")
- Bulk action buttons — the set of operations available for the selection
- A "Clear selection" control that exits bulk mode and restores the toolbar

**The normal toolbar is completely replaced** while the contextual bar is active. Table-level controls (search, filters, column visibility, primary action button) are not available while rows are selected. The user must clear the selection to return to normal toolbar mode.

**Individual row action menus are suppressed** while the contextual bar is active. When bulk mode is on, the per-row action menu trigger is not rendered or is visually disabled. The selection is the unit of action — mixing row actions and bulk actions in the same state creates ambiguity.

**Select all across pages**: when the user selects all rows on the current page and more rows exist on other pages, offer a secondary affordance: "Select all [N total] records." Surface the total count explicitly: "All 2,312 suppliers selected." This is distinct from "14 suppliers selected" on the current page.

**Dangerous bulk actions** (bulk delete, bulk reject) must display a confirmation dialog before executing. The dialog must include the count of records that will be affected.

## Consequences

- Tables with persistent bulk action toolbars must be refactored to the contextual bar pattern.
- Tables that show row actions while rows are selected must suppress the row action menu in bulk mode.
- The contextual bar must be visible and stable — it must not shift layout or overlay other elements.
- The "Clear selection" control must be easy to reach without scrolling, since it is the only way to restore normal toolbar mode.
- Bulk actions must be explicitly designed per table — do not offer all row-level actions as bulk actions by default. Only actions that are meaningful and safe to apply to multiple records simultaneously belong in the bulk action bar.
