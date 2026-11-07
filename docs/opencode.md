# OpenCode integrations on Spica

Reference for the OpenCode agent setup managed by home-manager
(`home/programs/opencode/default.nix`). Covers web search, the GitHub MCP
server, and secret handling.

## Web search

- Provider: **TinyFish** — `websearch.provider = "tinyfish"`, works without an
  API key.
- The Console workspace (Bitmosfera) pushes `websearch.provider = "opencode"`
  (hosted OpenCode Web Search, $0.01/search, billed to the workspace). The
  hosted endpoint returned HTTP 503 on 2026-11-07, so the local explicit
  provider is the active fallback; local config wins over the workspace
  default while it is set.
- Switch back: set `websearch.provider` to `"opencode"` (or delete the block)
  once the Console side is working.

## GitHub MCP server

- Official remote server: `https://api.githubcopilot.com/mcp/` (default
  toolsets: context, repos, issues, pull_requests, users).
- GitHub's auth server does not support dynamic client registration, so
  OpenCode's OAuth flow fails ("Incompatible auth server: does not support
  dynamic client registration"). Auth is a classic PAT with
  `oauth = false` and `Authorization: Bearer {env:GITHUB_PERSONAL_ACCESS_TOKEN}`.
- The PAT lives in the OpenCode service environment, never in the store or
  the repo: `opencode service set env GITHUB_PERSONAL_ACCESS_TOKEN ghp_...`
  (classic PAT, scope `repo`).

## Secrets policy

- Rule: no secret in `.nix` files — the Nix store is world-readable.
- Current approach: per-tool secret stores (`opencode service set env`).
- Pending: sops-nix (age-encrypted, decrypted to `/run/secrets` at
  activation) for machine-level secrets. Not yet added.

## Verify

- `opencode mcp list` → `✓ github connected`
- `opencode service get` → env keys present (values are not printed)
- `opencode api get /api/config` → effective merged config
