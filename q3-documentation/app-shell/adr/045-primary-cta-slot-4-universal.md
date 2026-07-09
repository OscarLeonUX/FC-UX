# ADR-045 — ADR-021 reaffirmed: Slot 4 owns the primary CTA on every page

**Status:** Accepted
**Date:** 2026-07-09

## Context

An earlier version of this ADR proposed narrowing ADR-021's scope to
Header–Parent pages only, allowing Header–Child pages to place the primary
CTA in the Page Header's `actions[]` slot instead. That proposal was written
without visibility into a separate, more rigorous cross-app audit (23 apps
scanned, adversarial review, explicit rulings) that had already decided this
exact question: **ADR-021 is upheld, not superseded, for every page**,
regardless of Header–Parent vs Header–Child variant.

This revision corrects that error and reaffirms the original ruling.

`page-header.md` distinguishes two PageHeader variants — Header–Parent
(list, category, result set) and Header–Child (single named entity record)
— but this distinction governs subtitle, `navigationTabs`, and breadcrumb
behaviour. It does not create an exception to where the primary CTA lives.

## Decision

**ADR-021 stands without qualification.** The primary CTA lives in **Slot 4
(Filter / action bar)**, left-aligned, on every page that has one — Header–
Parent and Header–Child alike. It is never placed in the Page Header's
`actions[]` slot, regardless of page variant.

Per ADR-021's own consequences, Slot 4 is required whenever a page has a
primary action, even with no filter controls alongside it — a CTA-only Slot
4 is a valid, intentional layout. This is the mechanism that makes Header–
Child pages (which rarely have filters) still conform: they render a
CTA-only Slot 4 bar, not a header-embedded CTA.

`actions[]` on the Page Header is reserved for **secondary actions only**,
on every page variant. It never carries the primary CTA.

**Table-scoped vs page-scoped actions are a separate question, independent
of this ADR.** If a page contains an embedded data table with its own
primary action (e.g. a related-records table with a "New X" action), that
action lives in the table's own toolbar per the Tables guide. This was never
a Header–Child-only exception — it holds regardless of page variant, because
it is about which surface owns the action (page vs. table), not about the
PageHeader variant.

## Consequences

- `page-header.md`'s `actions[]` slot is corrected: secondary actions only,
  on every page variant — never the primary CTA. Its secondary-action-count
  grouping table is corrected to stop describing itself as grouping
  "alongside the primary CTA."
- `pages.md`'s header slot table is corrected: slot 4 (the Page Header's own
  internal slot numbering, not App Shell's Slot 4) no longer claims to carry
  the primary CTA on Header–Child pages.
- `app-shell.md`'s Slot 4 section is corrected to state the universal rule,
  removing the Header–Child carve-out.
- The CTAs guide (`ctas/design/ctas.md`) is corrected to drop the
  Header–Parent/Header–Child placement split and state the universal rule
  instead.
- ADR-028 and ADR-031 (Page Header right-slot order and secondary-action
  grouping) were originally written assuming `actions[]` held the primary
  CTA. They are not rewritten here — that is a larger, separately-scoped
  follow-up — but readers should treat any "primary CTA" language in those
  two ADRs as superseded by this ADR until they are formally revised.

## Known exception (not a rule)

On at least one existing Header–Parent page, Global Search has been
implemented inside Slot 4 (the Filter / action bar) instead of its correct
location. This is a legacy implementation inconsistency, not an intended
pattern, and must not be replicated in new work.
