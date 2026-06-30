# ADR-030 — PageHeader selector count cap

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

---

## Context

The `selectors[]` slot in PageHeader accepts inline select controls for page-scope filtering (e.g. date range, region, status). As features grow, the number of inline selectors accumulates, producing crowded headers where the filter controls visually compete with the primary CTAs.

## Decision

Maximum 3 selectors in `selectors[]`. If more than 3 are needed, move them to a filter panel.

Beyond 3, the header becomes a filter bar rather than a navigational anchor. The filter panel is the canonical home for extended filter sets.

## Consequences

- Any page with 4+ inline selectors must use a filter panel.
- Adding a fourth selector requires a filter panel implementation — inline addition is not an option.
- If all selectors have equal priority, the least-frequently-used move to the filter panel.
