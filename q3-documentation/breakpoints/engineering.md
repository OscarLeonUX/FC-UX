# Engineering Supplement — Responsive Breakpoints

Companion to the breakpoints design guidelines. Covers breakpoint detection, the localStorage persistence mechanism, responsive CSS patterns, and the three sidebar state implementations.

---

## Breakpoint tokens — Tailwind prefixes

| Token | Min width | Tailwind prefix |
|---|---|---|
| 2XS | 320px | `2xs:` |
| XS | 480px | `xs:` |
| SM | 640px | `sm:` |
| MD | 768px | `md:` |
| LG | 1024px | `lg:` |
| XL | 1280px | `xl:` |
| 2XL | 1536px | `2xl:` |

Do not hardcode pixel values in component logic or CSS. Use the Tailwind screen tokens so changes to the design-system breakpoints propagate automatically.

---

## Breakpoint detection in JS

The shell derives its mobile/desktop split from a `useIsMobile` hook set at the MD threshold (768px). Below this threshold the sidebar renders as a `Sheet`; above it as a persistent sidebar.

```tsx
import { useIsMobile } from '@workspace/ui'

const isMobile = useIsMobile()  // true below 768px
```

For custom responsive logic outside the shell, use `useMediaQuery` with the Tailwind screen values:

```tsx
import { useMediaQuery } from '@workspace/ui'

const isTablet  = useMediaQuery('(min-width: 768px) and (max-width: 1023px)')
const isDesktop = useMediaQuery('(min-width: 1024px)')
```

---

## Collapse state — localStorage

The sidebar collapse preference is stored in `localStorage` under the key `'sidebar:state'`. The value is `'true'` (expanded) or `'false'` (collapsed).

```tsx
// The shell manages reads and writes automatically.
// Only access directly when you need to initialise state outside the shell.
const stored = localStorage.getItem('sidebar:state')
const isExpanded = stored === null ? true : stored === 'true'
```

**Key facts:**
- The key is **shared across all apps on the same origin**. A preference set in Supplier Manager applies in Compliance Manager. This is intentional — the collapse preference is global.
- The constant is exported as `SIDEBAR_COOKIE_NAME` from `@workspace/ui` — the name is misleading; it writes to `localStorage`, not `document.cookie`.
- Do **not** write to this key manually in app code. The shell manages state via `useSidebar` internally. Direct writes bypass React state and cause the UI and storage to fall out of sync.

---

## Responsive CSS patterns

Use the MD and LG Tailwind prefixes to switch sidebar visibility and content offset:

```tsx
{/* Sidebar — hidden below MD */}
<div className="hidden md:block">
  <ShellSidebar config={sidebarConfig} />
</div>

{/* Hamburger trigger — visible below MD only */}
<button className="block md:hidden" onClick={openMobileNav}>
  <Menu className="h-5 w-5" />
</button>

{/* Content area — full width below MD, offset by sidebar above MD */}
<main className="w-full">
  {/* The shell layout handles the sidebar offset via CSS grid/flex — 
      do not use ml-[var(--sidebar-width)] manually; it creates double-offset bugs */}
  {children}
</main>
```

Use the CSS custom properties `var(--sidebar-width)` and `var(--sidebar-width-icon)` — set by the shell on the root element — wherever you need to reference the sidebar's current width in CSS. These update automatically when the sidebar expands or collapses.

```css
.my-sticky-element {
  left: var(--sidebar-width);  /* always correct, regardless of sidebar state */
}
```

---

## Transition behaviour

The sidebar does not animate on breakpoint crossing — the layout snaps immediately. CSS width transitions are active only for user-triggered collapse/expand (clicking the trigger). This prevents an animated flash when the user resizes the browser window.

The shell suppresses the transition on mount and on breakpoint change automatically. If you build a custom sidebar wrapper outside the shell, apply `transition-none` during viewport changes using a `data-transitioning` flag or a `useLayoutEffect`-based class toggle.

---

## Expansion non-persistence at tablet

At MD–LG the sidebar's expansion state is deliberately **not persisted**. If a user expands the sidebar at tablet and refreshes, the icon rail restores.

This is intentional — persisting the expanded state at tablet would return users to a layout where the content column is at its narrowest, with no indication of why. The icon rail default at MD always gives users a usable content area on load.

Do not add persistence for the tablet-expanded state. If this decision changes, it will be reflected in an ADR update.

---

## Deprecated patterns

| Pattern | Replace with |
|---|---|
| Hardcoded sidebar pixel values in layout CSS | `var(--sidebar-width)` / `var(--sidebar-width-icon)` |
| `document.cookie` for collapse state | `localStorage.getItem('sidebar:state')` — or let the shell manage it |
| Custom breakpoint pixel values in JS | `useMediaQuery` with Tailwind screen token values |
| Manual `margin-left` offset for content area | Shell layout grid — do not offset manually |
| Custom mobile navigation drawer | Shell's built-in Sheet — replacing it breaks focus and dismiss behaviour |
