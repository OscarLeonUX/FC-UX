# Engineering Supplement — Tables

Companion to `design/tables.md`. Covers the canonical table component, column definition schema, filter configuration, row actions, views, and empty states.

---

## Component mapping — tables

| Design concept | Component | Import |
|---|---|---|
| Production entity table | `ApiDataTable` | `@connected/composed-kit` |
| Read-only embedded table | `SimpleTable` | `@connected/composed-kit` |
| Column header with sort | `DataTableColumnHeader` | `@connected/composed-kit` |
| Row actions cell | `RowActionsCell` | `@connected/composed-kit` |
| Saved view tabs | `ViewTabs` | `@connected/composed-kit` |
| Toolbar + primary action | `ActionsRow` | `@connected/composed-kit` |
| Active filter chips | `ActiveFilterChipBar` | `@connected/composed-kit` |
| Empty / no-results state | `TableNoResults` | `@connected/composed-kit` |
| Pagination controls | `ApiTablePagination` | `@connected/composed-kit` |

---

## Column definition — ComposedColumnDef

Every column in a production table is a `ComposedColumnDef<TData>` — TanStack Table's `ColumnDef` extended with a required `meta` block.

```tsx
import type { ComposedColumnDef } from '@connected/composed-kit'
import { DataTableColumnHeader } from '@connected/composed-kit'
import { Badge } from '@workspace/ui'

const columns: ComposedColumnDef<SupplierSummary>[] = [
  {
    accessorKey: 'name',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="Supplier name" />
    ),
    cell: ({ row }) => row.original.name,
    meta: {
      columnKey: 'name',
      displayName: 'Supplier name',
      canFilter: false,
      canSort: true,
      visible: true,
      order: 0,
      locked: true,           // always visible, cannot be hidden or reordered
    },
  },
  {
    accessorKey: 'status',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="Status" />
    ),
    cell: ({ row }) => (
      <Badge variant={statusVariant(row.original.status)}>
        {row.original.status}
      </Badge>
    ),
    meta: {
      columnKey: 'status',
      displayName: 'Status',
      canFilter: true,
      canSort: true,
      visible: true,
      order: 1,
      locked: false,
      filterVariant: 'select',
    },
  },
  {
    accessorKey: 'lastModified',
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="Last modified" />
    ),
    cell: ({ row }) => formatDateTimeDisplay(row.original.lastModified),
    meta: {
      columnKey: 'lastModified',
      displayName: 'Last modified',
      canFilter: true,
      canSort: true,
      visible: true,
      order: 2,
      locked: false,
      filterVariant: 'date',
    },
  },
]
```

### meta field reference

| Field | Type | Description |
|---|---|---|
| `columnKey` | `string` | Stable identifier. Used for view persistence, URL sync, and localStorage. Never change after release. |
| `displayName` | `string` | Human-readable name shown in the column customizer panel. |
| `canFilter` | `boolean` | Whether this column participates in filter customization. |
| `canSort` | `boolean` | Whether the column header is a sort trigger. |
| `visible` | `boolean` | Whether the column is visible by default. |
| `order` | `number` | Default display order (ascending). |
| `locked` | `boolean` | If true, the column cannot be hidden or reordered. Use for the primary identifier and action columns. |
| `filterVariant` | `'text' \| 'select' \| 'multi-select' \| 'date' \| 'range'` | Filter control type when the column is filterable. Required when `canFilter: true`. |
| `columnType` | `'data' \| 'action'` | `'action'` marks the column as the row actions column. |

### Column sizing

Set `size` on the column definition (not in `meta`) to control pixel width. For fixed-layout tables (`fixed` prop on `ApiDataTable`), also set `minSize` on columns that must show meaningful content — without it, columns proportionally share remaining space and can shrink below readable width.

```tsx
{
  accessorKey: 'lastModified',
  size: 140,       // preferred pixel width
  minSize: 100,    // minimum when table is in fixed layout
  // ...
}
```

The primary identifier column should not have a fixed `size` — leave it flexible so it absorbs remaining horizontal space (design rule: primary identifier column receives the most space).

### Density

The component does not currently expose a `density` prop — row height is fixed at `h-[41px]` in `DataTable`. The compact/comfortable distinction is a design concept that maps to which table is used and how it is configured, not a runtime switch. There is no user-controlled density toggle.

---

## Column definition hook

Column definitions live in a dedicated hook per entity. The hook returns the column array and the list of default visible column keys.

```tsx
// apps/supplier-manager-app/src/hooks/use-supplier-columns.tsx
export function useSupplierColumns() {
  const columns: ComposedColumnDef<SupplierSummary>[] = [
    // ... column definitions
  ]

  const defaultColumns = columns
    .filter(c => c.meta.visible)
    .map(c => c.meta.columnKey)

  return { columns, defaultColumns }
}
```

---

## ApiDataTable — standard usage

```tsx
import { ApiDataTable } from '@connected/composed-kit'
import { useSupplierColumns } from '../hooks/use-supplier-columns'

export function SupplierTable() {
  const { columns, defaultColumns } = useSupplierColumns()

  return (
    <ApiDataTable<SupplierSummary>
      columns={columns}
      defaultColumns={defaultColumns}
      getRowId={row => row.id}
      useSearchQuery={(params, opts) =>
        client.suppliers.search(params).useQuery(opts)
      }
      useFiltersQuery={() => client.suppliers.filters.useQuery()}
      defaultSort={{ column: 'lastModified', direction: 'desc' }}
      hasSearch
      hasFilterCustomisation
      hasColumnCustomisation
      filterCustomizationStorageKey="suppliers-filters-v1"
      lockedFilters={['name']}
      defaultVisibleFilters={['name', 'status', 'lastModified']}
      onGetRowActions={row => ({ /* see Row actions section */ })}
    />
  )
}
```

### Key props

| Prop | Type | Description |
|---|---|---|
| `columns` | `ComposedColumnDef<TData>[]` | Column definitions from the column hook. |
| `defaultColumns` | `string[]` | Column keys visible by default. |
| `getRowId` | `(row: TData) => string` | Stable row identifier. Used for selection and view persistence. |
| `useSearchQuery` | `(params, opts) => Query` | TanStack Query hook that accepts `SearchState` params and returns paginated results. |
| `useFiltersQuery` | `() => Query` | Hook returning `FilterDefinition[]` from the backend. |
| `defaultSort` | `{ column: string, direction: 'asc' \| 'desc' }` | Initial sort when no URL state is present. |
| `hasSearch` | `boolean` | Enables the global text search input. |
| `hasFilterCustomisation` | `boolean` | Enables filter show/hide controls. |
| `hasColumnCustomisation` | `boolean` | Enables the column visibility panel. |
| `filterCustomizationStorageKey` | `string` | Stable localStorage key for filter visibility config. Convention: `{entity}-{context}-filters-v1`. |
| `lockedFilters` | `string[]` | Filter keys that are always visible and non-clearable. |
| `defaultVisibleFilters` | `string[]` | Filter keys visible by default (user can show/hide others). |
| `nonClearableFilters` | `string[]` | Filter keys that cannot be cleared by the user, even if visible. |
| `onGetRowActions` | `(row: TData) => RowActionsConfiguration<TData>` | Per-row action configuration function — see below. |
| `emptyState` | `ReactNode` | Custom empty state — use to distinguish no-data from no-results (see ADR-015). |
| `select` | `(row: TData) => TProjected` | Optional projection applied before passing rows to columns. |

---

## Filter patterns

The design guide defines two filter patterns. Props differ between them — do not mix props from Pattern A into Pattern B or vice versa.

### Pattern A — Inline filter row + Filters sheet

Enabled by `hasFilterCustomisation`. Filter definitions are set at build time via column `meta`. User can show/hide filters from a predefined list via the "Filters" sheet (`FilterCustomizer` component).

```tsx
<ApiDataTable
  hasFilterCustomisation
  filterCustomizationStorageKey="suppliers-filters-v1"
  lockedFilters={['name']}                              // always shown, cannot be hidden
  defaultVisibleFilters={['name', 'status', 'category']} // shown by default, user can toggle
  nonClearableFilters={['name']}                        // chip has no × — value cannot be cleared
  {/* ... */}
/>
```

**Filter tier system (Pattern A):**

| Tier | Props | Behaviour |
|---|---|---|
| Locked | `lockedFilters` | Always visible in the filter row. Checkbox in sheet is checked and disabled. Cannot be hidden. |
| Default-visible | `defaultVisibleFilters` | Shown by default. User can uncheck in the sheet to hide. State persists to localStorage under `filterCustomizationStorageKey`. |
| Available-but-hidden | (all others) | Not shown by default. User enables via the sheet. |

`lockedFilters` and `nonClearableFilters` are separate concerns: a filter can be locked (cannot be hidden) without being non-clearable (value can still be reset), and vice versa.

### Pattern B — Chip toolbar + sidebar panel

Enabled by `filterLayout='sidebar'`. Filter definitions come from the backend via `useFiltersQuery`. Users pin and unpin individual filters from the sidebar panel; pinned selections persist per user.

```tsx
<ApiDataTable
  filterLayout="sidebar"
  useFiltersQuery={() => client.suppliers.filters.useQuery()}
  lockedFilters={['name']}   // chip is always shown and cannot be unpinned
  {/* ... */}
/>
```

Pattern B has no `defaultVisibleFilters` or `filterCustomizationStorageKey` — those are Pattern A props. All non-locked filters in Pattern B start unpinned; users build their own pinned set. There is no maximum pin count.

---

## Row actions — RowActionsConfig

```tsx
import type { RowActionsConfiguration } from '@connected/composed-kit'
import { ClipboardCheck, Eye, Pencil, Trash } from 'lucide-react'

// onGetRowActions receives each row and returns its action configuration.
// This is the correct pattern for conditional actions — the function runs per row.
<ApiDataTable
  onGetRowActions={(row: SupplierCheck): RowActionsConfiguration<SupplierCheck> => ({
    // Slot 1: always-visible icon buttons (max 2)
    // Use for actions unambiguous from their icon alone (view, edit, download).
    iconButtonActions: [
      {
        icon: <Eye className="h-4 w-4" />,
        hintText: 'View check',
        onClick: () => navigate({ to: '/checks/$id', params: { id: row.id } }),
      },
    ],
    // Slot 2: conditional text CTA — appears only on rows in a specific actionable state.
    // Always paired with an icon. Navigates to another route — never triggers inline action.
    buttonActions: row.canRespond
      ? [
          {
            children: (
              <>
                <ClipboardCheck className="h-3 w-3" />
                Respond
              </>
            ),
            variant: 'outline',
            className: 'h-6 gap-1 rounded-md px-2 text-xs',
            onClick: () =>
              navigate({ to: '/checks/$id/respond', params: { id: row.id } }),
          },
        ]
      : [],
    // Slot 3: action menu items
    rowMenuItems: [
      {
        id: 'edit',
        text: 'Edit',
        icon: <Pencil className="h-4 w-4" />,
        onClick: () => openEditDrawer(row),
      },
      {
        id: 'delete',
        text: 'Delete',
        icon: <Trash className="h-4 w-4" />,
        destructive: true,
        onClick: () => openDeleteDialog(row),   // opens a confirmation dialog — never deletes immediately
      },
    ],
  })}
/>
```

`onGetRowActions` is called once per row on every render. Rows where `buttonActions` is an empty array show no text button — the action column stays narrow.

Destructive `rowMenuItems` (where `destructive: true`) receive `text-destructive` styling. The `onClick` must open a confirmation dialog — never perform the destructive action directly.

---

## Saved views — ViewTabs

Wrap `ApiDataTable` with `ViewTabs` to enable saved views:

```tsx
import { ViewTabs, ApiDataTable } from '@connected/composed-kit'

<ViewTabs entity="suppliers" variant="default">
  <ApiDataTable<SupplierSummary>
    {/* ... all ApiDataTable props */}
  />
</ViewTabs>
```

The `entity` string becomes part of the localStorage key: `composed-kit:views:{entity}`. Treat it as a stable identifier — changing it discards all existing user views.

`variant` options:
- `'default'` — pill-style Radix Tabs
- `'line'` — chip-button style (plain `<button>` elements)

API-backed view persistence is supported via the `useViewsQuery` prop on `ViewTabs`.

---

## Empty state — no-data vs no-results

The `emptyState` prop on `ApiDataTable` accepts a `ReactNode`. Provide distinct content for no-data and no-results states (ADR-015):

```tsx
import { TableNoResults } from '@connected/composed-kit'
import { Button } from '@workspace/ui'

function SupplierEmptyState({
  hasActiveFilters,
  onClearFilters,
  onCreateSupplier,
}: {
  hasActiveFilters: boolean
  onClearFilters: () => void
  onCreateSupplier: () => void
}) {
  if (hasActiveFilters) {
    return (
      <TableNoResults
        message="No suppliers match your current filters."
        action={
          <Button variant="secondary" onClick={onClearFilters}>
            Clear filters
          </Button>
        }
      />
    )
  }

  return (
    <div className="flex flex-col items-center gap-4 py-12 text-center">
      <p className="text-muted-foreground text-sm">
        No suppliers yet. Add your first supplier to get started.
      </p>
      <Button onClick={onCreateSupplier}>Add supplier</Button>
    </div>
  )
}

// Usage:
<ApiDataTable
  {/* ... */}
  emptyState={
    <SupplierEmptyState
      hasActiveFilters={hasActiveFilters}
      onClearFilters={clearAllFilters}
      onCreateSupplier={openCreateDrawer}
    />
  }
/>
```

`hasActiveFilters` is derived from the current `SearchState` — truthy when any filter value or search text is set.

---

## Toolbar — ActionsRow and primary action

The primary table-level action (create, import) can be placed in one of two locations:

**Option A — ActionsRow** (within the table): use `primaryAction` on the `ActionsRow` component that sits between the filter row and the table. Suitable when the action is tightly scoped to the table.

**Option B — Shell header** (via `setHeaderActions`): use the `SidebarShell` header slot. Suitable when the action is a page-level action, not just a table action — for example, when the page has multiple content areas.

Do not use both simultaneously. Pick the location that matches the action's scope.

---

## Deprecated patterns

| Pattern | Replace with |
|---|---|
| Raw `DataTable` from `@workspace/ui` in app code | `ApiDataTable` from `@connected/composed-kit` |
| Custom table implementation per app | `ApiDataTable` — extend in composed-kit if needed |
| `useState` / `useReducer` for filter or sort state | `useSynchronisedSearchState` (wired internally by `ApiDataTable`) |
| Inline `useState` for column visibility | `hasColumnCustomisation` prop + `filterCustomizationStorageKey` |
| Single generic empty state for all table conditions | Distinct no-data and no-results states (ADR-015) |
| Row actions revealed only on hover | Always-visible icon buttons or action menu (ADR-016) |
| Immediate execution of destructive row actions | Confirmation dialog before execution (ADR-016) |
| Bulk actions in a persistent toolbar | Contextual bar that replaces the toolbar on selection (ADR-017) |
