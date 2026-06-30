# Dialog Header

The Dialog Header establishes context and intent for every dialog type — confirmation dialogs, action dialogs, and destructive warnings. It carries the title and description; the footer carries the actions.

---

## Overview

Every dialog has a header. The header communicates what is about to happen and why the user should care. Titles are imperative. Descriptions state the concrete consequence. Actions live in the footer.

This guide covers the header content rules and the decision logic for when a dialog is required, which type to use, and how to label actions correctly.

---

## When to use a warning dialog

Require a warning dialog if **either** of the following is true:

1. The action permanently destroys data or makes it inaccessible without admin intervention.
2. The action triggers a consequence outside the platform — sends an email, creates a financial transaction, makes a status visible to a supplier or third party.

If both answers are no and the user can reverse the action themselves in the same session, no warning dialog is needed.

> **Soft-delete / archive:** When a "delete" action is recoverable via a named Restore path, a lighter confirmation may apply. See the archive/soft-delete pattern guide.

See [ADR-033](../adr/033-warning-dialog-threshold.md).

---

## When to use an action dialog

Use an action dialog when any of the following is true:

- The action triggers an external consequence (email, financial transaction, third-party status update).
- The action affects 2 or more explicitly selected records.
- The action has documented cascade effects on related records.
- The action cannot be undone within the session without admin action.

See [ADR-034](../adr/034-action-dialog-threshold.md).

---

## ConfirmDialog vs Modal

| Pattern | When to use |
|---|---|
| `ConfirmDialog` | The full impact fits in one or two sentences. Title + description only — no body content needed. |
| `Modal` | The impact requires enumeration — a list of cascading consequences, affected records, or warning items. |

**Decision test:** "Does the user need to read a list to understand what they're committing to?" → Yes → `Modal`. No → `ConfirmDialog`.

See [ADR-035](../adr/035-confirmdialog-vs-modal.md).

---

## Anatomy

### Required elements

| Element | Rule |
|---|---|
| Title | Imperative: verb + object. Sentence case. ("Delete category", "Send to supplier") |
| Confirm button | Label must match the title verb. ("Delete", "Send") |
| Cancel button | Always present. |

### Optional elements

| Element | Notes |
|---|---|
| Description | Concrete consequence. Name the specific object where possible. |
| Inline alert (`InlineAlert`) | Warnings within a Modal body. Footer primary action disabled while visible. Contains dismiss and proceed controls. |
| Input field | Max one optional input field in an action dialog. Two or more fields = use a Drawer instead. |
| Confirmation checkbox | Permitted alongside a single input field. |

---

## Behaviour

### Confirm button label

The confirm button label must match the title verb exactly. Use "Confirm" only when the dialog action is itself a confirmation — the user is reviewing and accepting pre-presented information, not triggering a new state change.

All other cases: match the verb. ("Delete" → "Delete", "Send" → "Send", "Archive" → "Archive")

See [ADR-036](../adr/036-confirm-button-verb-match.md).

### Loading state

Both Cancel and Confirm are disabled during an in-flight API call. Backdrop click is also disabled — clicking outside the dialog while a call is in flight does not close it. The API call is already in flight; closing the UI does not cancel the request.

See [ADR-037](../adr/037-dialog-loading-state-lockout.md).

### Bulk action descriptions

Descriptions for bulk actions must state the record count explicitly. Never "these records." While the count is loading: skeleton shimmer in place of the number, confirm button disabled until count resolves.

### Inline warning in Modal

Use `InlineAlert` inside the Modal body — not a second dialog. Footer primary action is disabled while the alert is visible. The alert contains two controls: a dismiss action ("Cancel") and a proceed action labelled to match the modal's confirm verb (e.g. "Delete", "Submit anyway", "Send anyway").

### Focus management

> **Provisional — pending design confirmation (OQ-DH-1)**

Focus Cancel on open for destructive dialogs until design confirms the canonical focus destination.

---

## Post-action behaviour

> **Pending design input (DH-H9)**

This section will document:
- **Success path:** whether the dialog closes immediately and shows a toast, or stays open with a success state.
- **Error path:** whether the dialog stays open with an inline error and how buttons re-enable.

Do not implement post-action behaviour from assumptions — get the pattern confirmed by design before shipping.

---

## Content rules

### Titles

- Verb + object. ("Delete supplier", "Send audit request", "Archive product")
- Sentence case — never title case.
- Do not end with a question mark in a destructive dialog title.

### Descriptions

- State the concrete consequence. Name the specific object where possible.
- For bulk actions: state the count explicitly. Never "these records."
- Keep to one or two sentences.

### Confirm buttons

- Match the title verb. ("Delete", "Send", "Archive")
- Use "Confirm" only when the user is reviewing and accepting pre-presented information.

---

## Do / Don't

**Do**
- Match the confirm button label to the title verb.
- State the count explicitly in bulk action descriptions.
- Disable both buttons and the backdrop during an in-flight API call.
- Use `InlineAlert` inside Modal body for inline warnings — not a nested second dialog.

**Don't**
- Don't use generic "Confirm" as the label when a specific verb is available.
- Don't keep one button active while disabling the other during loading — disable both.
- Don't allow backdrop clicks to close a dialog while an API call is in flight.
- Don't show a dialog for actions the user can reverse in the same session unless there is an external consequence.

---

## Related

- [ADR-033: Warning dialog threshold](../adr/033-warning-dialog-threshold.md)
- [ADR-034: Action dialog threshold](../adr/034-action-dialog-threshold.md)
- [ADR-035: ConfirmDialog vs Modal](../adr/035-confirmdialog-vs-modal.md)
- [ADR-036: Confirm button verb match](../adr/036-confirm-button-verb-match.md)
- [ADR-037: Dialog loading state lockout](../adr/037-dialog-loading-state-lockout.md)
- [Pages, Drawers, Sheets & Dialogs](pages.md) — surface selection
- [Engineering supplement](../engineering.md) — `ConfirmDialog` and `Modal` implementation
