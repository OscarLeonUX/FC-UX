# ADR-021: Primary actions always in Slot 4, never Slot 1

**Status:** Accepted  
**Date:** 2026-06-29

## Context

Pages often have a single primary action — "Create supplier," "Import file," "Run report." A decision was needed on where this action should live in the slot hierarchy.

Two locations were considered:
1. **Slot 1 (Page Header)** — visible at a glance, near the page title.
2. **Slot 4 (Filter / action bar)** — positioned with filter controls, contextually near the content it affects.

## Decision

The primary action (CTA) is always placed in **Slot 4, the Filter / action bar**.

- CTA position within the bar: **left edge**.
- Slot 4 must exist on any page that has a primary action, even if there are no filter controls alongside it. A CTA-only Slot 4 is a valid and intentional layout.

## Consequences

**Benefits:**
- Consistent placement across all CUI pages. Users do not need to scan for where the action is.
- Slot 1 (Page Header) remains purely contextual — title, breadcrumb, status. Mixing action and context in the header creates inconsistency.
- The CTA sits visually close to the content it creates or imports, reinforcing the connection between action and outcome.

**Constraints:**
- Slot 4 must always be rendered on pages that have a primary action, even if it contains only the CTA and no filters. An empty slot must not be used — but a CTA-only Slot 4 is explicitly permitted.
- Header-based CTAs (seen in some older pages) are a legacy pattern and must not be introduced in new work.
