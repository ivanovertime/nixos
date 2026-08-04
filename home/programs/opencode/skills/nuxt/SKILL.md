---
name: nuxt
description: Use when working on Nuxt projects (pages, components, composables, layouts, API routes, Nuxt config, SSR/SPA, drizzle, pnpm workspaces). Covers the user's Nuxt apps: alvarezivan.net (Nuxt Content), semantichelp (Nuxt + drizzle + shadcn-vue), yamaha-boy (Nuxt + pnpm workspace), danse-macabre frontend (Nuxt 4 SPA + PrimeVue).
---

# Nuxt Conventions

Applies to the user's Nuxt projects. Verify the actual Nuxt version from the
project's `package.json` / `nuxt.config.ts` before assuming APIs.

## Stack notes

- Nuxt 3–4, Vue 3 (`<script setup>`), Vite.
- danse-macabre frontend: Nuxt 4 SPA (`ssr: false`) + PrimeVue (Aura).
- semantichelp: Nuxt + drizzle + shadcn-vue components.
- alvarezivan.net: Nuxt Content (Markdown-driven).
- yamaha-boy: pnpm workspace monorepo.

## Structure

- `pages/` — file-based routing. Directory/page names become routes.
- `components/` — auto-imported by name (PascalCase).
- `composables/` — auto-imported; state shared via `useState` / Pinia.
- `layouts/` — default + named layouts via `definePageMeta({ layout })`.
- `server/api/` and `server/routes/` — Nitro server endpoints (only if not SPA-only).
- `assets/`, `public/`, `middleware/`, `plugins/`.

## Conventions

- Prefer `<script setup>`; no Options API unless the codebase uses it.
- Auto-imports are on: do not import components/composables explicitly.
- Data fetching: `useAsyncData`/`useFetch` in pages/components; keep fetch
  logic in composables for reuse. In an SPA (`ssr: false`) call APIs
  client-side.
- Types: derive from server payloads; keep `$fetch` responses typed.
- UI components via PrimeVue or shadcn-vue; don't hand-roll primitives that
  already exist in the project's component set.
- Nuxt config: routes, modules (`@nuxtjs/tailwindcss`, `@nuxt/content`,
  `@primevue/nuxt-module`, `drizzle-orm/nuxt`), `runtimeConfig` for env.
- pnpm workspace (yamaha-boy): run with `pnpm --filter <pkg> <cmd>`.

## Commands

- `npm run dev` / `npx nuxi dev`.
- `npx nuxi build`, `npx nuxi generate` (static), `npx nuxi typecheck`.
- `npm run lint` / `eslint .`.

## Testing

Component tests (`@vue/test-utils` + Vitest) for non-trivial components;
avoid testing auto-imported plumbing.
