# ADR-008 — Inline errors for validation; toast only for server errors

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Form error reporting is inconsistent across Foods Connected apps. Three patterns are in use:

1. **Inline FieldWrapper errors** — `message` + `status='danger'` on the FieldWrapper, displayed directly below the field.
2. **Inline alert above the form** — an `InlineAlert` with `variant='destructive'` placed at the top of the form content area, for errors affecting the whole form or multiple fields.
3. **Toast notifications** — used in some forms for both server errors and field-level validation failures.

Using toast for validation errors creates two problems. First, toast is positioned in the corner of the screen and disappears after a few seconds — it is not appropriate for an error the user must act on before the form can be submitted. Second, it disconnects the error from the field it relates to, requiring the user to search the form to understand what needs fixing.

## Decision

Error reporting is tiered by origin and specificity:

- **Field-level errors** (required field missing, value does not match expected format, value out of range): show inline via `FieldWrapper` `message` + `status='danger'`, directly below the affected field. Trigger after blur or after first submission attempt.
- **Cross-field errors** (duplicate name, conflicting date ranges, value combination not allowed by business rules): show via `InlineAlert` with `variant='destructive'` placed above the form body or directly above the affected section. Trigger after submission attempt.
- **Server errors** (save failed, permissions, network timeout): show via toast. The form data itself is valid — the failure is external to the form.

Toast must not be used to report field-level validation errors. It must not be used to block form submission.

If the server returns field-specific validation errors (e.g. a duplicate-name 400 response), these errors must be mapped back to `FieldWrapper` inline messages on the affected fields, not displayed as toast.

## Consequences

- Engineers building forms must not reach for `useNotifications` to report field-level errors. Field errors go to FieldWrapper.
- Cross-field business rule errors belong in an `InlineAlert` above the form, not in a toast.
- Toast is only appropriate when: the user has submitted a valid form, the server has returned an error, and the form data cannot be the cause of the problem.
- When a server 400 response includes field-level detail, the error must be surfaced inline (via `setError` in React Hook Form) before considering whether toast is also appropriate.
