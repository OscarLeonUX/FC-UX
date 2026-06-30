# Drawers

## Overview

A Drawer is a contextually dependent panel that slides in from the right edge. It has a scrim, traps focus, and blocks the underlying page. The user returns to the triggering surface on dismiss — a Drawer never has independent identity.

## When to use a Drawer

Use a Drawer when the user needs to view or edit detail without navigating away from the current page. The content is contextually dependent: it only makes sense in relation to the record or action that opened it.

## Discriminator

| Question | Answer → Surface |
|---|---|
| Does the content have independent identity — could a user navigate to it directly? | Yes → **Page** |
| Does the page need to stay fully interactive while the panel is open? | Yes → **Sheet** |
| Is a decision required before anything else can happen? | Yes → **Dialog** |
| Is the panel triggered by a record, row, or action and must the page be blocked? | Yes → **Drawer** |

## Anatomy

### Required elements

- **Header** — entity icon + title + close button. The title must be the entity name or action label — not a generic "Details".
- **Content area** — scrollable independently of the underlying page.
- **Footer** — primary and secondary actions. Never stack more than two button-level actions directly; use an overflow menu for additional actions.
- **Close button** — always visible in the top-right corner. Minimum 44×44 px touch target. Escape key also closes.

### Footer layout

- Primary action: right-most.
- Cancel: immediately left of primary.
- Overflow menu: adjacent to Cancel, for additional actions (approve, change status, delist). Opens a dropdown.
- Destructive action (e.g. Delete): `mr-auto` — pushed to the far left of the footer, visually separated from the confirm/cancel pair.

### Tabs inside a drawer

Tabs are allowed once at the top level of the drawer hierarchy — placed directly below the header. One tab level only. Tabs must be closely related siblings sharing the same subject.

For navigation that goes deeper than one tab level, use a full-screen sheet with side navigation instead.

### Scrim behaviour

| State | Scrim |
|---|---|
| Read-only drawer | No scrim. Page interaction limited to scroll only. |
| Drawer with unsaved edits | Scrim appears when the user has made a change. Dismiss triggers an unsaved-changes dialog. |
| Required-context drawer | Permanent scrim. The user must complete or dismiss the drawer before returning to the page. |

## Stacking (depth)

Drawers stack to a maximum depth of 2 (L1 and L2). L1 dims to 35% opacity when L2 is open.

At L2, the only way to go deeper is a Dialog — it floats above the stack without adding a third depth layer. Never open a drawer from inside a dialog.

When a Dialog from L2 resolves, update L2 content in place — do not close and reopen.

## Full-screen Drawer

A Full-screen Drawer occupies the full viewport. Use it when the task needs the full viewport but is contextually dependent — the user returns to the triggering surface on dismiss.

A Full-screen Drawer may have a URL when the task duration means the user might navigate away and return. URL is a consequence of that need, not the reason to choose this surface.

**Content viewer layout** — for Full-screen Drawers that display documents, images, or structured form responses: use a primary content pane (2/3 width) and a metadata side panel (1/3 width). This is a layout variant, not a separate surface.

Do not use a Full-screen Drawer for content with independent identity — use a Page instead.

## Behaviour

### Dirty state (unsaved changes)

Intercept Escape and scrim click with an unsaved-changes Dialog when the drawer has unsaved edits. Never silently discard changes.

- Dialog title: "Unsaved changes"
- Body: "You have unsaved changes. Discard them?"
- Actions: "Keep editing" (primary, receives focus) · "Discard changes" (destructive)

### Escape key

| State | Escape behaviour |
|---|---|
| Clean state | Closes the top-most drawer immediately |
| Dirty state (unsaved changes) | Opens the unsaved-changes Dialog |
| Child drawer open | Closes the child drawer only |

### Animation

Drawer slides in from the right. Duration 250 ms, ease-out. Remove the drawer from the DOM after the close animation completes — do not just hide it.

## Content rules

- **Title** — entity name for existing records (e.g. "Meadow Farm Foods"); action label for create flows (e.g. "New supplier", "Add category"). Never prefix with a verb ("Edit Meadow Farm Foods" is wrong — "Meadow Farm Foods" is correct; the L1/L2 badge signals the mode).
- **Primary action label** — the verb that completes the task: "Save changes", "Create supplier", "Approve".
- **Cancel label** — always "Cancel". Never "Close", "No", "Back", or "Dismiss".

## Accessibility

- Trap focus inside the drawer on open.
- Return focus to the element that triggered the drawer on close.
- `aria-modal="true"` on the drawer root.
- `role="dialog"` with `aria-labelledby` pointing to the drawer title.
- Escape closes or intercepts with an unsaved-changes dialog.

## Do

- Trap focus inside the drawer.
- Preserve page state (scroll, filters) when a drawer opens.
- Intercept Escape and scrim click with an unsaved-changes dialog when the drawer has unsaved edits — never silently discard changes.
- Apply a permanent scrim for required-context drawers.
- Set the drawer title to the entity name for existing records and the action label for create flows.
- Remove the drawer from the DOM after the close animation completes.
- Use a Dialog as the escape valve from L2 — it floats above the stack without adding a third depth layer.
- Use the content viewer layout (2/3 + 1/3) for Full-screen Drawers displaying documents, images, or form responses.
- When a drawer footer has multiple actions (e.g. approve, change status, delist), surface only the primary action and Cancel as buttons — place additional actions in an overflow menu adjacent to Cancel.
- Use a tab bar as top-level navigation inside a drawer when the sections are closely related siblings sharing the same subject — one tab level only.

## Don't

- Stack more than 2 drawers — at depth 3, both the page and L1 are scrimmed with no visible anchor. A Dialog is the only correct surface from L2.
- Use a Full-screen Drawer for content with independent identity — use a Page instead.
- Prefix the entity name in the drawer title ("Edit Beverages" or "View Acorn Foods" are wrong).
- Nest tabs within tabs — one level of tabs is the maximum.
- Use drawer tabs to navigate between unrelated subjects — each independent subject should be its own drawer.
- Update the URL unless the drawer is full-screen and the task duration warrants it.
- Show a scrim on read-only drawers.
- Use "Close" as the cancel label — use "Cancel".
- Open a drawer from inside a Dialog.

## Related

- **Dialogs** — use when a decision is required; the correct surface when a child drawer needs to go deeper than L2.
- **Sheets** — use for non-blocking supplementary panels that don't require a focus trap.
- **Pages** — Full-screen Drawers with a URL are effectively pages and should follow page accessibility rules in addition to drawer rules.
