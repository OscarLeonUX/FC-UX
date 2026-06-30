# ADR-025: App icon badge is a home link when a dashboard exists, static otherwise

**Status:** Accepted  
**Date:** 2026-06-29

## Context

The app icon badge (32×32px) sits in the sidebar header. It is a persistent, prominent element visible on every page. A decision was needed on whether it should be interactive (a link) or decorative (a static element).

Three options were considered:
1. **Always a home link** — always navigate somewhere on click.
2. **Static element** — never interactive.
3. **Conditional** — home link when a meaningful home destination exists; static otherwise.

"Meaningful home destination" means a dashboard or landing page that functions as the starting point of the app's primary workflows.

## Decision

The app icon badge is:
- A **home link** when the app has a dashboard or landing page.
- A **static element** when there is no dashboard or landing page.

Linking to an arbitrary first nav item (because a link is expected) is explicitly rejected. An app without a logical home is better served by a non-interactive badge than by a link that appears purposeful but resolves to a page that is not a meaningful starting point.

## Consequences

**Benefits:**
- When a home destination exists, the badge gives users a reliable escape hatch from any flow — a single click returns them to the start.
- When no home exists, a non-interactive badge is less confusing than a badge that links to an arbitrary destination.
- The decision is per-app, not system-wide, allowing apps at different maturity stages to behave correctly.

**Constraints:**
- The app team must explicitly declare whether a home URL exists. There is no automatic detection. The declaration is part of the sidebar configuration.
