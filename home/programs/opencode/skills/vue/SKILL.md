---
name: vue
description: Use when working on Vue code (single-file components, script setup, Composition API, TypeScript, volar/vue-tsc, shadcn-vue, PrimeVue). Applies inside Nuxt apps and standalone Vue components across the user's projects.
---

# Vue Conventions

Applies to any Vue 3 code across the user's projects (Nuxt apps, shadcn-vue
components in semantichelp, PrimeVue components in danse-macabre).

## Core rules

- Vue 3 + Composition API. Always `<script setup>`, never Options API in new code.
- One component per file; components PascalCase, props kebab/camel consistently.
- Use TypeScript where the project supports it (`defineProps<T>()`,
  `defineEmits<T>()`).
- Reactive state: `ref` for primitives, `reactive` for nested objects; derive
  values with `computed`, never mutate computed.
- Props are the contract: declare `required`/defaults explicitly.
- Emit events for child→parent; avoid prop drilling by extracting composables
  or using provide/inject for shared contextual state.
- Lifecycle: keep `onMounted` minimal; prefer watchers on explicit sources.

## Component libraries

- shadcn-vue (semantichelp): copy components into the project tree and
  customize; run `npx shadcn-vue@latest add <component>` from project root;
  uses Radix Vue + Tailwind.
- PrimeVue (danse-macabre): Aura theme; import from `primevue` modules,
  register components/plugins in the Nuxt/App setup.

## Typing & tooling

- LSP: opencode's built-in `vue` server (Volar / `@vue/language-server`)
  handles `.vue` files — keep `<script lang="ts">` typed so volar catches
  errors.
- `vue-tsc` / `npx vue-tsc --noEmit` for typechecking; `eslint` for lint.

## Testing

Vitest + `@vue/test-utils` for component behavior. Prefer testing props/emits
contracts over DOM details.
