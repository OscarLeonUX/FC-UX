# Engineering Supplement — App Shell

Companion to `design/app-shell.md`. Covers the canonical shell components, sidebar configuration, nav type structure, header wiring, and collapse state persistence.

---

## Component mapping — app shell

| Design concept | Component | Import |
|---|---|---|
| Default (collapsible) sidebar | `ShellSidebar` | `@connected/shell-kit` |
| Settings (non-collapsible) sidebar | `SubSidebar` | `@connected/shell-kit` |
| Page header bar | `MainHeader` | `@connected/shell-kit` |
| Page title / breadcrumb context | `useHeader`, `HeaderProvider` | `@connected/shell-kit` |
| User account menu | `NavUser` | `@connected/shell-kit` (used internally by shell) |
| App switcher overlay | `AppSwitcher` | `@connected/shell-kit` (used internally by shell) |
| Command palette (Ctrl+K) | `CommandPalette`, `CommandPaletteProvider` | `@connected/shell-kit` (used internally by shell) |

---

## ShellSidebar — standard usage

```tsx
import { ShellSidebar } from '@connected/shell-kit'
import type { ShellSidebarConfig } from '@connected/shell-kit'
import { LayoutGrid, Package, Users, AlertTriangle } from 'lucide-react'
import { useNavigate } from '@tanstack/react-router'

const sidebarConfig: ShellSidebarConfig = {
  appName: 'Supplier Manager',
  appIcon: Package,
  homeUrl: '/dashboard',           // omit when no dashboard exists — see ADR-025
  navigation: [
    {
      label: 'Navigation',
      hideLabel: true,
      items: [
        { title: 'Dashboard', url: '/dashboard', icon: LayoutGrid },
        { title: 'Suppliers', url: '/suppliers', icon: Users },
        { title: 'Complaints', url: '/complaints', icon: AlertTriangle },
      ],
    },
  ],
  commandPaletteRoutes: [
    { title: 'Suppliers', url: '/suppliers', keywords: 'supplier vendor' },
    { title: 'Complaints', url: '/complaints', keywords: 'complaint issue' },
  ],
  footerGroupLabel: 'More',
  isActive: (url, pathname) => pathname.startsWith(url) && url !== '/',
}

export function AppSidebar() {
  return <ShellSidebar config={sidebarConfig} />
}
```

### ShellSidebarConfig — key fields

| Field | Type | Description |
|---|---|---|
| `appName` | `string` | Display name shown in the sidebar header. |
| `appIcon` | `LucideIcon` | Icon rendered in the 32×32px badge. Default: `LayoutGrid`. |
| `homeUrl` | `string` | Route the badge navigates to. Omit when no dashboard exists — badge becomes static. |
| `navigation` | `NavGroup[] \| (() => NavGroup[])` | Sidebar nav structure. Pass as a function when items depend on hooks. |
| `isActive` | `(url, pathname) => boolean` | Custom active-route matcher. Default: exact match. Override for prefix or trailing-slash matching. |
| `footerGroupLabel` | `string` | When provided (e.g. `'More'`), wraps footer utility items in a labelled group. |
| `footerContent` | `ReactNode` | Additional content rendered inside the More group (above App Switcher). |
| `userMenuItems` | `UserMenuItem[]` | Extra items in the user account dropdown, above "Log out". |
| `commandPaletteRoutes` | `CommandPaletteRoute[] \| (() => CommandPaletteRoute[])` | Route entries for Ctrl+K search. |

---

## SubSidebar — Settings variant

Used for all pages in a settings flow. Non-collapsible; always full-width. See ADR-022.

```tsx
import { SubSidebar } from '@connected/shell-kit'
import type { SubSidebarConfig } from '@connected/shell-kit'
import { Settings, Building, Puzzle } from 'lucide-react'
import { useNavigate } from '@tanstack/react-router'

export function SettingsSidebar() {
  const navigate = useNavigate()

  const config: SubSidebarConfig = {
    appName: 'Company Settings',
    appIcon: Settings,
    backButton: {
      label: 'Back',
      onBack: () => navigate({ to: '/suppliers' }),    // explicit route — see ADR-020
    },
    navigation: [
      {
        label: 'Settings',
        items: [
          { title: 'Company Profile', url: '/settings/company', icon: Building },
          { title: 'Integrations', url: '/settings/integrations', icon: Puzzle },
        ],
      },
    ],
    isActive: (url, pathname) => pathname === url,
  }

  return <SubSidebar config={config} />
}
```

### SubSidebarConfig — key fields

| Field | Type | Description |
|---|---|---|
| `appName` | `string` | Section name shown in the header (e.g. `'Company Settings'`). |
| `backButton` | `{ label?: string, onBack: () => void }` | Back button at the top of the Content zone. `onBack` must navigate to an explicit route — never call `router.back()`. |
| `showFooter` | `boolean` | Whether to show the App Switcher + NavUser footer. Default: `true`. |
| `isActive` | `(url, pathname) => boolean` | Custom active-route matcher. |

---

## NavGroup / NavItem — type reference

```tsx
import type { NavGroup, NavItem, NavSubGroup } from '@connected/shell-kit'
import { Users, ChevronDown } from 'lucide-react'

// Flat group (no collapsible sub-items)
const flatGroup: NavGroup = {
  label: 'Navigation',
  hideLabel: true,
  items: [
    {
      title: 'Suppliers',
      url: '/suppliers',
      icon: Users,
      badge: <span className="text-xs">12</span>,    // count badge — only permitted badge type
    },
  ],
}

// Collapsible sub-group
const collapsibleGroup: NavGroup = {
  label: 'Settings',
  subGroups: [
    {
      label: 'Supplier Settings',
      icon: Users,
      defaultOpen: 'auto',    // opens when any descendant route is active — see ADR-024
      items: [
        { title: 'General', url: '/settings/suppliers/general' },
        { title: 'Approvals', url: '/settings/suppliers/approvals' },
      ],
    },
  ],
}
```

### NavItem fields

| Field | Type | Description |
|---|---|---|
| `title` | `string` | Display text and tooltip text — must match exactly (see design guide). |
| `url` | `string` | Route path passed to `<Link to={url}>`. |
| `icon` | `LucideIcon` | Outline icon for default state. The active state automatically switches to the filled variant via `isActive` prop. |
| `badge` | `ReactNode` | Rendered after the title. Only count badges are permitted (see design guide). |
| `permissions` | `PermissionGate` | Hides the item when the permission check fails. |
| `visible` | `boolean` | Runtime visibility escape hatch for conditions that cannot be expressed via `PermissionGate`. |

### NavSubGroup fields

| Field | Type | Description |
|---|---|---|
| `label` | `string` | Trigger text for the collapsible — also the tooltip in collapsed rail. |
| `icon` | `LucideIcon` | Required — the only identifier in the collapsed rail. |
| `defaultOpen` | `true \| false \| 'auto'` | `'auto'` (default) opens when any descendant is active. |
| `collapsible` | `boolean` | When `false`, renders a static label heading with items inline. |

---

## isActive — custom route matching

The default active-route matcher is an exact pathname match. Override it when your app uses trailing slashes, prefix-based matching, or dynamic segments.

```tsx
// Prefix-based — marks /suppliers and /suppliers/123 both as matching /suppliers
isActive: (url, pathname) => pathname.startsWith(url) && url !== '/',

// Normalised trailing-slash — treats /suppliers/ and /suppliers as equivalent
isActive: (url, pathname) => {
  const normalise = (p: string) => p.replace(/\/$/, '')
  return normalise(pathname) === normalise(url)
},
```

The function receives `(itemUrl, currentPathname)` and returns `boolean`. It is called for every nav item on every render.

---

## Collapse state — localStorage key

The sidebar collapse preference is stored in `localStorage` under the key `'sidebar:state'`. The value is `'true'` (expanded) or `'false'` (collapsed).

```tsx
// Read the stored state
const stored = localStorage.getItem('sidebar:state')
const isExpanded = stored === null ? true : stored === 'true'

// The shell reads and writes this automatically.
// Do not write to this key manually — use the SidebarTrigger component
// or the ShellSidebar toggle, which update the key and React state together.
```

The constant `SIDEBAR_COOKIE_NAME` in `@workspace/ui/sidebar` equals `'sidebar:state'`. Despite the name, the value is stored in `localStorage`, not a cookie.

---

## Header — page title and breadcrumbs

Use `useHeader` to set the page title and breadcrumb from within a page component. The `HeaderProvider` must wrap the shell.

```tsx
import { useHeader } from '@connected/shell-kit'
import { useEffect } from 'react'

// Top-level page — title only
function SuppliersPage() {
  const { setPageTitle, setBreadcrumbs } = useHeader()

  useEffect(() => {
    setPageTitle('Suppliers')
    setBreadcrumbs([])    // clear any breadcrumb from a previous page
  }, [])

  return <SupplierTable />
}

// Drill-down page — breadcrumb + title
function SupplierDetailPage({ supplierId }: { supplierId: string }) {
  const { supplier } = useSupplier(supplierId)
  const { setPageTitle, setBreadcrumbs } = useHeader()

  useEffect(() => {
    if (!supplier) return
    setPageTitle(supplier.name)
    setBreadcrumbs([
      { label: 'Suppliers', href: '/suppliers' },
    ])
  }, [supplier])

  return <SupplierDetail />
}
```

`setPageTitle` and `setBreadcrumbs` are stable (wrapped in `useCallback`) — safe to include in dependency arrays.

---

## Header actions — per-page controls

Slot 4 CTA and other page-level actions can also be passed via `setHeaderActions` when the action belongs in the page header area (rare — prefer Slot 4 placement; see ADR-021).

```tsx
const { setHeaderActions } = useHeader()

useEffect(() => {
  setHeaderActions(
    <Button onClick={openCreateDrawer}>Add supplier</Button>
  )
  return () => setHeaderActions(null)    // clean up on unmount
}, [])
```

Pass `null` to clear. Always clean up in the effect's return function.

---

## Deprecated patterns

| Pattern | Replace with |
|---|---|
| Primary action button in the page header / breadcrumb area | Button in Slot 4 (Filter / action bar) — ADR-021 |
| `router.back()` or `window.history.back()` for ← Back | `navigate({ to: '/explicit-route' })` — ADR-020 |
| Two `<Sidebar>` components side by side | `ShellSidebar` (Default) or `SubSidebar` (Settings) — one per layout |
| Hardcoded `data-active` or custom active class on nav items | `isActive` prop on `ShellSidebarConfig` |
| `localStorage.setItem('sidebar:state', ...)` in app code | `SidebarTrigger` / collapse toggle only — the sidebar manages its own state |

### Known migration debt

- `apps/schedule-manager-app/src/routes/index.lazy.tsx` — a list page that still populates `setHeaderActions` with its primary "+ Add schedule" button, the exact deprecated pattern above. Found 2026-07-10 while verifying the Slot 4 rework (see ADR-045, ADR-028, ADR-031). Supplier Manager and Audit Manager already use the correct pattern (primary + secondary cluster in `ApiDataTable.filterRowProps.leadingContent`); this instance has not been migrated.
