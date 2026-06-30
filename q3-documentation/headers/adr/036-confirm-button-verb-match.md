# ADR-036 — Confirm button label must match the title verb

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** Dialog Header

---

## Context

Dialog confirm buttons are frequently labelled "Confirm" regardless of what the action is. This breaks the user's mental model — "Confirm" does not tell the user what will happen, and creates a disconnect with the dialog title that names a specific action. The pattern is widespread enough to need an explicit rule rather than relying on per-team discretion.

## Decision

The confirm button label must match the title verb exactly.

| Dialog title | Confirm button |
|---|---|
| "Delete category" | "Delete" |
| "Send audit request" | "Send" |
| "Archive supplier" | "Archive" |
| "Submit for approval" | "Submit" |

Use "Confirm" only when the dialog action is itself a confirmation — the user is reviewing and accepting pre-presented information, not triggering a new state change (e.g. "Confirm your order details" — the user is verifying, not acting).

## Consequences

- Generic "Confirm" labels are a defect on any dialog that triggers a state change.
- The confirm button label must be specified as part of the dialog design, not defaulted in code.
- Verb-matching applies to all dialog types: destructive, action, and form confirmations.
- Code review should catch "Confirm" labels on dialogs where the title names a specific action verb.
