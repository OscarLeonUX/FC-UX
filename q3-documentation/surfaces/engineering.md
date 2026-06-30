# Engineering Supplement — Pages, Drawers, Sheets & Dialogs

Companion to the design guidelines. Covers component selection, footer construction, and implementation patterns specific to the Foods Connected codebase. Read the design guidelines first; this document tells you how to build what they describe.

For PageHeader, Dialog Header, and Drawer header implementation notes, see [Headers engineering supplement](../headers/engineering.md).

---

## Component mapping

| Design concept | Component | Import |
|---|---|---|
| Destructive / confirmation dialog | `ConfirmDialog` | `@workspace/ui` |
| Form dialog, outcome dialog, small modal | `Modal` (size `sm`–`xl`) | `@workspace/ui` |
| Full-screen drawer | `Modal` (size `screen` or `full`) | `@workspace/ui` |
| Standard drawer | `Drawer` | `@workspace/ui` |
| Side sheet / overlay panel | `Sheet` | `@workspace/ui` |
| Inline collapsible sidebar (grid-coupled) | `SidebarShell` | `@connected/composed-kit` |
| Content viewer (2/3 + 1/3 layout) | `ViewerModal` | `@connected/composed-kit` |
| Page with table and filter sidebar | `ApiDataTablePageLayout` | `@connected/composed-kit` |

### Size reference — Modal

| Size | Max width | Use for |
|---|---|---|
| `sm` | 384 px | Compact confirmations |
| `md` | 448 px | Standard confirmations, small forms |
| `lg` | 576 px | Medium forms |
| `xl` | 672 px | Wide forms |
| `2xl` | 768 px | Large content |
| `full` | 100% viewport | Takeover dialogs |
| `screen` | 100% viewport − 8 px gap | Full-screen drawer (breathing room) |

### Size reference — Drawer

| Size | Width | Use for |
|---|---|---|
| `sm` | 384 px | Simple edit forms |
| `md` | 448 px | Standard detail/edit (default) |
| `lg` | 512 px | More complex forms |
| `xl` | 576 px | Wide forms |
| `2xl`–`4xl` | 672–896 px | Data-heavy detail views |
| `full` | 100% | Full-screen drawer |

---

## Destructive confirmation — use ConfirmDialog

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

`ConfirmDialog` focuses Cancel on open when `confirmVariant="destructive"`. For non-destructive confirmations, omit `confirmVariant` — it defaults to the primary style and focuses the confirm button.

---

## Drawer footer — raw ReactNode

`Drawer` takes `footer?: React.ReactNode` — there is no structured action API. Build the footer manually using `DialogFooter` and `Button`.

### Standard footer (primary + cancel)

```tsx
import { DialogFooter, Button } from '@workspace/ui'

<Drawer
  footer={
    <DialogFooter className="border-t px-6 py-3">
      <Button variant="secondary" onClick={onClose}>Cancel</Button>
      <Button onClick={handleSave} disabled={isSaving}>Save changes</Button>
    </DialogFooter>
  }
>
```

### Footer with overflow menu

When a drawer has multiple possible actions (approve, change status, delist), surface only primary + cancel as buttons. Put additional actions in a `DropdownMenu` adjacent to Cancel.

```tsx
import { DialogFooter, Button, DropdownMenu, DropdownMenuContent,
         DropdownMenuItem, DropdownMenuTrigger } from '@workspace/ui'
import { ChevronDown } from 'lucide-react'

<DialogFooter className="border-t px-6 py-3">
  <Button variant="secondary" onClick={onClose}>Cancel</Button>
  <Button onClick={() => handleSave()}>
    Save <ChevronDown className="h-4 w-4" />
  </Button>
  <DropdownMenuContent align="end">
    <DropdownMenuItem onClick={() => handleSave({ closeAfter: false })}>
      Save
    </DropdownMenuItem>
    <DropdownMenuItem onClick={() => handleSave({ closeAfter: true })}>
      Save & Exit
    </DropdownMenuItem>
  </DropdownMenuContent>
</DialogFooter>
```

### Footer with left-side destructive action

Place a destructive action (e.g. Delete) on the far left using `className="mr-auto"`.

```tsx
<DialogFooter className="border-t px-6 py-3">
  <Button variant="destructive" className="mr-auto" onClick={() => setDeleteOpen(true)}>
    Delete
  </Button>
  <Button variant="secondary" onClick={onClose}>Cancel</Button>
  <Button onClick={handleSave}>Save changes</Button>
</DialogFooter>
```

---

## Full-screen drawer — use Modal size='screen'

Full-screen drawers are implemented with `Modal`, not `Drawer`. Use `size="screen"` (100% viewport with 8 px gap) or `size="full"` (no gap).

`Modal` has a structured action API (`primaryAction`, `secondaryAction`, `tertiaryAction`) and a `renderFooter` escape hatch for custom layouts.

```tsx
import { Modal } from '@workspace/ui'

<Modal
  open={open}
  onOpenChange={onOpenChange}
  title="Import suppliers"
  size="screen"
  primaryAction={{ label: 'Confirm import', onClick: handleImport, loading: isImporting }}
  secondaryAction={{ label: 'Cancel', onClick: onClose }}
>
  {/* step content */}
</Modal>
```

For custom footer layouts (e.g. delete action far left), use `renderFooter`:

```tsx
<Modal
  size="screen"
  renderFooter={({ onClose }) => (
    <DialogFooter className="border-t px-6 py-2">
      <Button variant="destructive" className="mr-auto" onClick={() => setDeleteOpen(true)}>
        Delete
      </Button>
      <Button variant="secondary" onClick={onClose}>Cancel</Button>
      <Button onClick={handleSave}>Save</Button>
    </DialogFooter>
  )}
>
```

Pass `renderFooter={null}` to suppress the footer entirely.

---

## Multi-step drawer — Drawer + Stepper

Multi-step flows inside a drawer use `Drawer` + `Stepper` from `@workspace/ui`. `StepNavigation` is deprecated — use `Stepper` for all new work.

The footer changes per step:

- **Intermediate steps** — Back + Next.
- **Final step** — Back + Submit (or the specific action label).
- **Step 1** — no Back button.

```tsx
import { Drawer, Stepper } from '@workspace/ui'

<Drawer open={open} onOpenChange={onOpenChange} title="Share data" size="lg">
  <Stepper currentStep={step} steps={steps} />
  <div>{steps[step].content}</div>
  <footer>
    {step > 0 && <Button variant="secondary" onClick={() => setStep(s => s - 1)}>Back</Button>}
    {step < steps.length - 1
      ? <Button onClick={() => setStep(s => s + 1)}>Next</Button>
      : <Button onClick={handleSubmit}>Share</Button>
    }
  </footer>
</Drawer>
```

When a multi-step flow is large or complex enough that the user might navigate away mid-flow, use `Modal size="screen"` with `Stepper` instead of a standard `Drawer`.

---

## Dirty state — ConfirmDialog + isDirty

The standard dirty-state intercept uses a `ConfirmDialog` opened when the user attempts to close a drawer with unsaved changes.

```tsx
const [isDirty, setIsDirty] = useState(false)
const [discardOpen, setDiscardOpen] = useState(false)

const handleClose = () => {
  if (isDirty) {
    setDiscardOpen(true)
  } else {
    onClose()
  }
}

<Drawer open onOpenChange={open => !open && handleClose()} title="Edit supplier">
  {/* form */}
</Drawer>

<ConfirmDialog
  open={discardOpen}
  onOpenChange={setDiscardOpen}
  title="Unsaved changes"
  description="You have unsaved changes. Discard them?"
  confirmLabel="Discard changes"
  confirmVariant="destructive"
  cancelLabel="Keep editing"
  onConfirm={onClose}
/>
```

---

## Loading, error, and empty states inside drawers

There is no standardised wrapper — implement inline using the patterns below.

### Loading

```tsx
import { Loader2 } from 'lucide-react'

{isLoading && (
  <div className="flex flex-1 items-center justify-center p-8">
    <Loader2 className="animate-spin" />
  </div>
)}
```

### Error

```tsx
import { InlineAlert } from '@workspace/ui'

{isError && (
  <InlineAlert variant="destructive">
    Failed to load. Please close and try again.
  </InlineAlert>
)}
```

### Empty

```tsx
{!isLoading && !isError && items.length === 0 && (
  <p className="text-muted-foreground px-4 py-6 text-sm">No items found.</p>
)}
```

---

## ViewerModal — content viewer layout

`ViewerModal` from `composed-kit` implements the full-screen drawer content viewer layout (2/3 main content + 1/3 metadata side panel). Use it for document, image, and form-response viewing.

```tsx
import { ViewerModal } from '@connected/composed-kit'

<ViewerModal
  open={open}
  onOpenChange={onOpenChange}
  title={document.name}
  mainContent={<DocumentViewer src={document.url} />}
  sidePanel={<DocumentMetadata document={document} />}
/>
```

Do not use `Modal size="full"` and manually build the 2/3 + 1/3 layout — `ViewerModal` is the canonical implementation.

---

## SidebarShell — inline collapsible sidebar

`SidebarShell` from `composed-kit` is the layout primitive for panels that shrink the page. It is used by `FilterSidebar` and `ColumnSidebar` — use those composed components where possible rather than `SidebarShell` directly.

`SidebarShell` requires `open` / `onOpenChange` props and animates its width via CSS transition. It must live inside a `flex flex-row` parent so the adjacent content area shrinks naturally.

```tsx
import { SidebarShell } from '@connected/composed-kit'

<div className="flex flex-row flex-1 overflow-hidden">
  <div className="flex-1 min-w-0">
    {/* table or grid */}
  </div>
  <SidebarShell
    open={sidebarOpen}
    onOpenChange={setSidebarOpen}
    icon={<Filter />}
    title="Filters"
    searchValue={search}
    onSearchChange={setSearch}
  >
    {/* filter controls */}
  </SidebarShell>
</div>
```
