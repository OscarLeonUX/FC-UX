# Sheet Level — Drawer Header

The Drawer header — title, optional description, and border — establishes context for drawer and sheet interactions. It is the interface between what the user is doing and the form or detail content in the drawer body.

---

## Overview

Every Drawer and Sheet has a title. The description slot is optional and controlled by the `description` prop. Whether the header has a visual separator (`border-b`) is an automatic consequence of what content is present — it is not a separate decision.

---

## When to include a description

Add a `description` when the drawer action needs contextual explanation that the title alone does not provide.

**Include a description when:**
- The action has constraints the user needs to understand before engaging with the form (e.g. "Changes apply to all future orders. Existing orders are unaffected.")
- The scope of the action is ambiguous from the title alone.
- The drawer presents a multi-step process and the description orients the user to the current step.

**Omit the description when:**
- The title is self-sufficient. ("Edit contact details" needs no further explanation.)
- The description would only restate the title in different words.

---

## Anatomy

### Required

| Element | Notes |
|---|---|
| Title | Required on all drawers and sheets. |

### Optional

| Element | Notes |
|---|---|
| Description | Provides context when the title is not self-sufficient. Omitting it triggers `border-b` automatically with default padding. |
| `hideHeaderBorder` | Override for custom layouts. Should not appear in standard patterns. |

---

## Behaviour

### Header border

The header `border-b` is conditional on component internals — it is not a prop the engineer sets directly:

- Applies when: `padding === 'default'` AND no `description` is present AND `hideHeaderBorder` is not set.
- Does not apply when a `description` is provided — the description visually separates the header from the body.

Provide or omit the `description` prop based on content needs. The border follows automatically.

### Padding (source-verified — drawer.tsx)

| Area | Tailwind value | Pixels |
|---|---|---|
| Header | `px-6 py-4` | 24 px horizontal, 16 px vertical |
| Content (default) | `p-6` | 24 px all sides |
| Content (compact) | `p-4` | 16 px all sides |
| Footer | `px-6 py-4` + `border-t` | 24 px horizontal, 16 px vertical |

These values are source-verified. Do not override them for standard layouts.

---

## Do / Don't

**Do**
- Add a description when the action's constraints or scope need explanation beyond the title.
- Omit the description when the title is self-sufficient.
- Rely on the component's automatic border logic — the border is not a decision the engineer manages.

**Don't**
- Don't add a description that only restates the title.
- Don't manually override padding values for standard drawer layouts.
- Don't use `hideHeaderBorder` except in custom-layout edge cases confirmed with design.

---

## Related

- [Pages, Drawers, Sheets & Dialogs](pages.md) — surface selection, drawer size rules
- [Engineering supplement](../engineering.md) — `Drawer` implementation, footer construction
