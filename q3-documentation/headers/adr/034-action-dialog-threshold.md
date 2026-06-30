# ADR-034 — Action dialog threshold

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** Dialog Header

---

## Context

Action dialogs (as distinct from destructive warning dialogs) are used for confirmations before multi-record operations, external consequences, and cascading actions. The threshold for when to show one needs to be explicit — the absence of a rule leads to dialogs being added or omitted based on developer intuition rather than a consistent standard.

## Decision

Use an action dialog when any of the following is true:

- The action triggers an external consequence (sends an email, creates a financial transaction, updates a status visible to a third party).
- The action affects 2 or more explicitly selected records.
- The action has documented cascade effects on related records.
- The action cannot be undone within the session without admin action.

Single-record, platform-only, reversible actions do not need an action dialog.

## Consequences

- Teams must document cascade effects when specifying actions that affect related records — undocumented cascades cannot be evaluated against this rule.
- Bulk actions (2+ selected records) always require an action dialog, regardless of reversibility.
- Reversibility within the session (user can undo or restore without admin help) removes the dialog requirement for otherwise borderline cases.
