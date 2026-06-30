# ADR-001 — Drawer maximum depth is 2

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Foods Connected surfaces routinely involve parent-child record relationships: an audit containing findings, a supplier containing associated sites, a document containing versions. Engineers building these flows have a natural instinct to open a third drawer for sub-detail.

At depth 3, both the page and L1 are fully scrimmed — the user has no visible anchor to their starting context. The navigation stack becomes disorienting, and Escape behaviour (close the top-most surface) gives no clear path back.

## Decision

Drawers stack to a maximum depth of 2 (L1 and L2). At L2, the only way to go deeper is a Dialog. A Dialog floats above the drawer stack without adding a third depth layer.

L1 dims to 35% opacity when L2 is open — this signals depth while keeping the parent visible.

When a Dialog from L2 resolves, update L2 content in place. Do not close and reopen L2.

## Consequences

- Engineers building flows that previously used 3+ drawers must restructure: the third level becomes a Dialog (if a decision is needed) or the L2 content must be rethought (if it was review content, it should have been a full-screen drawer or page).
- Dialog opens from L2 are explicitly allowed and are the sanctioned escape valve.
- Never open a Drawer from inside a Dialog — that would re-enter the stacking model from an already-elevated surface.
