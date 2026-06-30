# ADR-031 — PageHeader secondary action grouping

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

---

## Context

The `actions[]` slot accepts a primary CTA and zero or more secondary actions. Without rules for when to show secondary actions as buttons versus a dropdown, pages accumulate rows of equal-weight buttons, making the primary action hard to identify at a glance.

## Decision

The grouping rule is based on secondary action count:

| Secondary action count | Treatment |
|---|---|
| 0 | Primary CTA only |
| 1–2 | Render as outline buttons alongside the primary CTA |
| 3+ | Collapse secondary actions into a dropdown. Primary CTA remains standalone. |

The primary CTA is always standalone — it never enters the dropdown.

## Consequences

- Up to 2 secondary actions can be rendered as visible buttons; a third triggers a required dropdown.
- If a page requires 3+ secondary actions, a dropdown implementation is mandatory — not optional.
- The primary CTA's visual weight (filled button) must not be diluted by too many adjacent outline buttons.
