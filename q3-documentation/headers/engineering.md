# Engineering Supplement — PageHeader, Dialog Header & Sheet Level

Companion to the header design guidelines. Covers implementation patterns for the three header components in the Foods Connected codebase. Read the design guidelines first; this document tells you how to build what they describe.

---

## PageHeader

### Collapsed state — controlled prop

`collapsed?: boolean` is a controlled prop. The component has no internal scroll awareness — it renders what it receives. The parent (app shell or page layout) is responsible for tracking scroll position and passing `collapsed={true}` when appropriate.

```tsx
import { PageHeader } from '@workspace/ui'

const [collapsed, setCollapsed] = useState(false)

// Drive via a scroll listener in the page layout or app shell
<PageHeader
  title="ACME Corporation"
  subtitle="Supplier account"
  collapsed={collapsed}
  navigationTabs={tabs}
/>
```

When `collapsed` is `true`: `breadcrumbs` and `navigationTabs` are hidden. All other slots persist (title, subtitle, backLink, selectors, actions, customActions, extraRightContent).

### Title loading skeleton

When `title` is undefined, the component renders `<Skeleton className='h-10 w-48'>` — 40 px tall, 192 px wide (`w-48` = 12 rem). Fixed width, not relative. Do not implement a custom loading state.

```tsx
<PageHeader
  title={isLoading ? undefined : supplier.name}
  subtitle="Supplier account"
/>
```

### Breadcrumb accessibility

```tsx
<nav role="navigation" aria-label="breadcrumb">
  <Button
    variant="ghost"
    aria-label="Back to Suppliers"  // Never just "Back"
    onClick={router.back}
  />
  {/* breadcrumb trail */}
</nav>
```

When the page title is async-loaded, add `aria-live="polite"` to the `<h1>` wrapper so screen readers announce the update.

---

## Dialog Header — ConfirmDialog

For standard destructive and confirmation dialogs, use `ConfirmDialog` rather than composing `Dialog` manually. It handles focus management, button variants, and the async spinner.

```tsx
import { ConfirmDialog } from '@workspace/ui'

<ConfirmDialog
  open={open}
  onOpenChange={setOpen}
  title="Delete Beverages?"
  description="14 products will move to Uncategorised. This action cannot be undone."
  confirmLabel="Delete"
  confirmVariant="destructive"
  onConfirm={handleDelete}
/>
```

`ConfirmDialog` focuses Cancel on open when `confirmVariant="destructive"`. For non-destructive confirmations, omit `confirmVariant` — it defaults to the primary style.

### Loading lockout — all three simultaneously

During an in-flight `onConfirm` call, all three lockouts apply automatically in `ConfirmDialog`:
- Cancel is disabled
- Confirm shows a spinner and is disabled
- Backdrop click is disabled

On `Modal`, manage this manually: set `primaryAction.loading={true}` and pass `preventClose` while loading.

---

## Sheet Level — Drawer header description prop

Provide `description` when the action needs contextual explanation the title alone does not give. Omit it when the title is self-sufficient.

```tsx
// With description — border-b suppressed, description acts as visual separator
<Drawer
  title="Edit allergen settings"
  description="Changes apply to all future production runs. Existing batch records are unaffected."
>

// Without description — border-b applied automatically
<Drawer title="Edit contact details">
```

The `border-b` is conditional on component internals (`padding === 'default'` AND no `description`). Do not manage it manually.

### Source-verified padding values (drawer.tsx)

| Area | Tailwind | Pixels |
|---|---|---|
| Header | `px-6 py-4` | 24 px horizontal, 16 px vertical |
| Content (default) | `p-6` | 24 px all sides |
| Content (compact) | `p-4` | 16 px all sides |
| Footer | `px-6 py-4` + `border-t` | 24 px horizontal, 16 px vertical |
