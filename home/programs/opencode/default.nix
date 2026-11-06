# terminal-only; home-manager owns opencode.json and the global AGENTS.md
{ pkgs-unstable, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;

    settings = {
      # Go free tier as the cheap daily driver; Zen models via /models.
      model = "opencode-go/deepseek-v4.1-flash";
      lsp = false;
      autoupdate = false;

      # Orchestrator plans read-only and delegates to subagents. The child uses
      # its own permissions, so the builder can edit even though the parent cannot.
      agents = {
        orchestrator = {
          description = "Plans work and delegates implementation to builder subagents";
          mode = "primary";
          model = "opencode-go/deepseek-v4-pro#max";
          steps = 30;
          permissions = [
            {
              action = "edit";
              resource = "*";
              effect = "deny";
            }
            {
              action = "subagent";
              resource = "*";
              effect = "deny";
            }
            {
              action = "subagent";
              resource = "builder";
              effect = "allow";
            }
            {
              action = "subagent";
              resource = "explore";
              effect = "allow";
            }
          ];
        };

        builder = {
          description = "Implements one scoped task end to end, including tests";
          mode = "subagent";
          model = "opencode-go/deepseek-v4.1-flash#high";
          steps = 40;
        };
      };
    };

    context = ''
      # Global agent instructions

      Applies to every project. Project `AGENTS.md` files layer on top of this one.

      ## System management (NixOS)

      This machine is managed by Nix (NixOS + home-manager). Never hand-edit files
      under `~/.config` that are symlinked into `/nix/store` — home-manager owns
      them. Change the Nix source in `~/Source/nixos` and rebuild with
      `nix upgrade` (runs `nix flake check` before `sudo nixos-rebuild switch`;
      works from any cwd because `/etc/nixos` symlinks to the repo). Update deps
      with `nix update` — it verifies and auto-reverts `flake.lock` on failure;
      never leave `flake.lock` dirty by hand. Plain files in `~/.config` are free
      to edit directly.

      ## Environment (NixOS)

      Verified present:

      | | |
      |---|---|
      | `node` | v24.16.0 |
      | `npm` | 11.13.0 |
      | `corepack` | yes — use `corepack pnpm …` |
      | `npx` | yes |
      | `rg` `fd` `jq` | 15.2.0 / 10.5.0 / 1.8.2 |
      | `git` `gh` `docker` `nix` | yes |
      | `herdr` | yes (pane/agent orchestration) |

      **Not installed — do not call these directly.** They appear in past sessions
      and each attempt wasted a turn:

      `python3` `python` `php` `composer` `pnpm` `bun` `yarn` `wrangler` `tsc` `prettier`
      `sqlite3` `openssl` `xxd` `file` `dig` `nslookup` `make` `just` `home-manager`

      Substitutes:

      - **No Python.** Use `node -e '…'` or `node --input-type=module -e '…'`. Never `python3`.
      - **No bare `pnpm`.** Use `corepack pnpm …`.
      - **No bare `wrangler`/`tsc`/`prettier`.** They live in `node_modules/.bin/`. Use the package script, or `npx <tool>`, or `./node_modules/.bin/<tool>`.
      - **No PHP.** Backends run in Docker (`docker compose exec -T <svc> php …`).
      - **No `make`/`just`.** Scripts are in `package.json`.

      ## Working directory

      OpenCode starts in the directory it was launched from, which is the repository
      root in herdr panes. **Do not prefix commands with `cd`.**

      ```bash
      npm run typecheck 2>&1 | tail -3
      ```

      For another repo or subdirectory, use the tool's own flag instead of `cd`:
      `git -C path/to/repo status`, `npm --prefix path/to/pkg run build`.

      If you genuinely must change directory, do it in the same command and keep it to one hop.

      ## Commands

      Prefer package scripts — they inject `node_modules/.bin` into `PATH`, which is
      exactly why bare binary calls fail:

      ```bash
      npm run <script>            # or: corepack pnpm run <script>
      npm run                      # list available scripts when unsure
      ```

      Read `package.json` scripts before guessing a command. If a repo has no script
      for what you need, say so rather than inventing one.

      Long output is context you pay for on every later turn. Cap it:

      ```bash
      npm run check 2>&1 | tail -30
      rg -n "pattern" --max-count 20 -g '!node_modules'
      ```

      ## Git

      - Default branch is `trunk` in most repos (`develop` in `alvarezivan.net`,
        `backoffice-starter`, `backoffice-ui`). Confirm with `git branch --show-current`;
        do not assume.
      - Commit style is Conventional Commits with a descriptive clause:
        `feat(onboarding): step 3 — the ready card and the flag-gated domain card`
        Lowercase type, scope in parentheses when it helps, em dash before the explanation.
      - **Do not commit or push unless explicitly asked.** When asked, stage only the files
        relevant to the change.
      - Run `git status` and `git diff` before reporting a change as done.

      ## Style

      - Reply in the language the user wrote in. They switch between Spanish and English
        mid-conversation.
      - Be concise. State what changed and how you know it works; skip the narration.
      - Do not claim something works unless you ran it or read the output. Say
        "unverified" when it is.
      - Do not add unrequested features, refactors, or comments.
      - Prefer editing existing files over creating new ones.
    '';
  };
}
