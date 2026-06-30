# Engineering Supplement — Forms

Companion to `design/forms.md`. Covers the canonical form pattern, FieldWrapper props, horizontal label layout, error handling, and the isEditing pattern.

---

## Component mapping — forms

| Design concept | Component | Import |
|---|---|---|
| Field wrapper (label + error + help) | `FieldWrapper` | `@workspace/ui` |
| Step indicator | `Stepper`, `StepperList`, `StepperItem`, `StepperTrigger`, `StepperIndicator`, `StepperSeparator`, `StepperContent` | `@workspace/ui` |
| Cross-field / server error alert | `InlineAlert` | `@workspace/ui` |
| Server success / server error notification | `useNotifications` | `@workspace/ui` |

---

## FieldWrapper — props reference

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `string` | — | Label text. Renders a `<Label>` with an asterisk if `required` is set. |
| `htmlFor` | `string` | — | Passed to the `<Label>` — must match the `id` of the child input. |
| `required` | `boolean` | `false` | Appends a red `*` to the label. Use in vertical layouts only (see ADR-010). |
| `help` | `string` | — | Tooltip text rendered as a `HelpCircle` icon adjacent to the label. Use for genuinely non-obvious fields. |
| `instructions` | `string` | — | Helper text rendered below the field, before the error message. Use for format hints or constraints (e.g. "Max 100 characters"). |
| `message` | `string` | — | Validation message text. Displayed below the field. Style is controlled by `messageStatus` or inferred from `status`. |
| `messageStatus` | `'danger' \| 'warning' \| 'info'` | inferred | Overrides the status inferred from `status` for the message display only. |
| `status` | `'danger' \| 'warning'` | — | Changes the label colour and message style. Pass `'danger'` for errors. |
| `disabled` | `boolean` | `false` | Applies `opacity-50` visually. Does **not** add `pointer-events-none`. You must also disable the child input. |
| `size` | `'default' \| 'compact'` | `'default'` | `'compact'` reduces the gap between label and input from `gap-3` to `gap-1`. Use in dense settings-style forms. |

### Standard field pattern (React Hook Form)

```tsx
import { FieldWrapper, Input } from '@workspace/ui'
import { Controller, useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
})

function SupplierForm() {
  const { control, handleSubmit } = useForm({
    resolver: zodResolver(schema),
    defaultValues: { name: '' },
  })

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <Controller
        control={control}
        name='name'
        render={({ field, fieldState: { error } }) => (
          <FieldWrapper
            label='Supplier name'
            htmlFor='name'
            required
            message={error?.message}
            status={error ? 'danger' : undefined}
          >
            <Input id='name' {...field} />
          </FieldWrapper>
        )}
      />
    </form>
  )
}
```

---

## Form ID pattern — submit from drawer footer

When the form and its submit button are in different DOM trees (form in drawer body, button in drawer footer), use the `form` attribute to link them.

```tsx
<Drawer
  footer={
    <DialogFooter className="border-t px-6 py-3">
      <Button variant="secondary" onClick={onClose}>Cancel</Button>
      <Button type="submit" form="supplier-form" disabled={isSaving}>
        {isSaving ? 'Saving...' : 'Create supplier'}
      </Button>
    </DialogFooter>
  }
>
  <form id="supplier-form" onSubmit={handleSubmit(onSubmit)} className="p-6 flex flex-col gap-4">
    {/* fields */}
  </form>
</Drawer>
```

The `<Button type="submit" form="supplier-form">` submits the form regardless of where it is in the DOM. The `id` must be unique per page.

---

## Horizontal label layout — 2xl:w-55 standard

For settings-style forms with labels beside fields at wide breakpoints. The label column is `2xl:w-55` (220px) fixed-width; the field column fills the rest.

```tsx
<fieldset className="flex flex-col gap-4 2xl:flex-row 2xl:items-center 2xl:gap-8">
  <div className="w-full 2xl:w-55 2xl:shrink-0">
    <Label htmlFor="relationship-id">
      WSI
      {isRequired && <span className="text-destructive"> *</span>}
    </Label>
  </div>
  <div className="w-full min-w-0 2xl:flex-1">
    <Controller
      control={control}
      name="relationshipId"
      render={({ field, fieldState: { error } }) => (
        <FieldWrapper
          htmlFor="relationship-id"
          message={error?.message}
          status={error ? 'danger' : undefined}
        >
          <Input id="relationship-id" {...field} />
        </FieldWrapper>
      )}
    />
  </div>
</fieldset>
```

Do not pass `label` or `required` to `FieldWrapper` in horizontal layouts — the label lives in the left column and `required` would render the asterisk in the wrong place (see ADR-010).

The `2xl:w-55` class is Tailwind v4 using the `w-55` scale value (220px). Legacy code may use `w-[200px]` — standardise to `2xl:w-55` on touch.

---

## Server error patterns

### Toast for unambiguous server failures

```tsx
import { useNotifications } from '@workspace/ui'

const { raiseNotification } = useNotifications()

async function onSubmit(values: FormValues) {
  try {
    await createSupplier(values)
    raiseNotification({ categoryId: 'supplier-created', title: 'Supplier created', kind: 'success' })
    onClose()
  } catch (error) {
    if (isConnectedApiRequestError(error) && error.status === 409) {
      // Map server field error back to the form
      form.setError('name', { message: 'A supplier with this name already exists' })
    } else {
      raiseNotification({ categoryId: 'supplier-error', title: 'Failed to save supplier. Please try again.', kind: 'error' })
    }
  }
}
```

### InlineAlert for cross-field errors

Place above the form body (after the form heading, before the first field):

```tsx
import { InlineAlert } from '@workspace/ui'

{crossFieldError && (
  <InlineAlert variant="destructive" className="mb-4">
    {crossFieldError}
  </InlineAlert>
)}
```

---

## isEditing — create vs edit in one component

The canonical discriminator is whether an existing entity was passed in:

```tsx
interface SupplierDrawerProps {
  supplier?: SupplierResponse  // undefined → create; defined → edit
  onClose: () => void
}

function SupplierDrawer({ supplier, onClose }: SupplierDrawerProps) {
  const isEditing = supplier !== undefined

  const form = useForm({
    resolver: zodResolver(schema),
    defaultValues: {
      name: supplier?.name ?? '',
      categoryId: supplier?.categoryId ?? '',
    },
  })

  async function onSubmit(values: FormValues) {
    if (isEditing) {
      await updateSupplier(supplier.id, values)
    } else {
      await createSupplier(values)
    }
    onClose()
  }

  return (
    <Drawer
      title={isEditing ? supplier.name : 'New supplier'}
      footer={
        <DialogFooter className="border-t px-6 py-3">
          <Button variant="secondary" onClick={onClose}>Cancel</Button>
          <Button type="submit" form="supplier-form">
            {isEditing ? 'Save changes' : 'Create supplier'}
          </Button>
        </DialogFooter>
      }
    >
      <form id="supplier-form" onSubmit={form.handleSubmit(onSubmit)}>
        {/* fields */}
      </form>
    </Drawer>
  )
}
```

When working with an ID rather than the full entity object (e.g. the entity is loaded inside the component): use `const isEditing = !!entityId`.

---

## Stepper — multi-step forms

`Stepper` is a compound component composed from `StepperList`, `StepperItem`, `StepperTrigger`, `StepperIndicator`, `StepperSeparator`, and `StepperContent`. All exported from `@workspace/ui`.

```tsx
import {
  Stepper,
  StepperContent,
  StepperIndicator,
  StepperItem,
  StepperList,
  StepperSeparator,
  StepperTitle,
  StepperTrigger,
} from '@workspace/ui'

const STEPS = [
  { value: 'details', label: 'Supplier details' },
  { value: 'contacts', label: 'Contacts' },
  { value: 'review', label: 'Review' },
]

<Stepper value={currentStep} onValueChange={setCurrentStep} nonInteractive>
  <StepperList>
    {STEPS.map((step, index) => (
      <StepperItem key={step.value} value={step.value}>
        <StepperTrigger>
          <StepperIndicator />
          <StepperTitle>{step.label}</StepperTitle>
        </StepperTrigger>
        {index < STEPS.length - 1 && <StepperSeparator />}
      </StepperItem>
    ))}
  </StepperList>

  {STEPS.map(step => (
    <StepperContent key={step.value} value={step.value}>
      {/* step content */}
    </StepperContent>
  ))}
</Stepper>
```

Use `nonInteractive` when step navigation is controlled by the Back/Next footer buttons only. Omit it when the user should be able to click back to a completed step.

`StepNavigation` is deprecated — do not use it for new work. Migrate on touch.

---

## FieldWrapper size='compact'

Use `size='compact'` for dense, settings-style forms where reducing the gap between label and input is appropriate. It sets `gap-1` instead of `gap-3`.

```tsx
<FieldWrapper label="Timeout (seconds)" size="compact" htmlFor="timeout">
  <Input id="timeout" type="number" />
</FieldWrapper>
```

Do not use `compact` in standard create/edit Drawer forms — the default spacing is intentional for comfortable data entry.

---

## Deprecated patterns

| Pattern | Replacement |
|---|---|
| `StepNavigation` | `Stepper` from `@workspace/ui` |
| `useState` per field with manual validation | React Hook Form + `Controller` + Zod |
| Manual asterisk span inside a vertical FieldWrapper | `required` prop on `FieldWrapper` |
| Toast for field-level validation errors | `FieldWrapper` `message` + `status='danger'` |
| Separate Create/Edit components for the same entity | Single component with `isEditing` discriminator |
| `w-[200px]` for horizontal label column | `2xl:w-55` |
