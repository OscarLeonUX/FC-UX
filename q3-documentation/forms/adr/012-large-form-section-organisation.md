# ADR-012 — Large form section organisation: linear scroll by default; tabs or side-nav only when justified

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Foods Connected has large forms organised in three different ways across apps:

1. **Linear scroll** — all fields visible in a single scrollable column. Simple to implement and comprehend.
2. **Horizontal tabs** — fields grouped into tabs, with each tab acting as an independent sub-form. One real-world example has 12 tabs.
3. **Side navigation with IntersectionObserver** — a sticky side panel links to anchored sections in a long scroll. The active section is highlighted as the user scrolls. One real-world example with this pattern is the edit-associated-site-form.

All three exist in production. Without a guideline, engineers default to tabs when forms feel long, even when tabs are the wrong choice — they hide length rather than organising genuinely independent sections.

The specific problem with tabs used to hide length: a user completing a create flow must visit every tab to complete required fields. Tabs imply the sections are optional or independent. When every tab must be visited, the form would be simpler as a linear scroll with section headers.

## Decision

**Linear scroll** is the default. Use it for all forms unless a specific criterion for tabs or side-nav is met.

**Horizontal tabs** when all three of the following are true:
- The sections are genuinely independent — a user completing one section has no dependency on another, and completing only one section is a valid state.
- Each section is self-contained and could plausibly be completed on its own (e.g. "General settings" vs "Notification preferences" vs "Access control").
- The tab count is 6 or fewer. More than 6 tabs indicates the form is a settings surface and may warrant a different layout entirely (side navigation or a full-page settings structure).

**Side navigation with IntersectionObserver** when both of the following are true:
- The form has more than 15 fields and all fields must be simultaneously present (they cannot be split across tabs without creating false independence).
- User testing or design review has confirmed that the scroll length is disorienting without jump navigation.

Side-nav is the most complex pattern to implement. It requires IntersectionObserver setup, sticky positioning, and active-state management. Only use it when the simpler patterns have been explicitly ruled out.

## Consequences

- A form using tabs where sections are sequentially dependent (the user must complete each in order) must be restructured as linear scroll or a multi-step form (see ADR-011).
- The 12-tab compliance rule form is at the upper limit of the tab pattern — it is tolerated but represents a complexity ceiling. New forms should not exceed 6 tabs.
- When a form is restructured from tabs to linear scroll, section headers (h3-level labels and visual dividers) replace tab titles as the organisational element.
- Side-nav is only introduced with a design review decision — engineers must not add it unilaterally to a form that feels long.
