---
name: postgres
description: Use when writing or reviewing SQL, migrations, Eloquent/Drizzle queries, indexes, EXPLAIN plans, or when querying databases via the postgres MCP server. Covers the user's Postgres setups (Laravel Sail, docker-compose) and connection strings.
---

# PostgreSQL Conventions

The user's Postgres instances run in Docker (Laravel Sail / docker-compose),
exposed on localhost:5432. NixOS does not host a system Postgres.

## Connections (dev defaults)

- agenda_salud: `postgresql://postgres:postgres@localhost:5432/agenda_salud`
- danse-macabre: `postgresql://postgres:postgres@localhost:5432/danse_macabre`
- JEL: `postgresql://jel:jel@127.0.0.1:5432/laravel`

## Querying via the postgres MCP

A global `postgres` MCP server (crystaldba/postgres-mcp, Docker,
`--access-mode=unrestricted`) is configured in opencode. It reads the
`DATABASE_URI` env var — the global default is the placeholder
`postgresql://postgres:postgres@localhost:5432/postgres`. When a project
needs its real database, add an `opencode.json` in that project:

```json
{
  "mcp": {
    "postgres": {
      "environment": {
        "DATABASE_URI": "postgresql://postgres:postgres@localhost:5432/<db>"
      }
    }
  }
}
```

Use the MCP tools for schema inspection, EXPLAIN plans, and index tuning
rather than raw `psql` when inside opencode. `--access-mode=restricted`
(read-only) should be used for production connections.

## SQL conventions

- Identifiers: lowercase snake_case, plural table names.
- Primary keys `BIGINT`/`IDENTITY` or `UUID`; name FKs `snake_case_id` with
  real `REFERENCES ... ON DELETE` constraints.
- Add `EXPLAIN (ANALYZE, BUFFERS)` before optimizing; drive indexes from the
  plan, not from assumptions.
- Every query used by an ORM (Eloquent/Drizzle) should be checked for N+1 —
  eager load / `with` relations.
- Migrations are the source of truth for schema; don't hand-edit the DB.
- Never dump credentials, connection strings, or query output that contains
  PII into files or commits.

## Tooling

- `psql "$DATABASE_URI"` for ad-hoc checks.
- `pg_isready` to confirm a container is up; Sail service name is `pgsql`.
