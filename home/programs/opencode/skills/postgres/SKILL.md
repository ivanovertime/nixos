---
name: postgres
description: Use when writing or reviewing SQL, migrations, Eloquent/Drizzle queries, indexes, EXPLAIN plans, or when querying the user's Postgres databases. Covers the user's Postgres setups (Laravel Sail, docker-compose) and connection strings.
---

# PostgreSQL Conventions

The user's Postgres instances run in Docker (Laravel Sail / docker-compose),
exposed on localhost:5432. NixOS does not host a system Postgres.

## Connections (dev defaults)

- agenda_salud: `postgresql://postgres:postgres@localhost:5432/agenda_salud`
- danse-macabre: `postgresql://postgres:postgres@localhost:5432/danse_macabre`
- JEL: `postgresql://jel:jel@127.0.0.1:5432/laravel`

## Querying databases

No global postgres MCP is configured in opencode. Use `psql` directly for
schema inspection, EXPLAIN plans, and index tuning:

```sh
psql "$DATABASE_URI"
```

The instance currently on localhost:5432 — the
`postgres`/`postgres` placeholder role does not exist on it.

If a project needs MCP-based DB access, add a project-scoped `opencode.json`
pointing at the real database instead of the removed global default:

```json
{
  "mcp": {
    "postgres": {
      "type": "local",
      "command": [
        "docker", "run", "-i", "--rm", "--network", "host",
        "-e", "DATABASE_URI=postgresql://<user>@localhost:5432/<db>",
        "crystaldba/postgres-mcp",
        "--access-mode=restricted"
      ]
    }
  }
}
```

Use `--access-mode=restricted` (read-only) for anything beyond local dev.

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
