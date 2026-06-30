# ADR-026: Tabs and Views bar are discriminated by what vs how

**Status:** Accepted  
**Date:** 2026-06-29

## Context

Two content-switching controls exist in the shell: the Tabs strip (Slot 2) and the Views bar (Slot 3). Both offer the user a way to switch between multiple options in the content area. Without a clear rule distinguishing them, either could be used for either purpose, creating visual and functional inconsistency across apps.

## Decision

The discriminator is a single question:

> **Does changing this control change what is shown, or how it is displayed?**

- **What changes → Tabs (Slot 2).**
  Each tab shows different information about the entity or surface. Removing a tab removes access to information the user cannot get elsewhere. Each tab could be bookmarked as a distinct destination.
  *Example: `Overview · Documents · Contacts · Orders`*

- **How changes → Views bar (Slot 3).**
  Each view shows the same dataset in a different visual format. Removing a view removes only a presentation preference — no information is lost.
  *Example: `List · Grid · Map · Calendar`*

### Supporting rules

- **Tabs minimum 2, maximum 5.** A single tab is redundant — render the content directly. Beyond 5, consolidate or use a "More" dropdown.
- **Views bar minimum 2, maximum 4.** A single view pill is redundant. Beyond 4, the pill group wraps — use a dropdown instead.
- **Coexistence is permitted** — Tabs appear above the Views bar in slot order. The Views bar must only switch display format within the currently active tab.

## Consequences

**Benefits:**
- Clear authorial rule means the right control is always chosen without case-by-case judgment.
- Visual hierarchy matches semantic hierarchy: Slot 2 (what) sits above Slot 3 (how), which correctly signals that Tabs govern more fundamental switching.
- Consistent across all CUI apps — users build a mental model once.

**Constraints:**
- Some controls feel like they could go either way. In ambiguous cases, the "information loss" test is the tiebreaker: if the user would lose access to information by removing the option, it belongs in Tabs.
