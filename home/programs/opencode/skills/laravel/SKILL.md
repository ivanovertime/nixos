---
name: laravel
description: Use when working on Laravel projects (backend API, Eloquent models, controllers, routes, migrations, tests, Livewire/Flux, Sail). Covers project conventions for the user's Laravel apps (agenda_salud, danse-macabre backend, JEL backend), including how to use the laravel MCP server and Artisan/Sail workflows.
---

# Laravel Conventions

Applies to the user's Laravel projects. Check the specific project's
`composer.json` and `AGENTS.md` (e.g. agenda_salud ships Laravel Boost
guidelines) for version pinning before assuming.

## Stack notes

- PHP 8.2–8.4, Laravel 12–13, Eloquent, Pest (agenda_salud) or PHPUnit.
- Postgres via Docker / Laravel Sail (`pgsql` service on localhost:5432).
- agenda_salud: Livewire 4 + Flux, Fortify, Tailwind 4. API is JSON-only in
  danse-macabre (no views).
- Dev DB defaults: agenda_salud `postgres:postgres@localhost:5432/agenda_salud`,
  danse-macabre `postgres:postgres@localhost:5432/danse_macabre`,
  JEL `jel:jel@127.0.0.1:5432/laravel`.

## Commands

- `./vendor/bin/sail up -d` / `./vendor/bin/sail artisan ...` — run inside Sail.
- `php artisan` — run directly when PHP is available (dev shell).
- `php artisan make:model Foo -m`, `php artisan make:controller FooController --api`.
- `php artisan route:list`, `php artisan migrate`, `php artisan db:seed`.
- Tests: `./vendor/bin/sail test` or `php artisan test`.
- Lint/format: `./vendor/bin/pint`.
- `php artisan mcp:run` — official Laravel MCP server; only available in a
  project that has `laravel/mcp` installed. Use it to inspect routes, models,
  and run tinker. If the laravel MCP server is configured globally, it spawns
  this command and only works when a session is opened at a Laravel root.

## Conventions

- Controllers are thin; business logic lives in services/actions or model
  scopes. Keep controllers RESTful, one action per method.
- Eloquent: define relationships, casts, fillable/guarded, and global scopes in
  the model. Prefer query scopes over inline `where` chains repeated in
  controllers.
- Migrations: table names snake_case plural; foreign keys `snake_case_id`;
  columns follow Laravel schema conventions. DB is Postgres — use
  `->foreignId(...)->constrained()`, `->index()`, and real FK constraints.
- Validation in FormRequest classes; authorization via Policies/Gates.
- API responses: JSON only, consistent shape `{ data, meta, errors }`.
- Use route model binding and `Route::apiResource` where possible.
- Never log secrets, env keys, or DB credentials.

## Tests

Write feature tests for endpoints (status, JSON shape, authz) and unit tests
for services. Use factories + fakers. Seeds over manual fixtures.
