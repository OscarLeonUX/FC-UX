# CTAs and text buttons

## Overview

This guide covers the rules that apply to any call-to-action (CTA) or text button, regardless of which surface it renders on: placement, labeling, confirmation, loading states, and icon treatment. It does not cover surface-specific mechanics — exactly how many row actions a table allows, or a Drawer's footer button order, live in that surface's own guide, which cross-references this one.

## Placement

The primary CTA's placement depends on the page's PageHeader variant.

| Variant | Placement |
|---|---|
| Header–Parent (list, category, result set) | Slot 4 — Filter / action bar, left-aligned. Never in the Page Header. |
| Header–Child (single named entity record) | Page Header's `actions[]` slot, right-aligned. |

**Exception:** on a Header–Child page, if the CTA actually belongs to an embedded data table (e.g. a related-records table with its own "New X" action), it lives in that table's own toolbar — not the Page Header. A page never carries two competing top-level primary actions.

See [ADR-045](../../app-shell/adr/045-primary-cta-placement-header-parent-vs-child.md), the [App Shell guide](../../app-shell/design/app-shell.md), and the [PageHeader guide](../../headers/design/page-header.md).

### Table-level toolbar

Within a table's own toolbar, the primary action sits top-left, first — before search and filters, in the same row. See the [Tables guide](../../tables/design/tables.md).

## Labels

Every CTA and text-button label is a specific verb naming the action performed — never "Submit", "OK", "Confirm", or a bare noun.

Cap the interpolated entity-name portion of a label, not the verb — truncate with an ellipsis and show the full value in a tooltip. Keep the full rendered label at a soft cap around 32–40 characters, consistent with a fixed single-line button.

See [ADR-036](../../headers/adr/036-confirm-button-verb-match.md) for the dialog-specific origin of the verb-match rule — it applies everywhere now, not just dialog confirm buttons.

## Confirmation

A destructive action — delete, reject, deactivate — never executes on first click, and never renders as a standalone button outside a menu or a dialog trigger.

| Context | Rule |
|---|---|
| Table row | Confirmation required (dialog or inline row state). Destructive actions live in the action menu, never an always-visible button. |
| Table bulk action | Confirmation dialog stating the affected record count ("Delete 14 suppliers?"). Non-destructive bulk actions (export, tag) execute immediately. |
| Page Header `actions[]` | Never a standalone destructive button — route through an action menu or a confirmation dialog trigger, regardless of secondary-action count. |
| Drawer footer | Positioned `mr-auto`, separated from Confirm/Cancel — still requires its own confirmation step before executing. |

See [ADR-016](../../tables/adr/016-row-action-slot-model.md).

## Loading and disabled states

| Context | Behaviour |
|---|---|
| Dialog confirm/cancel | Confirm, Cancel, and the backdrop all disable during the in-flight call. See [ADR-037](../../headers/adr/037-dialog-loading-state-lockout.md). |
| Form submit | Submit button shows a loading state and disables. Cancel stays active — it means "discard," not "stop." |
| Drawer footer save | Same model as Form submit — the primary action locks, Cancel stays active. |
| Non-destructive bulk action | Only the clicked action button shows a loading state and disables. Other rows, checkboxes, and bulk-bar controls stay fully interactive — never lock the whole table or bar for a single bulk action. |
| Non-dangerous action-menu item | The menu stays open with a loading indicator on the selected item until the call resolves — it does not close immediately on click. |

The distinguishing question when a new surface needs this rule and isn't listed above: does Cancel mean "stop an action already in motion" (disable it, as in dialogs) or "discard and leave" (keep it active, as in forms and drawers)?

## Icon treatment

Within one cluster of secondary actions (Page Header `actions[]`, table row actions, drawer footer overflow), pick one visual language: icon-only for at most one action — the single most frequent one — and icon+label for the rest. Never mix icon+label and label-only buttons within the same cluster.

See [ADR-016](../../tables/adr/016-row-action-slot-model.md) for the original table-row model this extends.

## Do

- Use a specific verb naming the action for every CTA and text-button label.
- Require confirmation — a dialog or a stated record count — before executing any destructive or dangerous action.
- Keep other controls interactive while a single action's own request is in flight, unless it affects shared state.
- Keep Cancel active during a form or drawer save; disable it during a dialog's in-flight call.
- Pick one icon treatment per action cluster.
- Cap and truncate the entity-name portion of an interpolated label — never the verb.

## Don't

- Use "Submit", "OK", "Confirm", or a bare noun as a CTA or text-button label.
- Render a destructive action as a standalone button outside a menu or dialog trigger, on any surface.
- Execute a dangerous bulk action without stating the affected record count.
- Lock an entire table, menu, or page over a single action's in-flight request.
- Mix icon-only, icon+label, and label-only buttons within the same action cluster.
- Duplicate a table's primary action in its page's header, or vice versa.

## Related

- [Tables](../../tables/design/tables.md) — row actions, bulk actions, toolbar order.
- [PageHeader](../../headers/design/page-header.md) — `actions[]`, action grouping.
- [App Shell](../../app-shell/design/app-shell.md) — Slot 4.
- [Drawers](../../surfaces/design/drawers.md) — footer layout.
- [Dialogs](../../surfaces/design/dialogs.md) — confirm/cancel, action limits.
- [Forms](../../forms/design/forms.md) — submit button states.
- [ADR-016](../../tables/adr/016-row-action-slot-model.md) — row action slot model.
- [ADR-036](../../headers/adr/036-confirm-button-verb-match.md) — verb-match origin.
- [ADR-037](../../headers/adr/037-dialog-loading-state-lockout.md) — dialog loading lockout.
- [ADR-045](../../app-shell/adr/045-primary-cta-placement-header-parent-vs-child.md) — placement split.
