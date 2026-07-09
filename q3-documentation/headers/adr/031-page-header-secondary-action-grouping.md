# ADR-031 — PageHeader secondary action grouping

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

> **Note (2026-07-09):** this ADR was written assuming `actions[]` holds a primary CTA alongside secondary actions. [ADR-045](../../app-shell/adr/045-primary-cta-slot-4-universal.md) supersedes that assumption — the primary CTA lives in App Shell Slot 4 on every page; `actions[]` is secondary-actions-only. The grouping thresholds below (0 / 1–2 / 3+) still apply to the secondary actions themselves, but any "primary CTA" language below is superseded. This ADR has not yet been formally rewritten — see ADR-045's Consequences for the pending scope decision (DC-1-SCOPE).

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
