# ADR-045 — Primary CTA placement depends on Header–Parent vs Header–Child

**Status:** Accepted
**Date:** 2026-07-09

## Context

ADR-021 mandated that the primary action (CTA) is always placed in Slot 4
(Filter / action bar), left-aligned, and that "header-based CTAs... must not
be introduced in new work." That rule was written without reference to page
type, and conflicts with `page-header.md`, which defines an `actions[]` slot
directly on the PageHeader component — documented as available on both the
Header–Parent and Header–Child variants.

`page-header.md` already distinguishes two PageHeader variants:

- **Header–Parent** — a list, category, or result set (many records).
- **Header–Child** — a single named entity record.

In practice, the primary CTA's correct placement depends on which variant
the page uses.

## Decision

- **Header–Parent pages** — the primary CTA lives in **Slot 4 (Filter /
  action bar)**, left-aligned, per ADR-021. It is never placed in the Page
  Header's `actions[]` slot. ADR-021 remains in force, narrowed to
  Header–Parent pages specifically.
- **Header–Child pages** — the primary CTA may be placed in the Page
  Header's `actions[]` slot, right-aligned, per `page-header.md`'s existing
  right-slot order.
- **Exception on Header–Child pages:** if the page's primary action
  actually belongs to an embedded data table (e.g. a related-records table
  with its own "New X" action), that action lives in the table's own
  toolbar per the Tables guide — not in the Page Header. A Header–Child
  page must never carry two competing top-level primary actions.

## Consequences

- `page-header.md`'s `actions[]` carries the primary CTA only on
  Header–Child pages. On Header–Parent pages, `actions[]` (if used at all)
  is reserved for secondary, non-primary actions.
- `pages.md`'s header slot table is updated to reflect the same split.

## Known exception (not a rule)

On at least one existing Header–Parent page, Global Search has been
implemented inside Slot 4 (the Filter / action bar) instead of its correct
location. This is a legacy implementation inconsistency, not an intended
pattern, and must not be replicated in new work. The common rule remains
as stated in the Decision above.
