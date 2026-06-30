# ADR-016 — Row actions follow a three-slot model with a maximum of two inline actions

**Status:** Accepted
**Date:** 2026-06-29

## Context

Row-level actions in tables are implemented inconsistently. Some tables show many inline buttons per row, making the action column as wide as a data column. Some tables hide actions behind hover states, making them inaccessible to keyboard and touch users. Some tables show destructive actions without confirmation.

Three problems arise from this inconsistency:

1. Wide action columns compete with data columns and make tables harder to scan.
2. Hover-revealed actions are never discovered by keyboard users and are awkward on touch devices.
3. Immediate destructive actions (delete without confirmation) cause data loss.

## Decision

Row actions follow a three-slot model, in priority order:

**Slot 1 — Icon buttons (always visible)**
For the highest-frequency action on a row: opening the record, navigating to a detail view, or the single most common operation. Maximum 2 icon buttons. Rendered as small ghost icon buttons with a tooltip. Always visible — not dependent on hover state.

**Slot 2 — Text buttons (always visible)**
For secondary actions that benefit from a text label (e.g. Approve, Reject, Review). Use only when the label meaningfully reduces ambiguity over an icon alone. Text buttons widen the action column — use sparingly.

**Slot 3 — Action menu**
For all remaining actions, accessed via a trigger at the right edge of the row. All destructive actions must be in the action menu — never as always-visible buttons. Sub-menus are permitted for grouping related actions.

**Total inline actions (slots 1 + 2) must not exceed 2.** If a table requires 3 or more always-visible actions, consolidate into the action menu. Additional icons without labels in slot 1 beyond 2 are also not permitted.

**Hover-reveal actions are not permitted.** Actions must be permanently visible within their slot or accessible via the action menu. Hover may change the visual state of a button (opacity increase) but must not be the sole mechanism for revealing an action.

**Dangerous actions require confirmation.** Any action that deletes, rejects, deactivates, or otherwise irreversibly modifies a record must require a confirmation step before execution. Confirmation may be a dialog or an inline confirmation state on the row. Never execute a destructive action on first click.

## Consequences

- Tables with more than 2 inline actions must be refactored. Move actions beyond the first 2 into the action menu.
- Tables with hover-revealed actions must be refactored. Make actions permanently visible or move them to the menu.
- Tables with immediate destructive actions must be refactored. Add confirmation dialogs or inline confirm/cancel states.
- The action menu trigger (a vertically-stacked ellipsis icon) must always be visible, not revealed on hover, even when slot 1 and 2 are empty — it signals that additional actions are available.
- The action column is always pinned to the right edge of the table.
