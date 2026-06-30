# ADR-010 — Required fields display a visual indicator; optional fields are not marked

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Forms across the platform apply different conventions for communicating required and optional fields. Some forms mark required fields with an asterisk. Some mark optional fields with "(optional)". Some mark both. Some mark neither.

The inconsistency means users cannot build a reliable mental model. When a form marks both required and optional fields, the visual density increases without adding information — each label must carry a redundant classification that users could infer from the absence of the other marker.

Three approaches were considered:

1. **Mark required fields** — a visual indicator on required fields; optional fields carry no marker. The absence of a marker implies "optional."
2. **Mark optional fields** — "(optional)" text on optional fields; required fields carry no marker.
3. **Mark both** — visual indicator on required, "(optional)" on optional.

## Decision

Required fields display a visual indicator adjacent to the label. Optional fields are not marked.

The convention "no marker = optional" is more widely understood than "no marker = required." Marking required fields is the industry-standard convention, consistent with WCAG authoring practices and established web form patterns. Marking both adds visual noise without adding information. Marking only optional fields inverts an established convention and penalises the majority case.

The indicator must always have a text or programmatic equivalent — it cannot be communicated by colour or shape alone.

## Consequences

- Optional fields must not be marked with "(optional)" or any equivalent text. The absence of a required indicator is the signal.
- Required indicators must not rely on colour alone. The visual mark must be present regardless of colour differentiation.
- When reviewing forms, the absence of a required indicator on a required field is a defect.
- The engineering supplement for forms documents how to render the required indicator correctly in vertical and horizontal label layouts.
