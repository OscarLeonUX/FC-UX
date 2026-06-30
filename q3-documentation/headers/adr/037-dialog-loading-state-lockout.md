# ADR-037 — Both buttons and backdrop disabled during loading

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** Dialog Header

---

## Context

When a dialog's confirm action triggers an API call, the in-flight state must be handled consistently. Some implementations disable only the confirm button while keeping Cancel active; others allow backdrop clicks to close the dialog mid-call. Both create misleading states — the user believes they have stopped the action when the API call is still in flight.

## Decision

During an in-flight API call, all three of the following apply simultaneously:

1. **Cancel is disabled.** The API call is already in flight — the user cannot stop it by closing the UI. Keeping Cancel active implies the action can be cancelled when it cannot.
2. **Confirm is disabled.** Prevents double-submission.
3. **Backdrop clicks are disabled.** Clicking outside the dialog does not close it while a call is in flight, for the same reason as Cancel.

The spinner on the confirm button is the user's feedback that a call is in flight.

## Consequences

- All three lockouts apply for the duration of the call — they cannot be implemented independently.
- Once the call resolves, all lockouts release and the dialog responds to the outcome.
- Post-action behaviour (success and error paths) is documented separately — see the pending design input note in the Dialog Header guide (DH-H9).
