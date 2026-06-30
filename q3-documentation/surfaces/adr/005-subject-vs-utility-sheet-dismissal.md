# ADR-005 — Sheet dismissal depends on subject vs utility classification

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Sheets in Foods Connected cover two distinct use cases that look similar from the outside but differ in what the user would lose if accidentally dismissed:

- **Utility sheets** — filters, previews, guidance panels. Their state is either stateless (a preview reflects the record, not user input) or persisted externally (filter state survives close). Accidentally closing one is a low-cost interaction.
- **Subject sheets** — sheets whose content represents the user's own work or a substantive context object. Accidental dismissal would lose meaningful state or context the user cannot trivially recover.

A blanket "dismiss on outside click" rule penalises subject sheets. A blanket "block outside click" rule introduces friction on utility sheets where it is not needed.

## Decision

Outside-click dismissal behaviour is determined by the sheet's classification:

- **Subject sheets** — block outside-click dismissal. The user must use Escape or the explicit close button.
- **Utility sheets** (filters, previews, guidance) — allow outside-click dismissal. These are supplementary and essentially stateless.

The classification is made at build time by the engineer, informed by the answer to: "Would the user lose meaningful state or context if this sheet were accidentally closed?"

## Consequences

- Engineers may not apply a single `onOutsideClick` policy to all sheets without classifying the sheet first.
- Filter sheets are utility sheets — outside-click dismissal is allowed. Filter state is persisted externally (as pills in the page chrome) so closing accidentally does not lose the configuration.
- Engineers building a sheet with a form or substantial user input should treat it as a subject sheet and block outside-click dismissal.
