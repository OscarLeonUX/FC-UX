# ADR-007 — React Hook Form + FieldWrapper + Controller is the canonical form pattern

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Foods Connected has multiple form implementations across apps. Some use React Hook Form with `Controller` + `FieldWrapper`. Others use native `useState` for each field, with ad-hoc validation logic and manual error display. A smaller set use Formik.

The divergence creates three problems:

1. **Inconsistent validation behaviour** — some forms validate on change, some on blur, some only on submit. The user experience differs across screens with no principled reason.
2. **Inconsistent error display** — some forms show errors via toast, some via inline `<p>` elements, some via `FieldWrapper` with `message` + `status`. Errors look different and are placed differently.
3. **Drift** — form fields added to state-based forms require new `useState` calls, new error state, and new validation logic. The maintenance cost compounds as fields are added.

`FieldWrapper` from `@workspace/ui` provides a standardised layout for label, help tooltip, instructions text, and validation message. It is form-library agnostic — it does not call into React Hook Form itself. `Controller` is the React Hook Form bridge for controlled inputs that don't expose a native `ref`.

## Decision

React Hook Form with `useForm`, `Controller`, and `FieldWrapper` is the canonical form pattern for all new forms in Foods Connected apps.

- `useForm` (or `useFormContext`) manages form state.
- `Controller` wraps any input that needs a controlled value (`Select`, `Combobox`, `DatePicker`, custom inputs).
- `FieldWrapper` wraps every field: it receives `message` and `status='danger'` from `fieldState.error` to display inline validation errors.
- Zod schemas via `zodResolver` provide the validation contract.

Existing `useState`-based forms and Formik forms do not need to be migrated immediately. When a form is touched for another reason (bug fix, new field, significant redesign), migrate it to the canonical pattern at the same time.

## Consequences

- New forms must use React Hook Form + Controller + FieldWrapper. No new `useState` per-field forms.
- Formik must not be introduced for new forms.
- `FieldWrapper` is mandatory for every form field — it is not optional even for fields with no current validation rule. Adding validation later requires only adding a Zod rule, not restructuring the JSX.
- The `disabled` prop on `FieldWrapper` applies visual-only opacity. Engineers must also disable the child input directly when the intent is to prevent interaction.
