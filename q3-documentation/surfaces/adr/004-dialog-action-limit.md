# ADR-004 — Dialog action limit is 2

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Dialogs in Foods Connected were found with 3 actions in production: a primary action, a secondary action, and a Cancel button. This pattern creates decision paralysis — the user faces three choices at the moment they most need clarity.

The secondary action in these cases was almost always navigational ("View skipped records", "View report") — it took the user somewhere after the primary action completed. Cancel was a separate, independent escape path.

## Decision

A Dialog has **at most 2 actions**. The two permitted patterns are:

1. **Standard** — primary action + Cancel.
2. **Outcome** — primary action + one secondary action that replaces Cancel. The secondary action navigates to the result of the primary action (e.g. "View skipped records"). It does not coexist with Cancel — it replaces it. Total: 2.

Primary + secondary + Cancel together is always a violation.

If an outcome dialog genuinely needs more than 2 actions, surface only the primary action. Show the additional detail in a drawer opened from the outcome dialog or from the resulting page.

## Consequences

- All existing dialogs with 3 actions must be reduced to 2. Typically this means removing Cancel when a secondary action is present (the secondary action already provides an exit path).
- Engineers building outcome dialogs must choose: does the user need to act on the result (secondary replaces Cancel) or can they simply acknowledge it (primary only, then toast)?
- The "primary + secondary replaces Cancel" model assumes the secondary action is always available. If the secondary action is conditional (e.g. only shown when there are skipped records), fall back to a standard primary + Cancel dialog and surface the conditional detail elsewhere.
