# ADR-044 — A conditional dependent input counts toward the Dialog input limit

**Status:** Accepted
**Date:** 2026-07-08

## Context

ADR-004 established that a Dialog has at most 2 actions. Separately, the Dialogs guide caps a Dialog at 2 independent inputs — "one input = one control group... beyond 2 inputs the surface has become a form — use a Drawer instead."

That rule was written for independent inputs. It did not say what happens when one of the 2 inputs is not independent — when its value conditionally reveals a further, dependent input (e.g. a reason dropdown where selecting "Other" reveals a description field). Left unaddressed, this created a loophole: a Dialog could carry 2 top-level inputs plus an arbitrary number of conditionally-revealed ones and still read as compliant, because the conditional field is never "the 3rd independent input."

## Decision

A conditionally-revealed dependent input **counts toward the 2-input limit**, exactly as an independent one would.

2 base inputs + 1 conditional dependent input = 3 control groups → exceeds the limit → use a Drawer instead.

This follows the same logic as ADR-004's treatment of conditional actions: a conditional element is not exempt from the cap just because it isn't always present. If a component only appears sometimes, design for the case where it appears — don't let conditionality launder a form into a dialog.

Branching input logic (if X then show Y) is itself form behavior. The 2-input cap exists specifically to keep Dialogs from becoming forms; a conditional field is the clearest case of that line being crossed, not an exception to it.

## Consequences

- Any Dialog with 2 inputs where one conditionally reveals another must move to a Drawer.
- Designers and engineers should treat "does this input branch?" as a disqualifying question during Dialog vs. Drawer discrimination, not just "how many inputs are visible right now."
- A Dialog may still have 2 inputs where neither is conditional — that remains fully compliant.
