# ADR-022: Settings sidebar is always non-collapsible

**Status:** Accepted  
**Date:** 2026-06-29

## Context

The sidebar has two variants: the Default sidebar (collapsible, for data pages) and the Settings sidebar (for configuration flows). A decision was needed on whether the Settings sidebar should also support collapse.

The Settings sidebar displays:
- ← Back button with a visible label
- Section group labels (e.g. "Company", "Integrations")
- Sub-page nav items

All of these require visible text to be meaningful. An icon rail for Settings navigation would be non-functional.

## Decision

The Settings sidebar is **always full-width and non-collapsible**. There is no collapse trigger in the Settings sidebar.

The Settings sidebar uses a separate non-collapsible sidebar component, distinct from the Default collapsible sidebar.

## Consequences

**Benefits:**
- ← Back label, group labels, and sub-page labels are always legible.
- The absence of a collapse trigger is itself a mode signal — it tells the user they are in a separate context (Settings) from the standard data pages.

**Constraints:**
- Users who prefer the collapsed rail in standard pages cannot carry that preference into Settings.
- This is intentional: Settings navigation is structured differently (two-level hierarchy with labelled sections) and requires visible text at all times.
- The Settings sidebar never responds to the global `sidebar:state` localStorage value set by the Default sidebar (see ADR-019).
