# Tables

## Overview

A table presents a structured set of records that users need to scan, filter, sort, and act on. This guide covers what happens at and around the table: column design, filtering, column visibility, saved views, row actions, bulk actions, empty and loading states, pagination, and the toolbar above the table. It does not cover the surface the table lives on — that is covered in the Pages guide.

## When to use a table

A table is appropriate when:
- Records share a consistent set of attributes that benefit from column alignment
- Users need to compare values across multiple records simultaneously
- Users need to filter, sort, or act on a set of records
- The primary workflow is scanning and acting, not reading prose

A table is not appropriate for:
- Fewer than 5 records that are better shown as a card or stacked list
- Records that are structurally dissimilar — use a feed or timeline instead
- Configuration options that belong on a settings page

## Column design

### Alignment

Left-align text values: names, identifiers, statuses, descriptions, free-text fields.
Right-align numeric values that users compare: quantities, weights, costs, percentages, scores.
Left-align dates and times — they are fixed-width strings that do not benefit from right-alignment.
Centre only single-icon columns such as a selection checkbox or a boolean status indicator where the cell communicates presence or absence.

Never centre-align text or numeric data. Centred columns break the vertical scanning line that makes tables readable at speed.

### Column widths

Use fixed widths for predictable data: checkbox columns, status badges, date columns, and numeric columns. Fixed widths prevent layout shift as data loads and make row-level scanning consistent.

Use flexible widths for name, title, and description columns. The primary identifier column — the one that names or identifies the record — receives the most horizontal space in the table. When total column widths do not fill the container, assign remaining space to this column.

Never let a text column shrink below the point at which meaningful content is visible. A column that shows only ellipses is not a column — remove it.

### Data density

**Compact** — 32px row height. Use for high-volume scan workflows: audit logs, import reviews, compliance checklists, activity feeds. Users are reading many rows quickly and rarely interact with a single row in depth.

**Comfortable** — 48px row height. Use for primary entity lists: suppliers, products, incidents, complaints. Users scan fewer rows and act on individual records more often.

Pick the right density for each table based on the workflow it serves. Density is set at build time — there is no user-controlled density toggle in the current component.

### Column headers

Sentence case, noun phrase. "Supplier name", not "SUPPLIER NAME" or "Name of the supplier". Never truncate column headers — widen the column or remove it before truncating its header. A header the user cannot read is not a header.

Sortable columns show a sort direction indicator adjacent to the label when that column is the active sort. On hover of a sortable column, show the indicator in a muted state to signal that the column is sortable. Unsorted columns show no indicator at rest.

### Truncation and wrapping

Truncate cell content by default. Show the full value in a tooltip on hover. Wrapping is only appropriate in description or notes columns where reading a partial value is meaningless. Never wrap in compact density.

### Pinned columns

Pin the primary identifier column to the left and the row actions column to the right when the table has enough columns to require horizontal scrolling. Pinning is not appropriate on tables that do not scroll horizontally. Never pin more than two columns on either side.

## Filtering

### Filter surface

The filter surface takes one of two forms. The surface and its personalisation panel are a matched set — do not mix parts from different patterns.

**Pattern A — Inline filter controls** — filter controls sit directly in the table-level toolbar, immediately after search, on the same row. The filter set is defined at build time; all users see the same options. When the table has more filters than most users need active simultaneously, pair the toolbar with a "Filters" sheet — a drawer that slides in from the right — so users can show and hide individual filters from the predefined list. Locked filters remain visible in the toolbar at all times and cannot be hidden via the sheet.

Use Pattern A when the filter set is defined at build time and the same options suit all users.

**Pattern B — Chip toolbar with sidebar panel** — active filters appear as dismissible chips directly in the table-level toolbar, immediately after search, on the same row. The full filter list lives in a panel that opens to the right of the table. Users pin and unpin individual filters from the panel to control which chips are shown. Pinned selections persist per user. A locked filter's chip is always shown and cannot be dismissed or unpinned.

Use Pattern B when the filter list comes from the server and different users benefit from surfacing different subsets of filters.

### Filter types

Match the control to the data type:

| Data type | Filter control |
|---|---|
| Free text | Text search, debounced — no submit button needed |
| Categorical, ≤8 options | Multi-select dropdown with checkboxes |
| Categorical, many options | Searchable multi-select |
| Boolean flag | Segmented toggle (e.g. All / Active / Inactive) |
| Date or date range | Date range picker with preset shortcuts (Today, Last 7 days, Last 30 days) |
| Numeric range | Min/max range input |
| Related record | Searchable select that resolves to record IDs |

### Active filter indicators

Show active filters as dismissible chips. Each chip displays the field name and value ("Status: Active"). The × on a chip clears that single filter. A "Clear filters" text link appears when two or more filters are active. The chip area collapses to nothing when no filters are active — never show an empty chip bar.

### Filter persistence

Encode active filters in the URL as query parameters. This makes the current filtered view shareable via link and ensures filters survive browser back/forward navigation within a session.

Do not persist filter state across sessions. Users should return to a table in its natural state. The exception is saved views: when a user has a saved view selected, that view's filter set becomes their persistent default for that table.

### Locked filters

Some filters are always visible and non-clearable. Others are visible by default but can be dismissed by the user. Establish which filters are locked and which are default-visible per table — do not rely on users to discover and configure which filters matter for their workflow.

### Clear affordance

"Clear filters" — text link, appears only when at least one non-locked filter is active. Clears all clearable filters simultaneously. Never label it "Reset" or "Remove filters".

## Column visibility and configuration

Offer column show/hide when the table has 8 or more columns, or when different user roles need to see different column subsets. Do not offer it on tables with 6 or fewer columns — the control adds complexity without benefit.

Column visibility is configured in a panel or overlay, not by clicking column headers. Users should not need to interact with the table itself to change its layout.

**Locked columns** cannot be hidden or reordered. Use locked status for the primary identifier column and any column that is essential for all users in all contexts. Locked columns are always visible and in a fixed position.

Column configuration — which columns are visible and in what order — persists per user per table in the current browser via localStorage. The configuration survives across sessions in the same browser but does not sync across devices.

## Saved views

A saved view is a named combination of: filter values, visible columns and their order, and sort column and direction. It answers "show me this category of data, configured this way" — it is not a layout or density setting.

### When to offer saved views

Offer saved views when:
- The table is a primary working surface, not a picker, selector, or embedded list
- Users have meaningfully different recurring filter configurations (e.g. a quality manager focuses on open items, a regional manager filters by location)
- The table has 6 or more configurable dimensions (columns + filters)

Do not offer saved views for simple tables where one configuration serves all users equally well.

### What a view contains

Filter values, visible columns and their order, sort column and direction, and search text. A view does not store the current page number.

### View management

Views appear as tabs above the table. Two categories:

**System views** — defined by the product team. Read-only for users; shown above user views with a visual distinction.

**User views** — created, renamed, and deleted by the user. One view per user can be set as the default, loaded automatically when the table opens.

A dirty indicator (a dot on the active tab) signals that the current table state differs from the saved view. The user can save the current state over the view or discard changes and return to the saved state.

### Naming views

View names should describe what the view shows. "Open audits — EU region" is a correct view name. "My view 1" is not.

## Row actions

### Action slots

Row actions are organised into three slots in priority order:

1. **Always-visible icon buttons** — for the most frequent action (e.g. open the record, view details). Maximum 2. Always visible on every row; not dependent on hover.
2. **Conditional text CTA** — a labelled button that appears only on rows in a specific actionable state (e.g. "Respond" only on checks awaiting a corrective action response). Always paired with an icon. Navigates to another route — never triggers an inline or destructive action. Appears on eligible rows only; rows not in that state show no text button. Use sparingly — a text button widens the action column and competes with data.
3. **Action menu** — for all remaining actions, accessed via a trigger at the right edge of the row. Always contains dangerous actions such as delete.

### Maximum inline actions

Never show more than 2 inline actions (icon buttons or text buttons) per row. If a table requires 3 or more always-visible actions, consolidate into the action menu. A wide action column filled with buttons makes the table harder to scan.

### Hover-reveal is not permitted

Actions must be visible at all times within their slot, or accessible via the action menu. Never show actions only on row hover — they are invisible to keyboard users and touch users, and create an inconsistent experience across input methods.

### Dangerous actions

Destructive row actions — delete, reject, deactivate — must require confirmation before executing. Confirmation may be a dialog, or an inline confirmation state on the row. Never execute a destructive action immediately on first click.

### Action menu loading state

See the [CTAs guide](../../ctas/design/ctas.md#loading-and-disabled-states) — a non-dangerous menu item keeps the menu open with a loading indicator until the call resolves; a dangerous one routes through a confirmation dialog first.

### CTA and text-button labels

See the [CTAs guide](../../ctas/design/ctas.md#labels) for the verb-match and label-length rules that apply to every CTA and text button on this surface.

## Bulk actions

### Row selection

A checkbox column at the leftmost position enables row selection. The header checkbox selects all visible rows on the current page; clicking again deselects all.

### Bulk action placement

When one or more rows are selected, a contextual action bar appears above the table and replaces the normal toolbar. It contains:
- A selection count ("14 suppliers selected")
- Available bulk actions as buttons
- A "Clear selection" control to exit bulk mode

The bar disappears when selection is cleared. The normal toolbar is restored.

Do not mix bulk mode and individual row actions — when the contextual bar is visible, individual row action menus are suppressed.

### Dangerous bulk actions

Dangerous bulk actions require a confirmation dialog stating the affected record count ("Delete 14 suppliers?"). See the [CTAs guide](../../ctas/design/ctas.md#confirmation) for the general confirmation and loading-state rules this follows — only the clicked action button locks; other rows and bulk-bar controls stay interactive.

### Select all across pages

When the user selects all rows on the current page and more rows exist on other pages, offer a "Select all N records" affordance so the user can act on the complete result set. Surface the total count clearly: "All 2,312 suppliers selected."

## Empty and loading states

### No data vs no results — treat differently

**No data** — the table has no records at all, or the user has access to zero records. Show a message and a call to action to create the first record. The CTA is prominent. An illustration is optional.

**No results** — the current filters or search returned zero matches, but records do exist. Show a message indicating no results match the current criteria, with a "Clear filters" link. Never show the create CTA here. Records exist — the filter is wrong, not the data.

Using the same empty state for both situations causes users to create duplicate records. Always distinguish the two.

### Loading states

**No data available yet** — show skeleton rows in the table body. This state fires on initial table open and on any filter combination that has not been fetched before. Toolbar filter controls and pagination are disabled while skeleton rows are shown. Do not use a full-page spinner.

**Refreshing cached data** — when data already exists for the current query, retain the existing rows while new data loads. All controls remain enabled. There is no loading indicator in the toolbar. New rows replace the existing rows silently when the response arrives. Do not re-skeleton the rows for sort, page, or filter changes when data is already cached.

## Pagination

Use numbered, server-side pagination for all primary entity tables. Compliance and audit workflows require navigating to a specific page — "the third page of audit logs" is a real navigation task. Infinite scroll is not appropriate for compliance-critical data.

Default page size: 25 rows. Offer a page size selector (25, 50, 100) when the table regularly contains 50 or more records. Page size preference persists per user.

Always show the current position and total count: "Showing 26–50 of 2,312 suppliers." Position this at the bottom of the table alongside the pagination controls.

## Sorting

Single-column sort is the default. Show the sort direction indicator on the active column header. On hover of a sortable column, show the indicator in a muted state to signal sortability.

Choose a meaningful default sort for each table:
- Most-recently-updated for entity lists (suppliers, products, audits)
- Most-recently-created for activity and log tables
- Alphabetical only when order is genuinely the primary navigation mode

Never default to database insertion order.

Sort state is encoded in the URL alongside filter state. It persists within a session and is cleared on a fresh visit, unless it is part of a saved view.

## Table-level toolbar

The toolbar sits above the table. It contains, left to right:

- **Primary action** — the primary table-level action ("New supplier", "Import") sits first, at the top left of the toolbar. Its icon, if it has one, trails the label — never leads it.
- **Search** — global text search. Fixed width, not inside a column header. Searches across the full dataset, not just the visible page.
- **Filters** — inline in the same row, immediately after search. This applies to both filter surface patterns; neither uses a separate row beneath the toolbar.
- **Right side** — utility controls only (column visibility, export, layout options).

The primary table-level action sits at the top left of the toolbar, before search and filters. It is the first control a user reaches, reflecting that creating a new record is the highest-intent action on the page. It is always visible when the user is not in bulk selection mode.

Global text search and column filters are additive — results must satisfy both simultaneously. When both are active, the search field and filter controls are both visible at the same time.

## Do

- Right-align numeric values that users compare; left-align everything else.
- Pick one density per table — compact for scan-heavy workflows, comfortable for entity lists.
- Truncate cell content with a hover tooltip; wrap only in description columns.
- Show active filters as dismissible chips with a "Clear filters" link.
- Encode filter and sort state in the URL — makes filtered views shareable and session-safe.
- Show skeleton rows when no cached data is available; retain existing rows silently during refresh when data is cached.
- Use distinct empty states for "no data" and "no results" — different messages, different actions.
- Consolidate 3 or more row actions into the action menu.
- Replace the toolbar with a contextual bulk action bar when rows are selected.
- Show "Showing X–Y of N" row count alongside pagination controls.
- Use numbered pagination for compliance and audit tables.
- Offer saved views only for primary working surfaces with meaningfully varied user needs.
- Keep the primary table-level action at the top left of the toolbar, before search and filters.
- Place filters inline in the toolbar immediately after search — same row, both filter patterns.
- Trail the primary table-level action's icon after its label, if it has one.

## Don't

- Centre-align text or numeric data in cells.
- Truncate column headers — widen the column or remove it.
- Show row actions only on hover — they must be visible or accessible at all times.
- Execute a destructive action without confirmation.
- Show the create CTA in a no-results (post-filter) empty state.
- Offer column visibility on tables with 6 or fewer columns.
- Use a full-page spinner on initial table load — use skeleton rows.
- Re-skeleton rows on sort, filter, or page changes when data is already cached.
- Use infinite scroll for compliance or audit tables.
- Persist filter state across sessions — encode in URL and clear on fresh visit.
- Show individual row action menus while the bulk action bar is active.
- Use "Reset" instead of "Clear filters".
- Name a saved view with a generic label ("My view 1") — names must describe what the view shows.
- Mix parts from different filter patterns — Pattern A's inline filter controls pair only with the Filters sheet; Pattern B's chip toolbar pairs only with the sidebar panel.
- Offer a user-controlled density toggle — density is set at build time per table.
- Use a row text button to trigger an in-place action or approval — text buttons navigate to another route; confirmatory and destructive actions go in the action menu.
- Split filters into a separate row beneath the toolbar — keep them inline with search.

## Related

- **CTAs and text buttons** — label, confirmation, loading-state, and icon-treatment rules shared with every other surface.
- **Pages** — the surface that hosts standalone tables. Covers page layout, header actions, and shell navigation.
- **Drawers** — for record detail and quick-edit flows triggered from a table row.
- **Dialogs** — for confirmation of destructive actions initiated from a table row or bulk action.
- **Workflow Patterns** — for multi-step flows triggered from a table-level primary action.
