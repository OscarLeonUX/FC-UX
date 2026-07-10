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
- `extraRightContent` carries supplementary information (status indicators, counts). It sits furthest from the action area where it does not compete for attention.
- `selectors` contextualise the actions, so they precede them.
- `actions` holds secondary actions only — see [ADR-045](../../app-shell/adr/045-primary-cta-slot-4-universal.md) and [ADR-031](031-page-header-secondary-action-grouping.md). The primary CTA lives in App Shell Slot 4, not here. On Header–Parent pages `actions[]` is typically empty; on Header–Child pages it holds the record's secondary actions (Duplicate, Archive, etc.).
- `customActions` is an escape hatch and sits rightmost so it does not displace predictable action placement.

## Consequences

- The order is non-negotiable in standard patterns. Deviations require explicit design sign-off.
- Empty array and missing prop behave identically — no defensive rendering is needed.

## Amendment (2026-07-10)

Originally written assuming `actions[]` held a primary CTA alongside secondaries ("`actions` are the primary and secondary CTAs"). [ADR-045](../../app-shell/adr/045-primary-cta-slot-4-universal.md) established that the primary CTA lives in App Shell Slot 4 universally; the rationale above is updated to match. The rendering order itself — `extraRightContent[]` → `selectors[]` → `actions[]` → `customActions` — is unchanged by this amendment.
