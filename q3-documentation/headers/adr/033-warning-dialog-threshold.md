# ADR-033 — Warning dialog threshold

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** Dialog Header

---

## Context

Warning dialogs are used inconsistently. Some teams add them to every irreversible action; others skip them for actions with external consequences. Subjective judgements about what "feels risky" produce different outcomes across teams. A two-question test provides a deterministic rule.

## Decision

Require a warning dialog if **either** condition is true:

1. The action permanently destroys data or makes it inaccessible without admin intervention.
2. The action triggers a consequence outside the platform — sends an email, creates a financial transaction, makes a status visible to a supplier or third party.

If both answers are no and the user can reverse the action themselves in the same session, no warning dialog is needed.

**Soft-delete / archive exception:** When a "delete" action is recoverable via a named Restore path, a lighter confirmation may be appropriate. See the archive/soft-delete pattern guide.

## Consequences

- Teams must evaluate each action against both conditions before deciding whether a warning dialog is required.
- "The user might not have meant to do that" is not a sufficient reason to add a warning dialog.
- Session-reversible, platform-only actions do not require a warning dialog.
- The two-question test is a prerequisite for the design review of any new destructive action.
