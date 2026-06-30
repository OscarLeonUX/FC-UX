# ADR-011 — Multi-step form surface escalation

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Multi-step forms appear in two contexts in Foods Connected:

1. **Short guided flows** — 2–4 steps where each step is a focused subset of a larger form. The user is expected to complete the flow in one sitting without navigating away.
2. **Complex, potentially interruptible flows** — import wizards, onboarding sequences, configuration flows with more than 4 steps. A step may include a file upload or a preview that benefits from the full viewport. The user may need to revisit the flow or come back to it.

Engineers building multi-step forms have used both standard Drawer and full-screen surfaces without a principled rule for when to escalate. Short flows have been implemented at full-screen scale (adding unnecessary complexity); complex flows have been forced into a standard drawer (losing viewport space needed for content-heavy steps).

The surface selection rule for all forms — 10 or more total inputs must be a Page — applies to multi-step forms by counting inputs across all steps.

## Decision

**Step 1: apply the 10-input rule first.**

Count the total number of inputs across all steps. If the total is 10 or more, the form must be a Page regardless of step count, interruptibility, or step content. Do not use a Drawer or full-screen Drawer.

**Step 2: if total inputs are fewer than 10, choose by step count and content.**

**Standard Drawer + step indicator** when all of the following are true:
- 2–4 steps
- The user is expected to complete the flow in one sitting
- No step requires the full viewport (no large previews, no file upload with review)

**Full-screen Drawer + step indicator** when any of the following is true:
- More than 4 steps
- The flow may be interrupted and resumed (the user might navigate away mid-flow and need to return)
- A step includes a file upload with review, a content preview, or a data table that requires horizontal space

`StepNavigation` is deprecated and must not be used for new work. Use `Stepper` from `@workspace/ui`.

## Consequences

- Count total inputs before choosing a surface. A 4-step flow with 3 inputs per step totals 12 — it must be a Page.
- Engineers building a 2-step wizard in a full-screen Drawer should evaluate downgrading to a standard Drawer unless there is a specific viewport justification and total inputs are fewer than 10.
- Engineers building a 6-step onboarding flow with fewer than 10 total inputs must use a full-screen Drawer — a standard drawer cannot accommodate the step count without crowding content.
- When a multi-step flow needs a URL (so the user can return to it mid-flow), it is a Page if total inputs are 10 or more; a full-screen Drawer with URL if fewer than 10.
- `StepNavigation` usages found in existing code are technical debt — migrate on touch.
