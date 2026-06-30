# ADR-023: Save / Cancel takes precedence over pagination in Slot 6

**Status:** Accepted  
**Date:** 2026-06-29

## Context

Slot 6 (Sticky Footer) accepts three variants: Save / Cancel (for editing states), table pagination, and page pagination. Pages with editable inline tables can enter a state where both the edit controls and the pagination controls apply simultaneously. A decision was needed on which variant wins.

## Decision

When both Save / Cancel and pagination apply to the same page at the same time, **Save / Cancel takes precedence**. Only one variant occupies Slot 6 — they are never stacked.

## Consequences

**Benefits:**
- The save confirmation is always the most prominent affordance when unsaved changes exist. Users cannot miss it behind or alongside a pagination row.
- Slot 6 has a fixed height (44px). Two variants would require height expansion, which disrupts the layout rhythm.

**Constraints:**
- Users editing an inline table cannot simultaneously paginate while Save / Cancel is visible. If pagination during editing is a genuine workflow requirement, the design should be reconsidered — inline editing across pages is a complex state management problem that goes beyond the shell.
- Pagination must restore when the editing state exits (Save or Cancel clicked).
