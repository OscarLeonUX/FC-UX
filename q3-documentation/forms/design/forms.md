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

A form with 12 tabs is at the upper limit. Beyond that, consider a multi-step pattern or a Page with side navigation.

### Side navigation with anchored sections

For long forms (15+ fields) that must all be visible on one screen and where jump navigation genuinely improves the experience. A sticky navigation panel on the left updates its active state as the user scrolls.

This pattern is significantly more complex to implement. Only use it when both conditions are met: the form is long enough that linear scroll disorients users, and all fields are simultaneously relevant.

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
- Keep a single component for create and edit of the same entity.
- Re-enable the submit button after a failed save.
- Keep Cancel active during the save spinner.
- Show section headers for forms with more than 6 fields or clearly distinct categories.
- Use the step indicator footer pattern (Back/Next/action label) for multi-step forms.
- Use a Page for any form with 10 or more inputs — this is a hard rule, not a guideline.
- Display non-editable values as static text, not as disabled inputs.
- Mark required fields with an asterisk; do not mark optional fields.

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

## Related

- **Drawers** — the primary surface for create/edit forms under 10 inputs. Covers dirty state, footer layout, drawer title conventions, and tab usage inside drawers.
- **Dialogs** — use for confirmation steps within a form flow, or for at-most-2-input collection. Not a form surface.
- **Workflow Patterns** — P01 covers the full view-and-edit Drawer pattern including dirty state and save spinner behaviour.
- **Validation** — inline validation note in Dialogs guideline refers to this guide.
- **Unsaved changes pattern** — see the Drawers guideline, Dirty state section.
