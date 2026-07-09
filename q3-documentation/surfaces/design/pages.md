# Pages

## Overview

A Page is a full-viewport surface with independent identity. It has its own URL, a unique `<h1>`, and can be reached directly without a parent surface triggering it.

## When to use a Page

Use a Page when the content has independent identity — when a user could reasonably navigate directly to it, bookmark it, or share it with a colleague. The URL is a consequence of independent identity, not the reason to choose the surface.

Do not use a Page because the content needs a URL. Evaluate independent identity first.

## Discriminator

| Question | If yes → |
|---|---|
| Can this content exist without a parent surface triggering it? | Page |
| Does the user return to a triggering surface on dismiss? | Full-screen Drawer |
| Is this ephemeral state that doesn't warrant navigation? | Drawer or Sheet |

## Anatomy

### Required elements

- **Page header** — contains the `<h1>` (page title) and breadcrumb navigation. It never carries the primary CTA — see the App Shell guide's Slot 4.
- **Main content area** — wrapped in `<main role="main">` with `id="main-content"`.
- **Skip link** — first focusable element in the DOM, jumps to `#main-content`.
- **Breadcrumb** — present on all pages below root level.

### Optional elements

- **Sibling navigation (tab bar)** — only when 2–7 siblings exist at the same hierarchy level.
- **Secondary actions toolbar**.
- **Filter / action bar** — anchored below the page header on every page that has a primary action, Header–Parent or Header–Child alike. Carries filter controls when present and the primary CTA, left-aligned — a CTA-only bar is valid when there are no filters. See the App Shell guide's Slot 4.

### Page header layout (slot system)

| Slot | Content |
|---|---|
| 1 | Breadcrumb (above the title row) |
| 2 | Page `<h1>` title |
| 3 | Subtitle or record count |
| 4 | Secondary actions only (right-aligned). The primary CTA never renders here — it lives in the Filter / action bar below the header (App Shell Slot 4), on every page variant. |

**Primary CTA placement** — the primary CTA always lives in the Filter / action bar (App Shell Slot 4), left-aligned, regardless of Header–Parent vs Header–Child variant. See [ADR-045](../../app-shell/adr/045-primary-cta-slot-4-universal.md).

## Behaviour

### SPA navigation

- Move focus to `<h1>` after every client-side navigation.
- Update `document.title` and the browser history entry on each route change.

### Sibling navigation

- Update the URL when switching sibling tabs — each tab is a distinct route.
- Preserve the user's position within each tab across tab switches.
- Tab labels are nouns — they name the content, not the action.

### Scroll restoration

- Restore scroll position when the user returns via the browser back button.
- Do not restore scroll position when navigating forward to a new route.

## Loading, error, and empty states

- **Loading** — show skeleton screens within 100 ms of navigation. Mirror the actual page layout, not a generic spinner.
- **Error** — full-page error with a primary action to retry or navigate away. Include the HTTP status code and a plain-language description of what failed.
- **Empty** — describe what this page will contain once populated. Include a primary CTA to create the first item if the user has permission.

## Content rules

- Page titles are sentence case: "Supplier overview" not "Supplier Overview".
- Breadcrumbs use the same labels as the page `<h1>`.
- Sibling tab labels are nouns — they name the content, not the action.
- Empty states give a specific reason why the page is empty, not a generic "No data found".

## Do

- Use a Page when content has independent identity — it can exist without a parent surface triggering it.
- Give every page a unique, descriptive `<title>`.
- Move focus to `<h1>` after client-side navigation.
- Show skeleton screens that mirror the actual page layout.
- Use a single `<h1>` per page — exactly one.
- Update the URL when switching sibling tabs.

## Don't

- Choose a Page primarily because the content needs a URL — URL is a consequence of independent identity, not the reason to choose it.
- Nest a Page inside a Drawer or Dialog.
- Use a Page for ephemeral state that doesn't need a URL.
- Skip heading levels (h1 → h3 with no h2).
- Show a generic spinner when a skeleton layout is feasible.
- Create grandchild pages with sub-navigation — use a Full-screen Drawer instead.

## Related

- **Drawers** — use when the user needs to view or edit detail without leaving the current page.
- **Sheets** — use for supplementary, non-blocking context panels alongside the page.
- **Dialogs** — use only when a decision is required before any other action is possible.
- **Navigation system** — global side nav, breadcrumbs, and sibling tabs are documented in the Navigation guidelines.
