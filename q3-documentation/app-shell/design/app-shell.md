# App Shell — Design Guidelines

The App Shell is the persistent frame present on every page in a Foods Connected application. It defines where the user is, what they can reach, and what they can do — without competing with the content area.

> **Dimension reference:** All dimension values in this guide are sourced from the live component. They are shown so engineers know what to expect. Do not modify dimension values in this document — update the component source first, then update this document to match.

---

## Shell structure

The shell is a two-column layout: a sidebar column and a content column.

```
┌─────────────────┬─────────────────────────────────────────┐
│                 │  Slot 1 — Page Header (48px)             │
│                 ├─────────────────────────────────────────┤
│    Sidebar      │  Slot 2 — Tabs strip (optional, 36px)   │
│    (256px)      ├─────────────────────────────────────────┤
│                 │  Slot 3 — Views bar (optional, 32px)    │
│                 ├─────────────────────────────────────────┤
│                 │  Slot 4 — Filter / action bar (optional) │
│                 ├─────────────────────────────────────────┤
│                 │  Slot 5 — Content (1fr, scrolls)        │
│                 ├─────────────────────────────────────────┤
│                 │  Slot 6 — Sticky Footer (optional, 44px) │
└─────────────────┴─────────────────────────────────────────┘
```

Content sub-zones stack in Slot order. **Gaps between slots are the page layout's responsibility — the shell does not inject spacing between slots.**

---

## Sidebar

### Zones

The sidebar is a flex column with three fixed zones.

| Zone | Contents |
|---|---|
| Header | App icon badge (32×32px), app name, collapse trigger |
| Content | Nav groups, scrollable |
| Footer | More group items, user account block |

**The sidebar header zone and footer zone are fixed.** Only the Content zone scrolls when nav items exceed the available height.

### App icon badge

The badge is **32×32px — do not reduce this value.** It anchors the icon rail proportions and keeps the collapse trigger visually aligned. If the logomark feels visually heavy, adjust the inner icon size, not the badge container.

Render the badge as a **home link** when the app has a dashboard or landing page — it gives users a reliable escape hatch back to the start of any flow. When there is no dashboard or landing page, render it as a **static element**. Do not link it to an arbitrary first nav item — a non-interactive badge is less confusing than one that appears purposeful but resolves to a page that is not a meaningful home.

### Active state

The active navigation item is distinguished by three signals applied simultaneously:

1. **Background tint** — a subtle white overlay lifts the active row
2. **Semibold label weight** — separates the active item from inactive peers
3. **Filled icon** — the icon switches from outline to filled variant

No accent bar is applied. There is no left-edge border or colour stripe. The three signals above are the full active treatment in both expanded and collapsed states.

### Icon states

Use **outline** icons for the default (inactive) state and **filled** icons for the active state. This convention applies in both expanded and collapsed sidebar states. Reversing it makes the active item look unselected.

### Collapsed state (icon rail)

When collapsed, the sidebar is **44px wide**. All labels are hidden. Icons and hover tooltips are the only means of identifying items.

| Element | Behaviour in collapsed state |
|---|---|
| Nav items | Icon only — tooltip is the accessible name |
| Expandable sub-groups | Open a floating dropdown to the right (not an inline accordion) |
| User account block | Opens the user menu — same content as expanded state |
| Settings sidebar | Never collapses — always full-width |

**Collapse state is a global user preference** and persists across app switches and page navigation.

---

## Sidebar dos and don'ts

### Navigation items

#### ✓ Expand the active nav group automatically on every page render
The active item must be visible on load — never require the user to manually open a collapsed group to see where they are. Failing this breaks spatial orientation on every page load.

#### ✓ Match the nav label to the page `<h1>` on top-level pages
Where the sidebar item is the direct parent of that page, the nav label and page heading must be the same string. On drill-downs and Settings sub-pages an exact match is not required — ← Back and the breadcrumb carry the location signal instead.

#### ✓ Give every nav item a distinct icon
In the collapsed rail, the icon is the only identifier. It must communicate the destination without a label.

#### ✓ Use outline icon for default state, filled icon for active state
Applies in both expanded and collapsed states. This is the CUI-wide icon convention — do not invert it.

#### ✓ Keep nav labels short enough not to truncate at 256px
Two words is the practical limit. If a destination needs more than two words, the page likely needs renaming — not the label lengthening.

#### ✓ Keep sub-item labels to 3 words maximum
The flyout in collapsed mode has constrained width. Labels beyond 3 words truncate unpredictably and slow scanning.

#### ✓ Ensure every expandable (parent) nav item has an icon
An icon-free expandable item is invisible in the collapsed rail and its flyout has no visual anchor.

#### ✓ Set a tooltip on every nav item
The tooltip is the accessible name for every navigation item regardless of sidebar state. Items without one are inaccessible in the collapsed rail.

#### ✓ Write tooltip text that matches the nav label exactly
Users collapse the rail and build a mental map from icon to label. A mismatched tooltip breaks that map.

#### ✗ Use verb-first nav labels
Labels like `"Manage Suppliers"` or `"View Stock"` describe actions, not destinations. Use nouns: `"Suppliers"`, `"Stock"`.

#### ✗ Create more than 7 primary nav items
Beyond 7, users stop scanning and start searching. Move infrequently accessed items to the More group before shipping.

#### ✗ Use the same icon on two consecutive nav items
Adjacent identical icons are indistinguishable in the collapsed rail.

#### ✗ Mix icon styles across the nav
Outline, filled, duo-tone, and differing stroke weights in the same sidebar create visual noise. The full sidebar must read as one coherent system.

#### ✗ Add a third level of nav nesting
Two levels is the cognitive limit for sidebar navigation. A third level forces users to hold too much hierarchy in memory.

#### ✗ Put filters, search, or action buttons in the sidebar
The sidebar is wayfinding only. Every control placed there competes with navigation.

> **Exception — count badges:** Count badges on nav items are permitted. They modify the destination label (e.g. unread count, pending items) and do not introduce a separate data element. All other data elements — status dots, progress indicators, metrics, coloured rings — are not permitted.

---

### More group

The More group sits in the sidebar footer zone, alongside the user account block. It is always visible — it does not scroll away when nav items overflow, because it lives in the fixed footer section below the scrollable Content zone.

#### ✓ Use the More group for utility links only
Help, Settings, App Switcher, Return to Classic App. Treat **5 items as the practical limit** — beyond this, items are unlikely to be discovered. (Formal cap defined in the component spec.)

#### ✓ Provide an alternative access route for critical More group items
If a workflow depends on Settings or App Switcher, an access route via the page header or a direct link must also exist.

#### ✗ Place primary workflow links in the More group
Primary workflows must live in the main nav where they are immediately discoverable.

---

### Collapsed state

#### ✓ Design and review both expanded and collapsed states before handoff
A nav item that looks fine expanded may become ambiguous or invisible in the rail. Check icon-only legibility before sign-off.

#### ✗ Assume the Settings sidebar can collapse
The Settings sidebar is always full-width. The ← Back label and section group labels require visible text. Never implement a collapsed Settings sidebar.

---

## Sidebar variants

### Default variant

Used for any standard data page — lists, tables, dashboards, forms.

- Collapse toggle always present
- User account block always visible
- More group always accessible in footer

#### ✓ Show the user account block on every Default page
Do not suppress it. Users need logout and account switching at all times.

---

### Settings variant

Used for every page in a settings flow — not just the entry point.

- **Non-collapsible** — no collapse trigger
- ← Back button at the top of the Content zone
- User account block always visible

#### ✓ Apply the Settings variant to every page in a settings flow
The ← Back button, section structure, and absent collapse toggle are the visual signals that tell the user they are in a distinct mode. Breaking consistency mid-flow is disorienting.

#### ✓ Wire ← Back in Settings to the section root, not the immediate parent
Settings navigation is two levels deep — section root (e.g. `Company Settings`) and sub-page (e.g. `Company Profile`). ← Back on a sub-page returns to the section root. ← Back on the section root exits Settings and returns to the Default sidebar.

#### ✓ Keep user account block visible in Settings
Users still need logout and account switching during configuration flows.

#### ✗ Mix Default and Settings variants within the same user flow
The sidebar variant is a mode signal — mixing variants mid-flow breaks the user's mental model.

#### ✗ Create Settings navigation deeper than 2 levels
At 3 levels, ← Back becomes ambiguous. The two-level Settings model (section → sub-page) only works cleanly at that depth.

#### ✗ Design a Settings sidebar with a collapse trigger
Settings is always full-width. ← Back and section group labels require visible text.

---

### Return to Classic App

Shown in the sidebar footer only, and only on apps with an active legacy version.

**Exit criterion:** remove once the legacy version is fully decommissioned and all users have migrated. Decision owner: Product team responsible for that migration track.

---

## ← Back button

#### ✓ Show ← Back on every drill-down and Settings page
Without exception. Wire it to an **explicit route target** — not browser history.

#### ✓ Ensure ← Back receives focus before Content zone items
When the sidebar gains focus, ← Back must come first in keyboard tab order — before any nav items in the Content zone.

#### ✓ Wire ← Back to the immediate parent — one level up in the breadcrumb path
- Two-level drill-down (list → detail): Back returns to the list
- Three-level drill-down (list → detail → sub-page): Back returns to the detail page, not the list
- Create-new forms: immediate parent is the list page the form was launched from

> **Settings exception:** Settings pages use a different model — see Settings variant above.

#### ✗ Wire ← Back to browser history
A user who arrives via deep link or bookmark may have no app history at all. Browser history sends them wherever they came from, which may be outside the app entirely.

---

## Content slot order

Slots appear in this fixed sequence. Enable only what the page needs — **never reorder slots.** The sequence maps to CSS grid rows; reordering breaks vertical alignment across every CUI page.

| Slot | Zone | Required | Min-height |
|---|---|---|---|
| 1 | Page Header | Always | 48px |
| 2 | Tabs strip | Optional | 36px |
| 3 | Views bar | Optional | 32px |
| 4 | Filter / action bar | Required when page has a CTA; otherwise optional | — |
| 5 | Content | Always | 1fr |
| 6 | Sticky Footer | Optional — one variant or omit | 44px |

---

## Slot 1 — Page Header

A single 48px bar always present at the top of the content area. Content within it varies by page type — the container height is fixed.

**Top-level pages** (reached directly from the sidebar): show the page title only.

**Drill-down pages, Settings sub-pages, create-new forms**: show a breadcrumb above the page title.

### Breadcrumb (drill-down and Settings only)

Required on all non-top-level pages.

- Format: `Parent section › Current page`
- Separator: `›`
- Intermediate levels render as navigation links; the last item (current page) renders as plain text with no link
- Maximum 3 levels — do not include the app name or top-level nav item
- Settings example: `Company Settings › Company Profile`

### Page Header dos and don'ts

#### ✓ Separate context from action
Put context in the Page Header (title, entity name, status badge, breadcrumb). Put actions in the Filter / action bar (Slot 4). These two zones must stay visually and functionally separate.

#### ✗ Put interactive controls in the Page Header
The Page Header communicates *where* the user is — not *what* to do. Buttons, CTAs, and filters in the header create layout inconsistency across pages.

#### ✗ Use the Page Header to indicate edit mode
Use the Sticky Footer (Save / Cancel) as the edit-mode indicator — not header styling or added controls.

---

## Slot 2 — Tabs strip

- Container height: 36px
- Range: **2–5 tabs**
- **Minimum 2 tabs** — a single tab is redundant and must be removed. Render the content directly without the tab strip.
- Beyond 5 tabs: the tab bar overflows at standard desktop widths — consolidate or add a "More" dropdown.

**Use Tabs when** the options show different categories of information about the same entity — where each tab could be bookmarked as a distinct destination, and removing one tab removes information the user cannot access any other way.

---

## Slot 3 — Views bar

- Pill toggles
- Range: **2–4 named views**
- **Minimum 2 views** — a single view pill is redundant. Render the content directly.
- Beyond 4 views: the pill group wraps. Use a dropdown instead.

**Use Views bar when** the options show the same dataset in a different visual format (e.g. Table, Card, Map, Calendar). Changing a view changes *how* data is presented — never *what* data is shown. Removing a view removes no information, only a presentation preference.

### Tabs vs Views bar — decision test

> Does changing this control change **what** is shown, or **how** it is displayed?

- **What changes → Tabs (Slot 2).** e.g. `Overview · Documents · Contacts · Orders`
- **How changes → Views bar (Slot 3).** e.g. `List · Grid · Map · Calendar`

If removing the option would cause information loss — use Tabs. If it only changes presentation — use Views bar.

### Coexistence rule

Tabs and Views bar can appear on the same page — Tabs above, Views bar below, in slot order. The Views bar must only switch display format within the active tab. Never use Views bar to switch content categories.

---

## Slot 4 — Filter / action bar

Filter controls in this bar are 32px in height.

- **CTA position:** left
- **Layout toggle position:** right — icon-only buttons that switch the content area between display formats (e.g. list / grid). Distinct from the Views bar: no label, no pill style.
- **Hard limit: 3 visible filter dropdowns.** A 4th overflows the layout at 1536px and pushes the layout toggle off-screen. This is a layout constraint, not a preference. Use a "More filters" overflow pattern for additional options.

**Required on every page whenever the page has a primary action (CTA)** — even when there are no filter dropdowns. A CTA-only bar (no filters) is a valid pattern; the slot exists to place the CTA in the correct position.

This holds regardless of Header–Parent vs Header–Child page variant — see [ADR-045](../adr/045-primary-cta-slot-4-universal.md). A Header–Child page with a primary action still renders a CTA-only Slot 4, even without filter controls; the CTA is never relocated to the Page Header's `actions[]` slot.

---

## Slot 5 — Content

Required on every page. Fills remaining height. Tables, forms, and cards render here.

---

## Slot 6 — Sticky Footer

Container height: 44px. Three variants — use one or none:

- **Save / Cancel** — for editing states
- **Table pagination** — for paginated data tables
- **Page pagination** — for paginated page sets

#### ✓ Omit the footer element entirely when unused
Do not render an empty 44px container. The slot only exists when one of the three variants applies.

#### ✓ Use Save / Cancel when both Save / Cancel and pagination apply
Save / Cancel wins. Never stack both in the same footer.
