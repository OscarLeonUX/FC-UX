# ADR-020: ← Back wires to an explicit route, never browser history

**Status:** Accepted  
**Date:** 2026-06-29

## Context

The ← Back button in the sidebar appears on every drill-down and Settings sub-page. It signals "go up one level in the current navigation hierarchy." A decision was needed on how to compute the target.

Two options were evaluated:
1. **Browser history (`router.back()` or `window.history.back()`)** — navigates to wherever the user was before.
2. **Explicit route constant** — the developer declares the parent route at the point of use.

## Decision

← Back always wires to an **explicit, declared route target** — the immediate parent in the navigation hierarchy.

The target is determined by page type:
- Two-level drill-down (list → detail): Back target is the list route
- Three-level drill-down (list → detail → sub-page): Back target is the detail route (not the list)
- Create-new forms: Back target is the list the form was launched from
- Settings sub-pages: see ADR-022 for the Settings-specific model

## Consequences

**Benefits:**
- Predictable. Users who arrive via deep link or external bookmark still get a meaningful parent destination.
- Deterministic. ← Back always goes to the same place regardless of how the user arrived.
- Accessible. Keyboard and screen reader users can predict where the button will go.

**Constraints:**
- The developer must declare the Back target explicitly. This is a small authoring cost that pays for predictable navigation.
- There is no "go back to where you actually were" affordance. This is intentional — the shell is a structured navigation system, not a browser tab.
