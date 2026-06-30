# ADR-027 — navigationTabs signals a single record

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

---

## Context

Two navigation patterns coexist in the platform: `navigationTabs` in the PageHeader and a Views bar. Teams have used them interchangeably without a clear rule, producing inconsistent patterns across pages.

The original guidance — "use tabs when the entity is a proper noun" — was too ambiguous. "Supplier list" is also a proper noun in context. A test grounded in the data model is verifiable and produces a deterministic answer.

## Decision

`navigationTabs` signals that the page represents a single database record with a unique identifier. A Views bar signals a query result set of multiple records. They never coexist on the same page.

**Decision test:** "How many records is this page primarily about?" → One → `navigationTabs`. Many → Views bar.

Examples:

| Page | Records | Pattern |
|---|---|---|
| Supplier account (ACME Corp) | One | `navigationTabs` |
| Supplier list | Many | Views bar |
| Audit detail (Audit #4821) | One | `navigationTabs` |
| Audit list | Many | Views bar |

## Consequences

- Pages must be classified as single-record or result-set before PageHeader props are specified.
- Any page with both `navigationTabs` and a Views bar is a defect.
- The test is verifiable from the data model — no subjective judgement required.
