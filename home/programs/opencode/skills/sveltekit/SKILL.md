---
name: sveltekit
description: Use when working on SvelteKit projects (routing, +page/+layout files, load functions, stores, forms, adapters, SSR/SSG, Tailwind/Skeleton UI). Covers the user's SvelteKit apps: applikt-svelte (SvelteKit 2 + Skeleton UI + Tailwind) and JEL frontend.
---

# SvelteKit Conventions

Applies to the user's SvelteKit projects. Check the project's
`package.json` / `svelte.config.js` for the exact versions.

## Stack notes

- SvelteKit 2, Svelte 4/5, Vite, TypeScript or JSDoc (`jsconfig.json`).
- applikt-svelte: Skeleton UI 2 + Tailwind 3, adapters (auto/netlify/static).
- JEL frontend: SvelteKit with `vite.config.ts`/`vite.config.embed.ts`.

## Structure

- `+page.svelte`, `+page.ts`, `+layout.svelte`, `+layout.ts` — file-based routing.
- `+page.server.ts` / `+layout.server.ts` — server load + mutations (SvelteKit 2: `load`, form actions in `+page.server.ts`).
- `+server.ts` — API endpoints.
- `$lib/` — shared code (alias, configured in `svelte.config.js`).

## Conventions

- Load data in `load` functions; keep pages presentational.
- Use `$props()` / `$state` (Svelte 5 runes) only if the project is on Svelte 5;
  applikt-svelte is Svelte 4 — use `export let`, `$:`, stores.
- Mutations: form actions + progressive enhancement over manual fetches.
- Styling: Tailwind + Skeleton UI primitives; don't duplicate components that
  Skeleton already provides.
- Prefer `$lib/` modules for shared types/utilities.
- Use SvelteKit adapters per deploy target (static for SSG, netlify for
  Netlify, auto elsewhere).

## Commands

- `npm run dev` / `npm run build` / `npm run preview`.
- `npm run check` — `svelte-kit sync && svelte-check`.
- `npm run lint` (prettier + eslint), `npm run format`.

## Testing

Vitest + `@testing-library/svelte` for non-trivial logic; keep component
tests focused on behavior, not markup.
