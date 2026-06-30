# ADR-024: Active nav group auto-expands on every page load

**Status:** Accepted  
**Date:** 2026-06-29

## Context

Nav groups with sub-items are collapsible. A decision was needed on how open/closed state behaves when the user navigates to a page whose nav item lives inside a collapsible group.

Two options were evaluated:
1. **Persist group open/closed state** across navigation — if the user collapsed a group, it stays collapsed even when they navigate into a page within it.
2. **Auto-expand the active group** on every page load — the group containing the active item is always open when the page renders.

## Decision

The group containing the active nav item **auto-expands on every page load**. Group open/closed state is not persisted independently of the active item.

Each collapsible group defaults to `auto` expansion mode — it opens if any descendant route matches the current pathname.

An explicit override is available for groups that should always start open or always start closed (`defaultOpen: true | false`), but `auto` is the default and covers the vast majority of cases.

## Consequences

**Benefits:**
- The active item is always visible on page load. Users never wonder where they are.
- Spatial orientation (knowing your position in the nav hierarchy) is one of the most critical usability properties of sidebar navigation.

**Constraints:**
- Users who manually collapsed a group cannot expect it to stay collapsed when they navigate into a page within it. The active state always wins over the collapsed preference.
- This is an intentional trade-off: spatial clarity takes precedence over the user's most recent manual collapse action.
