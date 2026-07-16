# Forms

## Overview

A form is a structured set of inputs that collects or modifies data. This guide covers the decisions inside the form: layout, required field marking, validation, submit button states, read-only vs edit mode, large form organisation, and when to escalate to a different surface. It does not repeat what the Drawers, Dialogs, or Workflow Patterns guides cover — it fills the gap.

## Surface selection for forms

The surface a form lives on is determined by its purpose and complexity.

| Question | Answer → Surface |
|---|---|
| Does the form create or edit a record that has independent identity — a URL the user navigates to directly? | Yes → **Page** |
| Does the form have 10 or more inputs? | Yes → **Page** |
| Is the form triggered by a record or action and contextually dependent on the page behind it? | Yes → **Drawer** |
| Does the form collect at most 2 independent inputs and require a single decision? | Yes → **Dialog** |

A Sheet is not a form surface — it has no footer, no submit action, and no dirty-state pattern.

A Dialog may contain at most 2 independent inputs. If a flow requires more fields, it is a form and belongs in a Drawer or Page.

The 10-input threshold is a hard rule. A form with 10 or more inputs must be a Page regardless of whether the record has independent identity. Below 10 inputs, apply the standard surface discriminator: a Drawer if the form is contextually dependent, a Page if the record has its own URL and identity.

For multi-step forms, count total inputs across all steps. A 4-step flow with 3 inputs per step reaches 12 total — it must be a Page.

### What counts as an input

Count any interactive control that collects user data and is submitted with the form:

- Text input, textarea, numeric input — 1 each
- Select, multi-select — 1 each (regardless of the number of options)
- Radio group — 1 (the whole group, not each option)
- Checkbox group — 1 (the whole group)
- Single checkbox — 1
- Toggle or switch — 1
- Date picker, date-time picker — 1
- Date range picker — 1 (one range, not two separate date fields)
- File upload — 1
- Search-and-select or autocomplete — 1

Do not count: read-only display values, hidden fields, and search or filter controls within the form that are not submitted.

For a repeating field group (e.g. "Add another contact"), count the number of inputs in one instance of the group — not the number of filled instances. An address block with separate street, city, county, and postcode fields counts as 4 inputs, not 1.

For multi-step forms, count the worst-case path. If some users follow optional branches, count the path with the most inputs — that path governs the surface choice.

At 8 or 9 inputs in a Drawer: technically below the threshold, but if any inputs are complex — a rich-text editor, a file upload, a relational picker that requires external lookup — consider whether the form's real cognitive load warrants a Page before reaching 10.

## Form layout

### Vertical (default)

Label above field, single column. Use in all standard Drawer forms. Fields stack vertically.

Do not use a grid of inputs at the same hierarchy level — multi-column form grids create false visual relationships between unrelated fields and break scanability.

### Horizontal (settings-style)

Label beside field at wide breakpoints. Use in settings-style forms where horizontal space is available, fields have short, predictable values, and the form resembles a data table more than a creation flow.

The label column has a fixed width at wide breakpoints; the field column fills the remaining space.

### Field grouping

Group related fields with a visible section header — a short label or divider that names the group. Use for forms with more than 6 fields or with fields from clearly distinct categories.

A group of fields that share a single semantic purpose (e.g. address: line 1, line 2, city, postcode) may be grouped without a header — their proximity signals the relationship.

## Required and optional fields

Mark required fields, not optional ones. If most fields in a form are required, consider whether any optional fields can be moved to a separate section or a post-creation edit flow.

A required indicator — a red asterisk — appears adjacent to the label. In vertical layouts, use the built-in required mechanism. In horizontal layouts, the required indicator is placed manually in the label column.

Never use the word "required" next to a field — use the asterisk convention. Never mark optional fields with "(optional)" — too noisy at scale.

## Validation

### When to show errors

Do not show validation errors on load. Show field errors after the user has interacted with the field (on blur) or attempted to submit the form.

Show cross-field errors (e.g. duplicate name, conflicting dates) after submission attempt — not as the user types.

### Error hierarchy

| Error type | Where to show |
|---|---|
| Field-level error — invalid value, missing required field | Inline, directly below the field |
| Cross-field error — duplicate name, conflicting values | Inline alert above the form or above the affected section |
| Server error on submission — save failed, permissions error | Toast notification |

Each level is appropriate for a different moment:
- **Field errors** appear during form completion. The user needs to know which specific field is wrong.
- **Cross-field errors** are only knowable after submission. An alert above the form gives context to multiple affected fields at once.
- **Server errors** are not form errors — they are infrastructure or business rule failures. Toast is the correct channel because the form data itself is valid.

### What blocks submission

Block submission when there are field-level validation errors. Do not block on first render — only after the user has attempted to submit.

Never use toast to block or report field-level validation failures.

### Async validation

Some fields must validate against the server after the user has entered a value — checking whether a name is already taken, confirming a code exists. Follow this pattern:

- Trigger the check on blur, only when the value has changed since the last check.
- While the check is in flight, show a loading state on the field. Do not block the user from moving to other fields while the check runs.
- When the check resolves with an error, show it inline below the field — exactly as you would a local validation error.

Async validation errors are field errors. They appear inline, not in a toast.

### Server errors with field-specific detail

Some server responses return errors mapped to specific field names (e.g. an HTTP 422 with a named fields payload). Treat these as field errors, not server errors:

- Render them inline below the named field — not as a toast.
- If the error references a field not visible in the current step of a multi-step form, surface it as a cross-field alert above the form and navigate back to the affected step if possible.

The classification rule: if the error message is specific to a named field the user submitted, it is a field error. If it describes an operation-level failure — save failed, network error, permission denied — it is a server error and goes to toast.

### Conditional validation

When the validity of one field depends on another's value — "End date must be after Start date"; "If reason is 'Other', a description is required" — validate the dependency on submission attempt, not as the user fills in the triggering field.

Keep the dependent field optional in the schema until its trigger condition is met. Do not show the dependent field's error before the triggering field has been completed. Premature validation surfaces errors on fields the user has not yet had a chance to fill in.

### Validation timing

Use on-blur validation by default. The field validates when the user leaves it — not as they type.

Use real-time (on-change) feedback only when the constraint prevents the user from typing a valid value at all — a numeric input that rejects non-numeric characters on keypress. This is an input affordance, not an error state.

Character and word count limits are the one case where a live counter is genuinely useful — show remaining characters as the user types, and display the error state when the limit is reached or exceeded.

Never show a "required" error on a field the user is actively typing in. Wait for blur or a submission attempt.

## Submit button states

| State | Trigger | Behaviour |
|---|---|---|
| Default | Form loaded | Active, primary variant |
| Loading | User has clicked submit; save is in progress | Spinner visible or button text replaced with loading state; button disabled; Cancel remains active |
| Disabled | Form has validation errors after first submission attempt | Disabled; error messages visible on affected fields |
| Error recovery | Save API call has failed | Re-enable the submit button; show server error via toast |

Do not disable the submit button on form load before the user has interacted. The user should be able to discover required fields by attempting to submit.

After a failed save, the submit button must be re-enabled. Never leave it in a loading or permanently disabled state after an error.

## Read-only vs edit mode

Use a single component for both the view and edit states of a record. Do not create separate view and edit components.

When a record is being viewed, fields are displayed as non-interactive. The footer shows a single action to enter edit mode. When edit mode is entered, the same fields become interactive and the footer shows the primary save action and Cancel.

Avoid switching the entire drawer content between view and edit states — this causes layout shift and re-triggers loading states. Instead, toggle field interactivity in place.

A field that is never editable (e.g. a system-generated identifier, an audit-stamped date) should be displayed as static text, not as a disabled input. Disabled inputs imply an editable field that is temporarily unavailable.

## Large form organisation

Three patterns are in use, each appropriate for different scales.

### Linear scroll

For forms up to approximately 15 fields where all fields are equally relevant. Fields stack vertically with section headers or dividers between groups.

This is the default. Do not reach for tabs or side navigation until linear scroll creates a genuine usability problem.

### Horizontal tabs

For forms with genuinely independent sections — sections where a user completing one section has no need to see another simultaneously. Each tab is a self-contained sub-form.

Use tabs at the top of the form, directly beneath the header. One tab level only. Do not use tabs to hide length — if all fields must be completed in sequence, linear scroll is more appropriate.

New forms should not exceed 6 tabs — beyond that, the form is a settings surface and likely warrants side navigation or a full-page settings structure instead (see ADR-012). One existing form has 12 tabs; it's tolerated as a complexity ceiling, not a target for new work.

### Side navigation with anchored sections

For long forms (15+ fields) that must all be visible on one screen and where jump navigation genuinely improves the experience. A sticky navigation panel on the left updates its active state as the user scrolls.

This pattern is significantly more complex to implement. Only use it when both conditions are met: the form is long enough that linear scroll disorients users, and all fields are simultaneously relevant — the user has no natural top-to-bottom completion order and may need to jump between sections at any point.

### Decision tests for layout patterns

Work through these in order. Stop at the first match.

1. Fewer than 15 fields, no genuinely independent sections → **Linear scroll.**
2. Sections pass the independence test below → **Tabs.**
3. Passes the simultaneously-relevant test below → **Side navigation.**

Default to linear scroll when nothing triggers a higher-complexity pattern. Do not add navigation structure to a form that does not need it.

**Independence test for tabs** — all four must be true:
- Completing one section does not require or affect the content of another.
- The section can be left incomplete without making the rest of the form invalid.
- The user has a genuine reason to return and edit this section independently, long after filling in the others.
- The tab count is 6 or fewer (see ADR-012). More than 6 tabs means the form is a settings surface — reconsider side navigation or a full-page settings structure instead of adding another tab.

If any of these fail, the sections are not independent, or there are too many of them. Use linear scroll with section headers.

**Simultaneously relevant test for side navigation** — both must be true:
- The form has 15 or more fields, all simultaneously relevant, with no natural completion order — the user may need to consult or edit any section at any point.
- **User testing or design review has confirmed the scroll length is genuinely disorienting without jump navigation (see ADR-012).** Side navigation must not be added unilaterally because a form merely feels long — this sign-off is required, not optional.

If the form flows naturally from top to bottom, linear scroll is more appropriate. Side navigation's benefit is random access; adding it to a linear flow creates navigation complexity without benefit.

### Section headers and dividers

Use a named section header when the group of fields has a distinct category users would recognise as a unit — "Contact details", "Regulatory information". The header earns its place when users would benefit from knowing the section's name before reading the fields.

Use a divider alone (without a label) when grouping is implied by field proximity and a categorical name would not add clarity. A small visual break between two loosely related single-field groups does not need a header.

Do not use a named header on every small group. Overuse causes readers to ignore headers. A form with headers every 2–3 fields is harder to scan than one with well-grouped fields and fewer headers.

### Section naming

Sentence case noun phrase: "Contact details", not "Contact Details". 2–4 words. Describe what the fields are — not what the user should do: "Supplier address" is correct; "Enter the supplier's address" is not.

Do not prefix section names with numbers ("1. General", "Section 2"). The form's visual structure communicates order. Number prefixes become stale when sections are reordered.

Use title case only for headers that function as navigation anchors — side navigation labels and tab labels — consistent with the Content rules section.

## Create vs edit — single component

Use a single component for create and edit flows on the same entity. The component's behaviour is discriminated by whether an existing entity was passed in.

When creating: the drawer title is the action label (e.g. "New supplier"). The primary action label is the creation verb (e.g. "Create supplier"). Fields are empty or pre-filled with defaults.

When editing: the drawer title is the entity name (e.g. "Meadow Farm Foods"). The primary action label is "Save changes". Fields are pre-populated with current values.

Do not create separate create and edit components for the same entity. Duplication introduces drift — form validation, field behaviour, and server error handling diverge over time.

## Multi-step forms

For flows where fields depend on previous answers, or where the full form is too long and complex for a single scroll.

Use a step indicator above the form content. The footer changes per step:
- Step 1: no Back button. Next or Continue.
- Intermediate steps: Back + Next.
- Final step: Back + the action label (e.g. "Confirm import", "Create supplier").

Use a standard Drawer with a step indicator for short multi-step flows of 2–4 steps.

Escalate to a full-screen Drawer when: the flow has more than 4 steps, the user may navigate away mid-flow and need to return, or a step includes a file upload or preview that requires the full viewport.

If the total number of inputs across all steps reaches 10 or more, the flow must be a Page — not a Drawer or full-screen Drawer.

### Step ordering

Order steps so that earlier steps capture the information needed to configure later steps. A user should never need to revisit a previous step because the current step depends on an answer they have not yet been asked for.

Place confirmation and irreversible actions at the last step. Place information the user must gather from outside the form — a licence number, a reference document — in an early step, so they know what to collect before starting.

When the flow has 3 or more steps, the final step is always a read-only summary of all entries before the submit action.

### Linear vs branching

Linear flows — the same steps for every user — are the default. Branching flows, where earlier answers alter which steps appear or what options are available in later steps, are significantly more complex.

Branching flows must be contained within a Page or full-screen Drawer. Never branch within a standard Drawer. In any branching flow, the user must be able to review all answers across every branch they have taken before final submission.

### Back behaviour

Pressing Back preserves all data entered in the current step and all later steps. Never reset form state on back navigation.

When the user changes an answer on an earlier step and that change affects a later step, attempt to preserve compatible field values. Clear only fields that are directly incompatible with the new answer.

Do not warn the user that progress will be lost when they press Back within a multi-step flow. Back within a flow is a navigation action, not an exit.

### Per-step validation

Validate the current step fully before allowing the user to advance. Block Next or Continue if the current step has errors.

Do not defer all validation to final submission. A user should not reach the final step with an undetected error on step 1.

At the final step, validate the complete form before submission — step-level validation catches most issues, but cross-step constraints (a value entered in step 1 conflicting with step 3) are verified here.

### Step naming

Name steps with short noun phrases: 2–4 words. The step indicator communicates position; the label communicates content. Do not include a step number in the label — "Step 1: Details" is wrong; "Details" is correct.

Name the final summary step "Review" or "Review and confirm", not "Confirm" — "Confirm" implies an action, not a content check.

### Interruptible flows

A flow is interruptible if the user may need to leave and return mid-flow — for example, to locate a reference number in another system or wait for an approval.

Use a full-screen Drawer or Page with an explicit draft save mechanism for interruptible flows. Standard Drawers do not preserve state when closed — closing a standard Drawer destroys draft progress.

Draft save is not submission. A saved draft must be clearly labelled as incomplete and must not trigger downstream actions or notifications that are intended for completed records.

## Content rules

- **Drawer title** — entity name for existing records; action label for create flows. Never prefix with a verb ("Edit Meadow Farm Foods" is wrong — "Meadow Farm Foods" is correct).
- **Primary action label** — specific to the task. "Create supplier", "Save changes", "Approve", not generic "Submit" or "OK".
- **Cancel label** — always "Cancel". Never "Close", "No", "Back", or "Dismiss".
- **Field labels** — noun phrases. Not instructions ("Enter your email" is wrong — "Email address" is correct).
- **Help text** — one sentence maximum. Explains what value is expected or why the field exists. Use for genuinely non-obvious fields only.
- **Placeholder text** — use sparingly. Placeholder disappears on input — it cannot carry instructions the user may need to recall. Never use placeholder as a substitute for a label.
- **Section headers** — title case for headers used as navigation anchors; sentence case for descriptive group labels.

## Accessibility

- Associate every input with its label.
- `required` on the input element as well as the visual asterisk — do not rely on visual convention alone.
- Error messages are associated with their field via `aria-describedby`.
- After a failed submission, move focus to the first field with an error.
- Submit button is a real `<button type="submit">` inside the `<form>`, or uses the form's `id` attribute to submit from outside the form element.
- Do not use `disabled` on an input to make it read-only — use `readOnly` when the value may be submitted.

## Do

- Show field errors after blur or after first submission attempt — not as the user types.
- Use an inline alert for cross-field errors (duplicate, conflicting values).
- Use toast only for server errors on submission — not for validation.
- Treat server-returned field errors (e.g. HTTP 422 with named fields) as inline field errors, not toast.
- Validate each step before allowing the user to advance in a multi-step flow.
- Preserve all form data when the user presses Back in a multi-step flow.
- Name multi-step form steps with short noun phrases; omit step numbers from step labels.
- Keep a single component for create and edit of the same entity.
- Re-enable the submit button after a failed save.
- Keep Cancel active during the save spinner.
- Show section headers for forms with more than 6 fields or clearly distinct categories.
- Use the step indicator footer pattern (Back/Next/action label) for multi-step forms.
- Use a Page for any form with 10 or more inputs — this is a hard rule, not a guideline.
- Display non-editable values as static text, not as disabled inputs.
- Mark required fields with an asterisk; do not mark optional fields.
- Apply the independence test before using tabs; use linear scroll if any section depends on another.

## Don't

- Block submission with a toast — validation errors must appear inline on the form.
- Disable the submit button on form load before the user has interacted.
- Use a grid of multiple input columns — always single column.
- Use placeholder text as a substitute for a label.
- Create separate create and edit components for the same entity.
- Use tabs to hide form length — only use tabs when sections are genuinely independent.
- Leave the submit button in a loading state after a server error — re-enable it.
- Use a Sheet as a form surface — it has no footer and no submit pattern.
- Put more than 2 independent inputs in a Dialog.
- Use "Submit", "OK", or "Confirm" as a primary action label — use a specific verb ("Create supplier", "Save changes", "Approve").
- Put a 10-or-more-input form in a Drawer or full-screen Drawer — use a Page.
- Show a cross-field or dependent-field error before both fields involved have been interacted with.
- Use toast to report errors that map to a specific named field — those are field errors.
- Clear form state when the user presses Back in a multi-step flow.
- Use a standard Drawer for interruptible flows — use a full-screen Drawer or Page with draft save.
- Add named section headers to every small group of fields — overuse makes the form harder to scan.
- Put step numbers inside step labels ("Step 1: Details") — the step indicator already communicates position.

## Related

- **Drawers** — the primary surface for create/edit forms under 10 inputs. Covers dirty state, footer layout, drawer title conventions, and tab usage inside drawers.
- **Dialogs** — use for confirmation steps within a form flow, or for at-most-2-input collection. Not a form surface.
- **Workflow Patterns** — P01 covers the full view-and-edit Drawer pattern including dirty state and save spinner behaviour.
- **Validation** — inline validation note in Dialogs guideline refers to this guide.
- **Unsaved changes pattern** — see the Drawers guideline, Dirty state section.
