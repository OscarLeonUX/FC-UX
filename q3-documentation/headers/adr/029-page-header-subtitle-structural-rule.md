# ADR-029 — PageHeader subtitle structural rule

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

---

## Context

The subtitle field in PageHeader is used inconsistently. On some entity record pages it is present; on others it is omitted. On list pages it occasionally appears with contextual descriptions. The original guidance ("add a subtitle when context would be useful") is too ambiguous to produce consistent outcomes — "useful" depends entirely on the author's judgement.

## Decision

The subtitle rule is structural, not contextual:

- **Header–Child (entity record pages):** Subtitle is always present. It identifies the entity type — "Supplier account", "Audit report", "Product specification". It is never optional on an entity record.
- **Header–Parent (category or list pages):** Subtitle is always omitted.

The subtitle's job on an entity record is to anchor the entity type so users who land deep in the navigation always know what kind of thing they are looking at. Removing it leaves the title without categorical context.

## Consequences

- A Header–Child page without a subtitle is a defect.
- A Header–Parent page with a subtitle is a defect.
- Subtitle content should name the entity type, not describe the page's current state or the user's current action.
