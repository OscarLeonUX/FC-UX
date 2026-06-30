# ADR-019: Sidebar collapse state is a global user preference

**Status:** Accepted  
**Date:** 2026-06-29

## Context

The sidebar can be toggled between expanded (full width) and collapsed (icon rail). A decision was needed on whether this state should be:
- **Per-page** — resets on every navigation
- **Per-app** — persists within one app session
- **Global** — persists across all apps and page loads

## Decision

Sidebar collapse state is a **global user preference**, persisted across app switches and page reloads.

The state is stored in the browser's `localStorage` under the key `sidebar:state`. It is loaded on mount and written on every toggle. It is not bound to a specific app or route.

## Consequences

**Benefits:**
- Users who prefer the collapsed rail get it everywhere, consistently.
- No disorienting expand/collapse transitions when navigating between pages.
- Collapse preference survives page reload without requiring an authenticated API call.

**Constraints:**
- Apps cannot force the sidebar into a specific state for a specific page — the user's preference always wins.
- The Settings sidebar is an intentional exception: it is always full-width regardless of this preference. The Settings sidebar uses a separate non-collapsible component. See ADR-022.
