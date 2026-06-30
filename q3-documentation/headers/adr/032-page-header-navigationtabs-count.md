# ADR-032 — PageHeader navigationTabs count rules

**Status:** Accepted
**Date:** 2026-06-29
**Guide:** PageHeader

---

## Context

The `navigationTabs` prop accepts any number of tab definitions. Without count rules, pages have been shipped with single tabs (redundant UI chrome) or large tab counts (navigation that exceeds available viewport width and becomes unusable at common breakpoints).

## Decision

| Tab count | Treatment |
|---|---|
| 0 | Omit the `navigationTabs` prop entirely |
| 1 | Omit the tab strip. Render the tab's content as the page body directly. |
| 2–5 | Render the tab strip normally. |
| 6+ | Cap at 5. Flag as a required design escalation — do not ship until tab architecture is resolved with design. |

**Why 5 as the cap:** Beyond 5 tabs, the tab strip approaches the typical content-area viewport width at 1280 px, risking horizontal scroll or label truncation at common breakpoints. 5 provides a safe upper bound that works across the supported breakpoint range.

## Consequences

- A page with one tab definition must not render the tab strip.
- A page with 6+ tab definitions must escalate to design before implementation begins — the 5-tab cap is an engineering gate, not a suggestion.
- If design hands over a 6-tab spec, the spec must be revised before the engineer picks it up.
