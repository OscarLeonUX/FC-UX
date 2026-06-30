# ADR-009 — Single component for create and edit of the same entity

**Status:** Accepted  
**Date:** 2026-06-28

## Context

Foods Connected has both patterns: some entities use a single drawer component for create and edit (discriminated by whether an existing record was passed in). Others have separate `CreateEntityDrawer` and `EditEntityDrawer` components.

The split-component pattern produces maintenance problems that compound as the codebase grows:

1. **Validation drift** — the Zod schema (or validation rules) on the create component diverges from the edit component. Fields added to one are forgotten on the other. Required fields change in one but not the other.
2. **Field behaviour drift** — default values, help text, and placeholder text diverge. The form looks and behaves differently for create and edit with no principled reason.
3. **Server error handling drift** — error messages shown on create differ from those shown on edit for the same API failures.

The shared-component approach has been validated in practice across supplier manager and admin screens. The `isEditing` discriminator is a boolean derived from whether an existing entity was passed in. It controls: the drawer title, the primary action label, field default values, and which API mutation is called on submit.

## Decision

Create and edit of the same entity must use a single drawer component, discriminated by the presence or absence of an existing entity.

The standard discriminator is:

```
const isEditing = entity !== undefined
```

or, when working with an ID rather than the full entity object:

```
const isEditing = !!entityId
```

When `isEditing` is false (create mode): the drawer title is the action label, fields are empty or at their defaults, and the submit handler calls the create mutation.

When `isEditing` is true (edit mode): the drawer title is the entity name, fields are pre-populated with current values, and the submit handler calls the update mutation.

## Consequences

- No new `CreateEntityDrawer` / `EditEntityDrawer` split components. When a new form drawer is needed for an entity that already has a create form, extend the existing component to handle the edit case.
- When an existing split-component pair is touched for another reason, evaluate merging them. If merging is disproportionate to the change in scope, create a ticket and continue — but document it.
- The discriminator is a boolean, not an enum. Do not introduce a `mode: 'create' | 'edit'` string — the `entity !== undefined` check is more typesafe and self-documenting.
- Read-only view state (before the user enters edit mode) is a separate concern and does not require a third mode. It is controlled by whether the footer has been switched to show the save action or the edit action.
