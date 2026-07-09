# PageHeader

The PageHeader anchors every page in the application. It communicates where the user is, what the page represents, and what they can do from it.

---

## Overview

PageHeader sits at the top of every page — above content, below the app shell navigation. It carries the page title, contextual navigation (breadcrumbs, tabs), and all page-level actions. There is exactly one PageHeader per page.

---

## When to use

Every page in the application has a PageHeader. The variant you choose — **Header–Parent** or **Header–Child** — depends on what the page represents.

| Page type | Variant | Signals |
|---|---|---|
| A list, category, or result set | **Header–Parent** | Page represents many records |
| A single named entity record | **Header–Child** | Page represents one record with a unique identifier |

**Decision test:** "How many records is this page primarily about?" → One → Header–Child. Many → Header–Parent.

---

## navigationTabs vs Views bar

`navigationTabs` and a Views bar serve different purposes and never coexist on the same page.

| Slot | When to use |
|---|---|
| `navigationTabs` | The page represents a single database record (Supplier account, specific Order, named Audit). Tabs reveal different facets of that one record. |
| Views bar | The page represents a query result set of multiple records. Views switch the display or filter of the set. |

**Decision test:** Can you answer "how many records is this page primarily about?" with a specific one? → `navigationTabs`. With many? → Views bar.

See [ADR-027](../adr/027-navigationtabs-single-record.md).

---

## Anatomy

### Required elements

| Element | Notes |
|---|---|
| Title | The page name. Rendered as `<h1>`. Required on all pages. |

### Optional elements

| Element | Header–Parent | Header–Child | Notes |
|---|---|---|---|
| Subtitle | Omit | Always include | Describes the entity type (e.g. "Supplier account", "Audit report"). Never optional on an entity record. See [ADR-029](../adr/029-page-header-subtitle-structural-rule.md). |
| Breadcrumbs | Optional | Recommended | Max 3 visible levels. Deeper paths use middle ellipsis — keeps root + last two, collapses middle with •••. |
| Back link | Optional | Optional | Provides a direct back-navigation target. |
| `navigationTabs` | Omit | Optional | 2–5 tabs. See count rules below. |
| `selectors[]` | Optional | Optional | Max 3. Inline select controls for page-scope filtering (e.g. date range, status). Beyond 3: move to filter panel. |
| `actions[]` | Secondary actions only | Optional (primary CTA) | Page-level CTAs. On Header–Parent pages the primary CTA lives in Slot 4 (Filter / action bar), never here. On Header–Child pages this slot carries the primary CTA. See [ADR-045](../adr/045-primary-cta-placement-header-parent-vs-child.md). |
| `customActions` | Optional | Optional | Escape hatch for non-standard right-side content. |
| `extraRightContent[]` | Optional | Optional | Rendered leftmost in the right-side group. |

---

## Behaviour

### Right-side slot rendering order

Left to right: `extraRightContent[]` → `selectors[]` → `actions[]` → `customActions`. Empty arrays collapse their slot — no gap is introduced. Omitting a prop and passing an empty array are equivalent.

See [ADR-028](../adr/028-page-header-right-slot-order.md).

### Action grouping

| Secondary action count | Treatment |
|---|---|
| 0 | Primary CTA only |
| 1–2 | Render as outline buttons alongside the primary CTA |
| 3+ | Collapse into dropdown. Primary CTA remains standalone. |

See [ADR-031](../adr/031-page-header-secondary-action-grouping.md).

### Selector count

Maximum 3 selectors in `selectors[]`. If more than 3 inline selectors are needed, move them to a filter panel.

See [ADR-030](../adr/030-page-header-selector-count.md).

### navigationTabs count

| Tab count | Treatment |
|---|---|
| 0 | Omit the `navigationTabs` prop entirely |
| 1 | Omit tab strip; render the tab's content as the page body directly |
| 2–5 | Render the tab strip |
| 6+ | Cap at 5. Flag as a required design escalation — do not ship until tab architecture is resolved with design. |

See [ADR-032](../adr/032-page-header-navigationtabs-count.md).

### Breadcrumb ellipsis

Max 3 visible breadcrumb levels. Deeper paths use middle ellipsis (•••) — shows root anchor + last two levels, collapses middle. The ellipsis is interactive: on click or keyboard focus it opens a popover listing hidden ancestor levels as clickable navigation links. Hover-only is not acceptable.

### Collapsed state

`collapsed?: boolean` is a controlled prop. When `true`:

| Element | Behaviour |
|---|---|
| Breadcrumbs | Hidden |
| `navigationTabs` | Hidden |
| Title | Persists |
| Subtitle | Persists |
| Back link | Persists |
| `selectors[]` | Persists |
| `actions[]` | Persists |
| `customActions` | Persists |
| `extraRightContent[]` | Persists |

The component has no internal scroll awareness. The parent (app shell or page layout) is responsible for setting `collapsed`. Scroll-trigger logic belongs in the App Shell guide.

---

## Create-flow header

> **Interim — pending design confirmation (OQ-PH-1)**

Use Header–Child with title "New [Entity]" and the parent list as the breadcrumb root until design confirms the canonical pattern.

---

## Loading state

Title loading: `<Skeleton className='h-10 w-48'>` — 40 px tall, 192 px wide (Tailwind `w-48` = 12 rem). Fixed width, not relative. Never blank, never "Loading…" text.

---

## Accessibility

- Breadcrumb container: `role="navigation" aria-label="breadcrumb"`
- Back button: `aria-label="Back to [parent page title]"` — never just "Back"
- Title: rendered as `<h1>`; use `aria-live="polite"` when the title is async-loaded

---

## Do / Don't

**Do**
- Always include a subtitle on Header–Child pages — it signals the entity type.
- Keep breadcrumbs to a maximum of 3 visible levels.
- Use the data-level test (single record vs result set) to choose between `navigationTabs` and Views bar.
- Make the breadcrumb ellipsis interactive — keyboard and click must both work.

**Don't**
- Don't include a subtitle on Header–Parent pages (category or list pages).
- Don't use `navigationTabs` on a page that represents a result set.
- Don't let Views bar and `navigationTabs` coexist on the same page.
- Don't use more than 3 inline `selectors[]` — move the overflow to a filter panel.
- Don't ship 6+ tabs without a design escalation.
- Don't place the primary CTA in `actions[]` on a Header–Parent page — it belongs in Slot 4 (Filter / action bar).
- Don't render two competing top-level primary actions on a Header–Child page — if the CTA belongs to an embedded table, it lives in that table's toolbar, not `actions[]`.

---

## Related

- [ADR-027: navigationTabs signals a single record](../adr/027-navigationtabs-single-record.md)
- [ADR-028: Right-side slot rendering order](../adr/028-page-header-right-slot-order.md)
- [ADR-029: Subtitle structural rule](../adr/029-page-header-subtitle-structural-rule.md)
- [ADR-030: Selector count cap](../adr/030-page-header-selector-count.md)
- [ADR-031: Secondary action grouping](../adr/031-page-header-secondary-action-grouping.md)
- [ADR-032: navigationTabs count rules](../adr/032-page-header-navigationtabs-count.md)
- [App Shell guide](../../app-shell/design/app-shell.md) — scroll-triggered collapse pattern
- [Pages, Drawers, Sheets & Dialogs](pages.md) — surface selection
- [Engineering supplement](../engineering.md) — implementation notes
