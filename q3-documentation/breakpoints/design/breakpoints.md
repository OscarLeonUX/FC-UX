# Responsive Breakpoints & App Shell Behaviour

Foods Connected CUI is built for desktop-primary B2B use. This guide defines the eight breakpoints and specifies how the app shell sidebar behaves at each viewport range. Mobile and tablet states are defined here for future implementation — the current production system is desktop-only due to data density.

---

## The eight breakpoints

Foods Connected uses eight named breakpoints. They are min-width thresholds — a rule at `md` applies from 768px upward.

| Token | Min width | Typical device | Shell relevance |
|---|---|---|---|
| base | 0px | Very small phone | Sidebar hidden — top bar only |
| 2XS | 320px | Phone portrait | Sidebar hidden — Sheet drawer |
| XS | 480px | Phone landscape | Sidebar hidden — Sheet drawer |
| SM | 640px | Small tablet / large phone | Sidebar hidden — Sheet drawer |
| **MD ★** | **768px** | Tablet portrait | **Sidebar appears as icon rail — collapsed by default** |
| **LG ★** | **1024px** | Tablet landscape / laptop | **Full sidebar — expanded by default** |
| XL | 1280px | Desktop | Full sidebar — same behaviour as LG |
| 2XL | 1536px | Wide / ultrawide desktop | Full sidebar — content width behaviour pending (see open questions) |

★ MD and LG are the two thresholds that govern shell layout changes. All other breakpoints affect content layout only.

---

## The three sidebar states

The shell has three distinct states across the breakpoint range. MD and LG are the crossings that trigger state changes.

### Sidebar hidden — below MD (below 768px)

The sidebar is not present on screen. A hamburger trigger in the top bar opens navigation in a Sheet that overlays the full viewport. Content fills the full viewport width.

The Sheet always opens closed on mount — no state is persisted below MD.

### Icon rail — MD to LG (768px to 1023px)

A narrow icon rail sits at the left edge, visible at all times. Icons represent each navigation destination. Activating a collapsed group item opens a flyout to the right of the rail.

The icon rail is **collapsed by default** at MD. The user can expand it to full sidebar width, but that expansion is **not persisted** — on the next page load the icon rail returns to collapsed. This is intentional: persisting an expanded state at tablet would return users to a layout where the content column is at its narrowest.

When the icon rail is expanded at the narrowest tablet viewport (768px), the content column is at its minimum. All content — tables, forms, list views — must remain functional at this configuration. Test expanded-sidebar layouts at exactly 768px viewport width.

### Full sidebar — LG and above (1024px+)

The full sidebar is **expanded by default**. All navigation labels, group names, and sub-items are visible. The user can collapse it to the icon rail at any time.

Collapse preference **persists across sessions** — a user who collapses the sidebar will find it collapsed on their next visit, across all Foods Connected apps.

---

## Breakpoint transitions

B2B desktop users resize browser windows constantly — snapping to half-screen, opening DevTools, attaching a keyboard to a tablet. The sidebar responds automatically when the viewport crosses MD or LG during an active session. Specify these transitions explicitly so every screen handles them consistently.

| Crossing | Sidebar behaviour | Content behaviour |
|---|---|---|
| **LG → below LG** | Full sidebar snaps to icon rail. Persisted collapse state is not updated — if the user returns to LG width, the sidebar restores to its last LG state. | Content column expands. No layout shift beyond the sidebar change. |
| **Below LG → LG** | Icon rail expands to full sidebar — unless the persisted state records a user-collapsed preference, in which case the icon rail is preserved. Persisted state wins over the default. | Content column narrows as sidebar expands. Ensure no horizontal overflow at the narrowest configuration. |
| **MD → below MD** | Sidebar is replaced by the Sheet drawer. The icon rail disappears entirely. Persisted state is disregarded — Sheet is always closed on mount. | Content expands to full viewport width. Top bar with hamburger trigger becomes the primary navigation affordance. |
| **Below MD → MD or above** | Sheet drawer closes. Sidebar restores from persisted state: icon rail at MD, full sidebar at LG. If no persisted state exists, defaults apply. | Content adjusts to account for the restored sidebar width. |

---

## Focus management

**On collapse (breakpoint crossing or manual trigger):** If focus is inside a navigation item when the sidebar collapses, move it to the collapse trigger. Do not drop focus or leave it on a now-hidden element.

**On Sheet open:** Focus moves into the Sheet — to the first navigation item or the close button.

**On Sheet close:** Focus returns to the hamburger trigger, whether the Sheet closed by navigation selection, backdrop tap, or the close button.

The collapse trigger must reflect the current sidebar state via `aria-expanded`. Navigation items hidden in the collapsed rail must be removed from the accessibility tree.

---

## Dos & Don'ts

| | Do | Don't |
|---|---|---|
| **Sidebar threshold** | Use MD (768px) as the threshold for any persistent sidebar. Below MD the sidebar must be a Sheet — a persistent rail at 640px is too narrow and occludes content. | Show the full sidebar below LG. At MD the sidebar should start in icon rail mode — a full sidebar at this viewport leaves the content column at its minimum from the outset, with no room for the user to expand. |
| **Default state** | Default the sidebar to the icon rail at MD–LG. Tablet users have less horizontal space — starting collapsed gives content room to breathe. | Assume the sidebar is always visible. Below MD it is a Sheet and may be closed. Never position content relative to the sidebar using hardcoded values. |
| **Mobile navigation** | Keep the hamburger trigger visible in the top bar at all times below MD. It is the only way for mobile users to open navigation. | Build a custom navigation drawer for mobile. The Sheet is the prescribed mobile navigation container — replacing it breaks focus management, escape-to-close, and backdrop dismiss behaviour. |
| **Sheet dismiss** | Auto-close the Sheet when the user selects a navigation item. | Leave the Sheet open after navigation. It should dismiss as part of the navigation action, not require a separate close gesture. |

---

## Open design questions

These decisions are pending. The guide will be updated when design provides answers. Do not implement responses to these scenarios until the decisions are confirmed.

### OQ-1 — Content minimum fallback

When the sidebar is expanded at the narrowest tablet viewport, the content column is at its minimum width. Some features — wide comparison tables, document diff views, timeline layouts, multi-column data entry — may not be adaptable to this width.

**Questions for design to resolve:**
- Is a desktop-only gate an acceptable outcome for features that cannot adapt? If so, what does the blocked state look like (message, redirect, empty state)?
- Is there a standard fallback pattern — simplified or stacked alternative layout, contained horizontal scroll — for features that can partially adapt?
- Or is this left to each feature team to solve per case, with the constraint stated but the approach undecided?

### OQ-2 — Content width at 2XL and above

At 1536px and beyond, the guide has no constraint on how wide the content area can grow. Without a cap, text line length and table column stretch degrade at ultra-wide viewports — a common use case for B2B operations and procurement teams.

**Questions for design to resolve:**
- Does the shell apply a max-width to the content area at 2XL+? If so, what is the value?
- If the shell does not constrain it, should this guide establish a max-width that all pages must follow?
- What is the guidance for text-heavy content (line length) and table-heavy content (column stretch) at wide viewports?
