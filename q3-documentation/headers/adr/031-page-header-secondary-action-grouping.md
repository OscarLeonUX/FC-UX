# ADR-031 — PageHeader secondary action grouping

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

---

## Context

The `actions[]` slot holds the Page Header's secondary actions — see [ADR-045](../../app-shell/adr/045-primary-cta-slot-4-universal.md) for why the primary CTA lives in App Shell Slot 4 instead. Without rules for when to show secondary actions as buttons versus a dropdown, pages accumulate rows of equal-weight buttons, making no single action easy to identify.

## Decision

The grouping rule depends on the PageHeader variant.

**Header–Parent (list) pages:** `actions[]` is not used at all. Both the primary CTA and any secondary actions live together in App Shell Slot 4, clustered as a primary button plus a single icon-triggered dropdown for secondaries — confirmed in Supplier Manager, Audit Manager, and Supply Chain Manager.

**Header–Child (detail) pages:** secondary actions render in `actions[]`, grouped by count:

| Secondary action count | Treatment |
|---|---|
| 0 | Omit `actions[]` entirely |
| 1–2 | Render as outline buttons |
| 3+ | Collapse into a dropdown |

> **Working assumption, not yet verified (2026-07-10):** the Header–Child row above is the logical counterpart to the confirmed Header–Parent pattern, not an observed one — no shipped detail page with secondary actions has been checked against it yet. Spot-check a real example (e.g. a supplier detail view with Duplicate/Archive) before treating it as settled.

## Consequences

- On Header–Parent pages, `actions[]` renders nothing — do not populate it there. If a page needs a secondary action, it belongs in the Slot 4 cluster, not the header.
- On Header–Child pages, up to 2 secondary actions can be rendered as visible buttons; a third triggers a required dropdown.
- The proposed ADR-040 ("header action order") is dropped — moot once Header–Parent secondaries never reach `actions[]` at all.

## Amendment (2026-07-10)

Originally written assuming `actions[]` held a primary CTA alongside secondaries, with the grouping table applying uniformly to every page. [ADR-045](../../app-shell/adr/045-primary-cta-slot-4-universal.md) established that the primary CTA lives in App Shell Slot 4 universally. This amendment adds the Header–Parent/Header–Child split above: on Header–Parent pages, secondary actions also move to Slot 4 alongside the primary (confirmed by codebase evidence), not just the primary CTA — `actions[]` plays no role there at all. Only on Header–Child pages does `actions[]` retain its original purpose, using the original count thresholds for secondary actions only.
