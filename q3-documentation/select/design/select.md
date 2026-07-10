# Select — Edit/View Rules

**Status:** Draft — not yet integrated into the global ADR numbering. **Owner:** Mona Sweeney. **Last reviewed:** 2026-06-30. **Storybook:** `Form / Select`. **Jira:** WEB2-11422.

> ADR numbering below is local to this guide — global numbers will be assigned on integration with the rest of `q3-documentation`.

---

## Part 1 — Design Guide

*What to build and why. No component names or prop references in this section.*

### 1. Overview

Select fields appear throughout the platform in two distinct modes. In **Edit mode**, the field is an interactive dropdown — the user can open it and change the selected value. In **View mode**, the current selection is displayed as non-interactive text or a colour-coded label. Getting the mode wrong either presents stale data as editable or hides an actionable field behind a read-only surface.

**Use Select (Edit mode) when**

- The user has explicitly opened an edit form, clicked an "Edit" action, or is creating a new record.
- Choosing from a finite, known list of options — status, category, type, priority, country.
- The list has 6–30 options. Fewer than 6: use radio buttons instead. More than 30: use a searchable dropdown instead.
- The field is part of an inline-editable cell that the user has activated.

**Use View mode (do not show the Select trigger) when**

- Displaying a record the user has not opened for editing — detail pages, summary cards, preview panels.
- The user does not have permission to edit the field.
- The record is finalised or locked (e.g. a submitted order, a published template).
- The context is read-only by nature — reports, audit logs, print views.

**When not to use Select at all**

- **Free-text entry** — use a text input.
- **Multiple selections** — use a multi-select pattern.
- **Binary yes/no choice** — use a toggle or checkbox.
- **31 or more options** — use a searchable dropdown so the user can type to find their option.

### 2. Anatomy

| Part | Edit mode | View mode | Notes |
|---|---|---|---|
| Field label | Visible above trigger | Visible above value | Always visible. Never rely on placeholder as the label. |
| Selected value | Inside trigger | Plain text or colour-coded label | View mode: plain text for most fields; colour-coded label for status/category where colour carries meaning. |
| Trigger chevron | Present | Not rendered | Absence of chevron is the primary visual signal the field is in view mode. |
| Placeholder | "Select [field name]" in muted colour when unset | Em dash (—) | View mode: never blank. Never "N/A" or "None". |
| Error message | Below trigger when invalid | Not applicable | Inline error displayed below the field. |

### 3. States

**Edit mode**

| State | Trigger | Behaviour |
|---|---|---|
| Default | Value selected | Trigger shows selected value with chevron. Interactive. |
| Unset / placeholder | No value selected | Trigger shows placeholder text in muted colour. |
| Disabled | Cannot be changed in the current context | Trigger is non-interactive and visually muted — used when conditional on another value not yet set. |
| Loading | Options fetching asynchronously | Trigger is non-interactive while options load, then becomes active. |
| Error | Validation failure | Trigger receives an error border; inline error message below. Never remove the trigger in error state. |

**View mode**

| Variant | When to use | How it renders |
|---|---|---|
| Plain text | Names, categories, types, countries — value is text-only, colour carries no meaning. | Selected label as plain text in the standard body colour. |
| Colour-coded label | Status/category fields where colour carries meaning (Active = green, Pending = amber, Archived = grey). | Label inside a colour-coded badge matching the status semantic colour. |
| Unset | No value set. | Em dash (—) in muted colour. Never blank. |
| Locked *(proposed — not yet implemented by any component; see Engineering Supplement)* | Record is finalised — submitted orders, published templates. | Plain text or colour-coded label, with a lock icon to signal immutability. |

**Unsupported:** interactive trigger in view mode; inline mode toggle (click the value to switch — always use an explicit "Edit" action); nested dropdown inside a dropdown; two-option dropdown (use a toggle or checkbox instead).

### 4. Behaviour

Mode is determined by the parent form or page state — not by a setting on the field itself. The field has no internal mode state of its own; it renders edit or view mode based on a condition passed down from the container.

- Entering edit mode: move focus to the dropdown trigger.
- Exiting edit mode (save/cancel): return focus to the control that initiated the edit.

### 5. Content rules

| Slot | Rule |
|---|---|
| Option labels | Noun or short noun phrase, title case. No verbs, no sentence punctuation. |
| Placeholder (edit mode) | "Select [field name]" — never "Choose…", "Pick a value", or empty. |
| Empty value (view mode) | Em dash (—). Never blank, "N/A", "None", or "Not set". |
| Field label | Always visible. Never substitute placeholder text for a visible label. |

### 6. Accessibility

- Edit mode must be fully keyboard-operable (Tab, Enter/Space, Arrow keys, Escape) with no suppressed default behaviour.
- The trigger must be announced as an interactive control with its options — never overridden or suppressed.
- View mode's label must be programmatically associated with the value — a visible label with no structural relationship is not sufficient.
- Mode transitions must be perceivable to keyboard users, at minimum via focus movement.
- **Locked state must communicate immutability to assistive technology, not only visually via the lock icon.**

### 7. Do / Don't

| ✓ Do | ✕ Don't |
|---|---|
| Show plain text or a colour-coded label in view mode — no trigger, no chevron. | Render a disabled trigger in view mode — looks like a broken edit field and is still announced as interactive. |
| Show em dash (—), muted, when unset in view mode. | Leave unset blank or show "N/A". |
| Use "Select [field name]" as the placeholder. | Use "Choose…", "Pick a value", or no placeholder. |
| Move focus to the trigger when entering edit mode. | Leave focus stranded after switching to edit mode. |
| Use a searchable dropdown at 31+ options. | Use a standard dropdown for 31+ options. |

### 8. Related patterns

Searchable dropdown (31+ options) · Radio buttons (1–5 options) · Toggle/Checkbox (binary choice) · Colour-coded label (status/category) · Truncation pattern (long selected-value labels).

---

## Part 2 — Architecture Decisions

*One record per significant design decision. Local numbering — see note at top of page.*

**Decision — View mode rendering.** View mode always renders as plain text (non-status fields) or a colour-coded label (status/category fields). No interactive trigger, no disabled trigger.
**Why:** the alternative (a disabled trigger) creates visual ambiguity between "broken" and "display-only," and is still announced to screen readers as an interactive control.
**Consequence:** requires a deliberate mode check at the render layer — the field cannot be made view-only by simply setting a `disabled` attribute.

**Decision — Empty value display.** Em dash (—), muted colour. Never blank, "N/A", "None", or "Not set".
**Why:** blank looks like a rendering error; "N/A" falsely implies the field doesn't apply; "None"/"Not set" are verbose and inconsistent across field types.
**Consequence:** *(unverified — not yet cross-checked against table/column empty-state rendering elsewhere on the platform; treat as a new decision, not confirmed existing precedent).*

**Decision — Option count thresholds.** 1–5 options: radio buttons. 6–30: dropdown. 31+: searchable dropdown. Fixed — escalate to design review to override.
**Why:** small sets stay visible without interaction; medium sets fit a compact dropdown; large sets need search to stay usable.
**Consequence:** the 30-option ceiling is a usability heuristic, not a technical limit.

**Decision — Placeholder text.** Always "Select [field name]" — never blank, "Choose…", or "Pick a value".
**Why:** in dense forms, the placeholder is a fallback label once the user has scrolled past the visible label; generic text adds cross-referencing effort for no benefit.

**Decision — Mode ownership.** Mode is a property of the parent form/page state, not the field. The field has no internal mode state.
**Why:** keeps mode transitions consistent across every field on a form and prevents inconsistent partial-form states.
**Consequence:** nothing in the `Select` component itself prevents a consumer from reintroducing a disabled-trigger pattern — see the known engineering gap below.

---

## Part 3 — Engineering Supplement

*How to build it. Verified against `packages/ui/src/components/ui/select.tsx` and `libs/layout-kit/.../read-only-field-display/index.tsx`, 2026-07-10.*

### Component references

| Mode | Component | Reference |
|---|---|---|
| Edit mode | `Select` from `@workspace/ui` — a single component wrapping `Popover` + cmdk `Command`. **Not** Radix UI Select. Options use `{ id, label }`, not `{ value, label }`. | `packages/ui/src/components/ui/select.tsx` |
| View mode — plain text / colour-coded | `ReadOnlyFieldDisplay` — takes `{ size, label, value }`. Pass a `<Badge>` as `value` for colour-coded fields. | `libs/layout-kit/.../read-only-field-display/index.tsx` |
| View mode — colour-coded label | `<Badge>` — `success` (Active), `warning` (Pending), `secondary` (Archived). | `packages/ui/src/components/ui/badge.tsx` |
| Long value truncation | `TruncatedText` — `children`, `showTooltip` (default `true`), `tooltipSide`. | `packages/ui/src/components/ui/truncated-text.tsx` |

### Mode switching pattern

```tsx
{isEditing ? (
  <Select
    options={statusOptions}   // { id, label }[]
    value={value}             // matches option.id
    onValueChange={onChange}
    placeholder="Select status"
  />
) : (
  <ReadOnlyFieldDisplay
    size={size}
    label={{ text: 'Status' }}
    value={selectedLabel ?? '—'}
  />
)}
```

### Accessibility implementation

- **Edit mode ARIA** — `role="combobox"` and `aria-expanded` are set directly on the trigger `Button` inside `Popover`. This is hand-wired JSX, not automatic Radix Select behaviour — the component doesn't use Radix Select at all.
- **View mode labelling** — `ReadOnlyFieldDisplay` renders the label and value together in one labelled container; don't reimplement this with a bare `<span>`.
- **Locked state** — `ReadOnlyFieldDisplay` has no `locked` prop or icon slot today. Before the Locked variant ships: add a `locked?: boolean` prop that renders the lock icon and sets `aria-disabled="true"`, plus visually-hidden `(locked)` text. **Until that lands, treat Locked as proposed, not buildable.**
- **Error state** — associate the error message via `aria-describedby`; use the platform form error component rather than a custom implementation.

### Known engineering gap (informational — not a rule change)

Five form-completer components render read-only `Select` fields as **disabled dropdowns** and share one **generic placeholder** string — both are exactly what the ADRs above already forbid. This is tracked as engineering debt, not a reason to change the rules:

- `libs/form-completer/src/lib/components/form-completer/field-type/field-dropdown/index.tsx`
- `libs/form-completer/src/lib/components/form-completer/field-type/field-dropdown-numeric/index.tsx`
- `libs/form-completer/src/lib/components/form-completer/field-type/field-numeric-dropdown/index.tsx`
- `libs/form-completer/src/lib/components/form-completer/field-type/field-dropdown-comment/index.tsx`
- `libs/form-completer/src/lib/components/form-completer/field-type/field-dropdown-linked/index.tsx`

---

_Source: [Select — Edit/View Rules](https://foodsconnected.atlassian.net/wiki/spaces/UX/pages/1601536012/Select+Edit+View+Rules) (Confluence, UX space). Reviewed and corrected against source 2026-07-10 — see the [ADR repository index](https://foodsconnected.atlassian.net/wiki/spaces/UX/pages/1599373386) for supporting artifacts._
