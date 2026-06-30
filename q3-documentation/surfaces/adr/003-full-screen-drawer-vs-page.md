# ADR-003 — Full-screen Drawer vs Page: independent identity is the discriminator

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Some tasks in Foods Connected need the full viewport — document review, multi-step imports, complex form flows — but differ from each other in one critical way: some are contextually dependent (they only make sense when triggered from a specific record or action) and some have independent identity (they can be reached directly, shared, or bookmarked).

The presence of a URL was historically used as a proxy for "this should be a page." This led to full-screen drawers being given URLs when they did not have independent identity, which confused navigation and the back-button model.

## Decision

The discriminator between a Full-screen Drawer and a Page is **independent identity**, not the presence of a URL.

- **Full-screen Drawer** — use when the task needs the full viewport but is contextually dependent. The user returns to the triggering surface on dismiss. The back button or close button takes the user back to where they came from, not to a root navigation destination.
- **Page** — use when the content has independent identity. A user could navigate to it directly, bookmark it, or share it with a colleague without losing context.

A Full-screen Drawer *may* have a URL when the task duration means the user might navigate away and return (e.g. a multi-step import that takes several minutes). The URL is a consequence of that need — not the reason to choose this surface. Before assigning a URL, ask: "Does this content make sense without the triggering context?" If no, it is a Full-screen Drawer with a convenience URL, not a Page.

## Consequences

- Engineers must evaluate independent identity before choosing between a Full-screen Drawer and a Page — not ask "does this need a URL?"
- Full-screen Drawers that currently have URLs but lack independent identity are architecturally correct if they were given URLs for session-persistence reasons. They are incorrect if they were given URLs because "it felt like a page."
- Pages must follow page accessibility rules (unique `<h1>`, skip link, focus management on navigation).
- Full-screen Drawers that have a URL must also follow page accessibility rules in addition to Drawer rules.
