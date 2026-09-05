---
name: postgres
description: Use when writing or reviewing SQL, migrations, Eloquent/Drizzle queries, indexes, EXPLAIN plans, or when querying the user's Postgres databases. Covers the user's NixOS-hosted Postgres service and connection strings.
---

# PostgreSQL Conventions

A system-level PostgreSQL 16 instance runs on NixOS (always on, starts on
boot). Configured in `modules/postgres.nix`.

## Connections (dev defaults)

- Default DB: `postgresql://dev:dev@localhost:5432/development`
- Create project DBs: `psql -U dev -c "CREATE DATABASE myproject;"`
- Connect to project DB: `psql "postgresql://dev:dev@localhost:5432/myproject"`

Existing project databases (create as needed):

- agenda_salud: `postgresql://dev:dev@localhost:5432/agenda_salud`
- JEL: `postgresql://dev:dev@localhost:5432/jel`

## Querying databases

A global `postgres` MCP server is configured in opencode (read-only,
connects to `development` by default). For project-specific databases,
override via a project-scoped `opencode.json`:

```json
{
  "mcp": {
    "postgres": {
      "type": "local",
      "command": [
        "npx", "-y", "@modelcontextprotocol/server-postgres",
        "postgresql://dev:dev@localhost:5432/<db>"
      ]
    }
  }
}
```

Use `psql` directly for ad-hoc checks, EXPLAIN plans, and index tuning:

```sh
psql "postgresql://dev:dev@localhost:5432/<database>"
```

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

- `psql "postgresql://dev:dev@localhost:5432/<db>"` for ad-hoc checks.
- `pg_isready` to confirm the service is up.
