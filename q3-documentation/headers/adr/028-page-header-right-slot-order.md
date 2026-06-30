# ADR-028 — PageHeader right-side slot rendering order

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

---

## Context

The PageHeader right-side area accepts multiple slot types: `extraRightContent`, `selectors`, `actions`, and `customActions`. Without a fixed render order, teams placed these in different sequences, producing visually inconsistent page headers across the application.

## Decision

The rendering order in the right-side slot is fixed, left to right:

`extraRightContent[]` → `selectors[]` → `actions[]` → `customActions`

Empty arrays collapse their slot — no gap is introduced. Omitting a prop and passing an empty array are equivalent.

Rationale for this order:
- `extraRightContent` carries supplementary information (status indicators, counts). It sits furthest from the primary CTA where it does not compete for attention.
- `selectors` contextualise the actions, so they precede them.
- `actions` are the primary and secondary CTAs — they sit closest to the far-right edge where visual weight lands.
- `customActions` is an escape hatch and sits rightmost so it does not displace predictable action placement.

## Consequences

- The order is non-negotiable in standard patterns. Deviations require explicit design sign-off.
- Empty array and missing prop behave identically — no defensive rendering is needed.
