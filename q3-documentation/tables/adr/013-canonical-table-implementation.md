# ADR-013 — ApiDataTable is the canonical table implementation

**Status:** Accepted
**Date:** 2026-06-29

## Context

The codebase contains two tiers of table components. The lower tier provides raw table primitives from `@workspace/ui`: unstyled HTML table elements and a TanStack Table-powered `DataTable` with basic column resizing, ordering, and row selection. The upper tier is `ApiDataTable` from `@connected/composed-kit`, a production-grade wrapper that adds server-side data fetching, filter management, column customization, view persistence, row actions, and pagination in a single composable API.

App code has historically used both tiers directly, and in some cases built custom table implementations from scratch. This has produced tables with inconsistent filter layouts, inconsistent action patterns, inconsistent persistence behaviour, and duplicated boilerplate.

## Decision

`ApiDataTable` from `@connected/composed-kit` is the canonical table component for all production tables in app code.

The raw `DataTable` from `@workspace/ui` is a primitive used internally by `ApiDataTable`. It must not be used directly in app code except when building a new composed table abstraction in `composed-kit`.

`SimpleTable` is the canonical choice for read-only, non-interactive tables with no filtering, sorting, or pagination — embedded lists, summary panels, configuration displays.

Custom table implementations outside these two components are not permitted. New requirements that cannot be met by `ApiDataTable` must be addressed by extending `ApiDataTable` in `composed-kit`, not by building a parallel implementation in an app.

## Implementation

Every production table column is defined as a `ComposedColumnDef<TData>` — the extension of TanStack Table's `ColumnDef` that adds a required `meta` block. The `meta` block carries: `columnKey`, `displayName`, `canFilter`, `canSort`, `visible`, `order`, `locked`, and optionally `filterVariant` and `columnType`.

Column definitions live in a dedicated hook per entity (e.g. `useSupplierColumns`, `useAuditColumns`) that returns `{ columns, defaultColumns }`. This separates column configuration from the component that renders the table.

Filter definitions are provided by a backend endpoint via a `useFiltersQuery` hook. Filter state, sort, and pagination are managed by `useSynchronisedSearchState` and encoded in the URL — see ADR-014.

Row actions are declared via the `RowActionsConfig` shape on the `rowActions` prop — see ADR-016.

## Consequences

- App code that uses raw `DataTable` from `@workspace/ui` is technical debt. Migrate on touch.
- Custom table implementations are technical debt. Migrate on touch.
- New table features (a new filter type, a new column type, a new action slot) must be added to `ApiDataTable` in `composed-kit`, not implemented per-app.
- The `SimpleTable` is not technical debt — it is the correct choice for non-interactive tables.
