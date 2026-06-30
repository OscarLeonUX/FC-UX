# ADR-035 — ConfirmDialog vs Modal

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** Dialog Header

---

## Context

Both `ConfirmDialog` and `Modal` can present a warning or action confirmation. The choice has been made inconsistently — some teams use `ConfirmDialog` for complex cascade impacts that a description field cannot accommodate; others use `Modal` for simple one-sentence confirmations that do not need a body section.

## Decision

| Pattern | Condition |
|---|---|
| `ConfirmDialog` | The full impact fits in one or two sentences. Title + description only — no body content needed. |
| `Modal` | The impact requires enumeration — a list of cascading consequences, affected records, or warning items. |

**Decision test:** "Does the user need to read a list to understand what they're committing to?" → Yes → `Modal`. No → `ConfirmDialog`.

`ConfirmDialog` is a composed component that handles focus management, button variants, and the async spinner. Use it for standard destructive and confirmation dialogs rather than composing `Dialog` manually.

## Consequences

- A `ConfirmDialog` must not contain body content beyond a description string.
- A `Modal` used for confirmation must include a body section with the enumerated impact.
- If an engineer cannot fit the full impact into one or two sentences, they must use `Modal` — cramming a list into a description string is not acceptable.
