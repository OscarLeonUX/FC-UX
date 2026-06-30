# ADR-006 — SidebarShell is a fourth panel primitive, distinct from Sheet

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Foods Connected has four named surfaces: Page, Drawer, Sheet, Dialog. Engineers building filter panels and column pickers encountered a fifth interaction model — a panel that shrinks the page content area when it opens, with the panel and the grid visible and interactive simultaneously.

This pattern is implemented as `SidebarShell` in `composed-kit`. It is used by `FilterSidebar` and `ColumnSidebar`. It is not implemented using the `Sheet` component.

The distinction matters because:

- `Sheet` overlays the page — the panel floats over content, no layout reflow.
- `SidebarShell` shrinks the page — the content area compresses alongside the panel. Both are simultaneously visible and interactive.

Using `Sheet` where `SidebarShell` is needed produces a panel that covers the grid, breaking the live-feedback loop that makes filter-as-you-go useful.

## Decision

SidebarShell is recognised as a fourth panel primitive alongside Sheet, with its own discriminator:

- **Use SidebarShell** when the panel is permanently available via a toolbar toggle, is coupled to a specific grid or table, and the user must be able to see the grid update alongside the panel controls.
- **Use Sheet** when the panel is triggered by a specific action, row, or record, and overlaying the page is acceptable.

The discriminator is the relationship between the panel and the grid — not the content purpose. A filter panel can be either pattern depending on whether it shrinks or overlays the grid.

## Consequences

- Engineers building filter panels or column pickers for data tables must use `SidebarShell`, not `Sheet`.
- Engineers building contextual panels (triggered by a record, a row action, or a specific user choice) should use `Sheet`.
- The Sheet design guidelines include a note distinguishing Sheet from SidebarShell to prevent engineers from reaching for the wrong component.
- `FilterSidebar` and `ColumnSidebar` are the canonical SidebarShell implementations and should be used as reference patterns.
