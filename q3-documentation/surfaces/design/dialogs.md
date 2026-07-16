# Dialogs

## Overview

A Dialog is a modal surface that requires a decision before the user can return to the underlying page. It has a scrim, traps focus, and blocks all other interaction. Use it sparingly — only when the interruption is genuinely necessary.

## When to use a Dialog

Use a Dialog when a decision is required before any other action is possible. The dialog guards against accidental action — it does not enable a decision. By the time a dialog appears, the user has already decided to proceed; the dialog is the final confirmation.

## Discriminator

| Question | Answer → Surface |
|---|---|
| Must the user decide before doing anything else? | Yes → **Dialog** |
| Does the user need context from the page to decide? | Yes → **Drawer** (surface context first) |
| Is the content substantive enough to need its own space? | Yes → **Drawer** |
| Is this a brief confirmation of an already-made decision? | Yes → **Dialog** |

## Action limit

A Dialog has **at most 2 actions**.

| Pattern | Actions |
|---|---|
| Standard | Primary action + Cancel |
| Outcome | Primary action + one secondary action (replacing Cancel) |
| **Violation** | Primary + secondary + Cancel — never all three |

The secondary action in an outcome dialog navigates to the result (e.g. "View skipped records"). It replaces Cancel — it does not add to it.

## Input limit

A Dialog may contain **at most 2 independent inputs**. One input = one control group: a dropdown, a checkbox group, or a text field each count as 1. Beyond 2 inputs the surface has become a form — use a Drawer instead.

A conditionally-revealed dependent input counts toward this limit exactly as an independent one would. If one of the 2 inputs branches (e.g. selecting "Other" reveals a description field), that dependent field is a 3rd control group — the Dialog exceeds the limit and the surface should be a Drawer instead. See ADR-044.

## Sufficient context for destructive actions

A destructive dialog may open directly from a list row when the row provides sufficient context: the **record name** and **at least one supporting attribute** (status, count, date, or type).

If the row shows only the record name with no supporting attribute, open a Drawer first to surface the context, then show the dialog from the Drawer.

## Manage list exception

A Dialog may contain a short manage list — a bounded set of named, user-created objects (e.g. saved views, tags, notification rules) with inline row actions (rename, delete). A manage list is configuration, not review: it has no data columns, fits without scrolling, and applies actions immediately per row.

If the list can grow unbounded, use a Drawer instead.

## Focus rules

| Dialog type | Focus on open |
|---|---|
| Destructive | Cancel (the safe action) |
| Confirmation | Primary action (decision already made) |
| Outcome | Primary action |
| Informational | Primary action or close button |

## Toast vs outcome dialog

After a dialog action completes, choose between a toast and an outcome dialog based on whether the result requires further action.

- **Use a toast** when the outcome is unambiguous and the user returns to the page with nothing further to decide — "12 documents approved", "Category deleted", "Changes saved".
- **Use an outcome dialog** when the result contains information the user needs to act on — skipped records to review, an error count to investigate, a report to navigate to. The outcome dialog may include one secondary action (e.g. "View skipped records") in place of Cancel.
- **Never use an outcome dialog for a simple success** — if the result requires no action, a toast is sufficient and less disruptive.

## Anatomy

### Required elements

- **Header** — title (verb-led question or statement).
- **Body** — consequence statement, at most 1–2 sentences.
- **Action strip** — 1 or 2 actions, right-aligned.

### Chaining

- Maximum 2 dialogs in a chain. The first dialog presents the primary decision; a second (outcome) dialog shows the result.
- Never open a Drawer from inside a Dialog.

### Scrolling

- A Dialog must not scroll. If the content requires scroll, the surface is wrong — use a Drawer or Sheet instead.

## Content rules

### Titles

- Verb-led: "Delete supplier?", "Approve document?", "Unsaved changes".
- Sentence case. End with "?" only if it is genuinely a question.
- Never: "Warning", "Confirmation", "Alert", "Are you sure?".

### Body copy

- One or two sentences maximum.
- State the consequence, not the action: "This will permanently remove Meadow Farm Foods and all associated records" not "You have clicked Delete."
- For destructive dialogs, name the entity being deleted.

### Action labels

- Primary action: specific verb — "Delete", "Approve", "Save changes", "Send invitation".
- Cancel: always "Cancel". No exceptions.
- Never "Yes" or "No".
- Never "OK" except in informational dialogs where there is no decision to make.

## Accessibility

- `role="dialog"` with `aria-modal="true"` and `aria-labelledby` pointing to the dialog title.
- Focus the Cancel button on open for destructive dialogs.
- Focus the primary action on open for confirmation and outcome dialogs.
- Escape always equals the safe action (Cancel or close).
- Do not dismiss on scrim click — the user must make an explicit choice.
- Keep Cancel visible but inactive during processing — hidden implies cancelled.

## Do

- Use a Dialog for binary confirmations where the decision is already made.
- Keep dialogs to at most 2 actions.
- Focus Cancel on open for destructive dialogs.
- Focus the primary action on open for confirmation and outcome dialogs.
- Name the entity or items being affected in the dialog body.
- Show affected items as a compact list, not a table.
- Keep the action label consistent — the button and the confirmation toast must use the same verb and scope.
- Make Escape always equal the safe action.
- Go directly from page to dialog for destructive actions when the list row shows sufficient context (record name + at least one supporting attribute).
- Use the record name in the dialog title, not just the entity type.
- State irreversibility explicitly in the dialog body when the action cannot be undone.
- Surface only the consequences that exist — if there are no dependent records, don't mention them.
- Block and explain inline on the triggering element if the action cannot complete due to unresolvable dependencies — don't open a dialog for an action that will fail.
- Use a Dialog to host a short manage list (named user-created objects with inline row actions, no data columns, bounded size).

## Don't

- Use a Dialog if the content requires scroll.
- Put a data table inside a Dialog — a multi-column data table implies review; review belongs before the confirmation. A short manage list is the one exception.
- Use a Dialog when the user needs to reference content outside it to complete the action.
- Use a Dialog for more than 2 independent inputs.
- Let a conditionally-revealed dependent input push a Dialog past the 2-input limit — it counts the same as an independent one.
- Hide Cancel during processing.
- Dismiss a Dialog on scrim click.
- Use "Yes" / "No" as action labels.
- Add a close ✕ button to destructive dialogs.
- Chain more than 2 dialogs.
- Open a Drawer from inside a Dialog.
- Add a Drawer before a destructive dialog when the list row already shows sufficient context.
- Reference only the entity type in a destructive dialog title.
- Hide consequences.

## Related

- **Drawers** — use for detail views and edit forms that don't require a hard interrupt.
- **Toast notifications** — use for non-critical confirmations that don't require a decision.
- **Inline validation** — use for form-level errors that can be shown in context rather than in a dialog.
- **Unsaved changes pattern** — the "Unsaved changes" dialog is a specific dialog instance; see the Forms guidelines.
