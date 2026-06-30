# Sheets

## Overview

A Sheet is a non-modal supplementary panel. It surfaces contextual detail — filters, previews, related records, guidance — alongside the current page without blocking interaction with it. The user can continue working on the page while a sheet is open.

## When to use a Sheet

Use a Sheet when the page must stay fully interactive while the panel is open. The sheet does not trap focus and does not show a scrim. The discriminator is what happens to the page behind it — not the content purpose.

## Discriminator

| Question | Answer → Surface |
|---|---|
| Must the page stay fully interactive while the panel is open? | Yes → **Sheet** |
| Must the page be blocked? | Yes → **Drawer** |
| Does the panel shrink the page content area when it opens? | Yes → **SidebarShell** (not Sheet) |

### Sheet vs Drawer

The choice is determined by what happens to the page behind it — not by content purpose. A Sheet never traps focus and never has a scrim. If the background must be blocked — regardless of whether the surface is for viewing, editing, or configuring — use a Drawer.

### Sheet vs SidebarShell

There is a third panel primitive: **SidebarShell**. It is not a Sheet.

SidebarShell shrinks the page content area when it opens — the panel and the grid are visible simultaneously, and both remain fully interactive. Use SidebarShell when the panel is permanently available via a toolbar toggle and is coupled to a specific grid or table (e.g. FilterSidebar, ColumnSidebar).

Use Sheet when the panel is triggered by a specific action, row, or record, and overlaying the page is acceptable.

Do not substitute Sheet for SidebarShell — Sheet overlays; SidebarShell shrinks. The interaction model is different in kind.

## Types

| Type | Position | Behaviour |
|---|---|---|
| **Side Sheet** | Right edge, full height | Overlays the page — no scrim, no focus trap. Use for contextual panels triggered by a row, record, or action. |
| **Inline Sheet** | Within content grid | Appears as a column within the layout. |
| **Bottom Sheet** | Bottom of viewport | Mobile-primary; slides up from bottom. |
| **SidebarShell** | Right edge, full height | Not a Sheet component — a distinct primitive. Shrinks the page content area when open. Use for toolbar-toggled panels permanently coupled to a grid (FilterSidebar, ColumnSidebar). |

## Anatomy

### Required elements

- **Header** — title + close button. Minimum 44×44 px touch target. Required even if the sheet was opened without a trigger — the user must always be able to dismiss it.
- **Content area** — scrollable independently.

### Optional elements

- **Footer** — for sheets that have their own persistent actions. Filter sheets typically do not have a footer because filters apply immediately.
- **Resize handle** — side sheets only.

## Dismissal: subject vs utility

The outside-click dismissal rule is not the same for all sheets.

| Sheet type | Outside-click dismissal |
|---|---|
| **Subject sheet** — content is substantive; accidental dismissal would lose meaningful state or context | **Block** outside-click dismissal |
| **Utility sheet** — filters, previews, guidance; supplementary and essentially stateless | **Allow** outside-click dismissal |

Do not apply a blanket dismiss-on-outside-click rule to all sheets.

## Filter sheets

### Two types of filter sheet

There are two distinct filter sheet patterns. The rules below apply **only to filter application sheets**. Do not apply them to filter configuration sheets.

| Type | Purpose | Behaviour |
|---|---|---|
| **Filter application** | User narrows the list by applying filter values | Immediate — filters apply on every change, no Apply button |
| **Filter configuration** | User manages which filters are visible and their display order | May have an explicit commit step |

### Filter application behaviour (Immediate)

- Apply filters immediately on every checkbox change — no Apply button, no debounce.
- Do not debounce checkbox changes — filters are discrete choices, not continuous input.
- Surface a zero-results warning inside the sheet when the active filter combination returns no results — do not wait for the user to close the sheet.
- Persist active filters as removable pills in the page chrome when the sheet is closed.
- Make "Clear all" immediate — it resets filter state and the list without a separate confirm step.
- Show an active filter count on the sheet trigger button when filters are applied.

## Full-screen sheet with side navigation

When tabs inside a sheet would need to go to a second level of hierarchy, use a full-screen sheet with a side navigation panel instead of nesting tabs.

## Persistence

A sheet's open state must persist across in-page navigation (e.g. switching sibling tabs). If the user opened a filters sheet on the "Active" tab and navigates to "Archived", the sheet remains open.

## Accessibility

- **Docked sheet** — `role="complementary"` with a meaningful `aria-label`.
- **Floating sheet** — `role="dialog" aria-modal="false"`.
- Tab moves freely between sheet and page — do not trap focus inside a sheet.
- Do not move focus into the sheet on open — the page remains active.

## Content rules

- Sheet title describes the content, not the action: "Supplier filters" not "Filter suppliers".
- Close button tooltip: "Close [sheet title]" — e.g. "Close Supplier filters".
- A sheet does not have a primary CTA footer in most cases — filters apply immediately with no commit step. Exception: sheets that require an explicit commit for a self-contained, non-filter action; the action label must be specific, not "Apply".
- Do not use the word "Panel" in any user-facing label.

## Do

- Keep the page fully interactive while a sheet is open.
- Allow Tab to move freely between sheet and page.
- Persist the sheet's open state across sibling-tab navigation.
- Use `role="complementary"` for docked sheets.
- Keep only one sheet open at a time.
- Block outside-click dismissal on subject sheets.
- Allow outside-click dismissal on utility sheets (filters, previews, guidance).
- Distinguish filter application sheets from filter configuration sheets — the Immediate rules apply only to filter application.
- Use a Sheet (not a Drawer) for filters — the list must stay visible and interactive so the user can see results update as they filter.
- Apply filters immediately on every checkbox change — no Apply button.
- Persist active filters as removable pills in the page chrome when the sheet is closed.

## Don't

- Trap focus inside the sheet.
- Show a scrim when a sheet opens.
- Move focus into the sheet on open.
- Call this component a "Panel" in user-facing text.
- Use a sheet for content requiring a user decision — that is a Dialog.
- Apply a blanket dismiss-on-outside-click rule to all sheets.
- Use a Drawer for filters — the scrim blocks the list and breaks the live feedback loop.
- Add an Apply button to a filter application sheet.
- Debounce filter checkbox changes.
- Clear filter state when the sheet is closed.
- Surface the zero-results state only after the sheet is closed.

## Related

- **Drawers** — use when the page must be blocked or focus trapped.
- **SidebarShell** — use when the panel is permanently coupled to a grid and must shrink the page alongside it.
- **Dialogs** — use when a decision is required.
- **Filter patterns** — detailed filter behaviour is documented in the Data Display guidelines.
