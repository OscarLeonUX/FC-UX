# Workflow Patterns

Common surface sequences in Foods Connected. Each pattern names the trigger, the surfaces involved, and what happens at each step.

---

## Surface selection — decision matrix

| Situation | Surface | Notes |
|---|---|---|
| Content has independent identity | Page | URL is a consequence, not a reason |
| View or edit detail without leaving the page | Drawer | Standard depth: L1 |
| Edit detail that references the context of its parent | Drawer (L2) | From inside an L1 drawer |
| Go deeper than L2 | Dialog | Float above the stack — never a third drawer |
| Page must stay interactive | Sheet | No scrim, no focus trap |
| Permanent panel coupled to a grid (filters, columns) | SidebarShell | Shrinks the page; always accessible via toolbar toggle |
| Decision required before anything else | Dialog | Max 2 actions |
| Task needs full viewport but is contextually dependent | Full-screen Drawer | User returns to trigger on dismiss |
| Task needs full viewport and has independent identity | Page | — |
| Dismiss with dirty or required-context only | Drawer with scrim | Required-context: permanent scrim; dirty: scrim on first edit |

---

## P01 — View and edit a record

**Trigger:** User clicks a row in a list.

1. **List page** — user scans the table.
2. **L1 Drawer opens** — entity name in the title. Page scroll position preserved behind the scrim.
3. **Dirty state** — user edits a field. Drawer enters dirty state — Escape now opens an unsaved-changes Dialog instead of closing.
4. **Unsaved changes Dialog** — "Unsaved changes. Discard them?" Focus on "Keep editing" (safe). User must choose explicitly.
5. **Save** — primary action shows spinner; all inputs disabled. Cancel remains active.
6. **Drawer closes** — focus returns to the row that opened it. List scroll position unchanged.

---

## P02 — Bulk action with confirmation

**Trigger:** User multi-selects rows; bulk action bar appears.

1. **List page** — user multi-selects rows.
2. **Confirmation Dialog** — "Approve 12 documents?" Lists document titles or a count with date range. Primary: "Approve all". Cancel: "Cancel".
3. **Processing** — "Approve all" shows spinner. Cancel remains active.
4. **Outcome** — Dialog closes. List updates in place. Toast: "12 documents approved".

---

## P03 — Two-level review with child action

**Trigger:** User clicks an audit record in a list.

1. **Audit list page** — user locates the audit by supplier and date.
2. **L1 Drawer** — audit summary: score, sections, list of findings.
3. **L2 Drawer** — user clicks a finding. Finding detail and corrective action form. L1 dims to 35%.
4. **Dialog from L2** — "Reject finding?" Names the finding. Focus moves to Cancel. Primary: "Reject finding".
5. **Dialog resolves** — L2 submits the rejection. Finding status updates. L2 content updates in place — L2 does not close and reopen.
6. **L2 closes** — L1 updates the finding's status badge inline. User continues reviewing from L1.

---

## P04 — Multi-step full-screen flow

**Trigger:** User clicks "Import suppliers" in the page action bar.

1. **Full-screen Drawer opens** — gets its own URL (`/suppliers/import`). Step 1: upload CSV. Step 2: map columns. Step 3: preview and fix errors.
2. **Processing** — user confirms on Step 3. Drawer shows progress state — skeleton rows populating as records are processed.
3. **Outcome Dialog** — "Import complete. 847 suppliers added, 12 skipped." Primary: "View report". Or: "Done" to dismiss.

---

## P05 — Destructive action from a list

**Trigger:** User clicks "Delete" on a list row that shows the record name and at least one supporting attribute.

1. **Settings page** — product categories list. Each row shows category name + product count.
2. **Confirmation Dialog** — opens directly (no drawer needed — sufficient context is visible in the row). "Delete 'Ambient Grocery'? This will unassign it from 214 products. This cannot be undone." Focus moves to Cancel. Primary: "Delete category".
3. **Processing** — "Delete category" shows spinner. Cancel remains enabled.
4. **Outcome** — Dialog closes. Category removed from list. Toast: "Ambient Grocery deleted".

> **Note:** If the list row shows only the record name with no supporting attribute, open a Drawer first to surface context (status, count, consequences), then show the Dialog from the Drawer.

---

## P06 — Filter with a Sheet

**Trigger:** User clicks "Filters" in the page toolbar.

1. **List page** — user clicks the Filters button. An active filter count badge appears on the button when filters are applied.
2. **Sheet opens** — to the right. List resizes to make room (SidebarShell) or the sheet overlays (Side Sheet) — whichever pattern is in use. The user can interact with the list while the sheet is open.
3. **Filtering** — user sets Country = "UK", Category = "Dairy", Status = "Non-compliant". List updates immediately on each checkbox change — no Apply button.
4. **Sheet closes** — Escape or ✕. Active filters remain applied. Filter pills appear in the page chrome. Sheet closing does not clear filter state.
