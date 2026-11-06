# AGENTS.md — NixOS config for Spica

Declarative NixOS + home-manager configuration. Every change goes through the
flake; nothing is hand-edited directly on the live system.

## Structure

- `hosts/spica/` — host identity, locale, module imports, hardware
- `modules/` — system-level NixOS modules; one concern per file. Top level holds
  non-service concerns (boot, networking, nix, packages, users) plus `desktop/`
  and `hardware/`; services live in `modules/services/` (audio, printing,
  docker, livebook, postgres, journald)
- `home/` — home-manager config (shell, editors, dev, gui, programs)
- `flake.nix` — inputs, outputs, overlays, formatter, checks. Shared package
  overrides (e.g. the `tela-circle-green` icon theme, COSMIC aliases) are
  defined once in the overlay here.

home-manager is bridged in as a NixOS module (`modules/users.nix`), so a single
rebuild applies both system and user config.

## Commands

- `nix fmt` — format all `*.nix` (runs `nixfmt` on git-tracked files)
- `nix fmt -- --check` — CI format check
- `nix flake check` — evaluate + build both `spica-system` and `spica-home`
- `nix update` — bump inputs, verify, and auto-revert `flake.lock` on failure
- `nix upgrade` — the gated rebuild: `nix flake check` first, then `sudo nixos-rebuild switch` (works from any cwd — `/etc/nixos` symlinks to this repo; `--flake .#spica` only resolves inside it). Pass-through: `nix upgrade --rollback`
- `sudo nixos-rebuild switch` — bare build + activate, no check (prefer `nix upgrade`)

## Dependency updates

- Update deps with `nix update` — it verifies and auto-reverts `flake.lock` on failure. Never leave the lock dirty by hand.
- A broken rev (e.g. a bad npmDepsHash on nixpkgs-unstable) gets reverted, not worked around.
- The pre-push hook blocks broken locks from reaching `trunk`; CI re-runs the same check on push.

## Conventions

- Format with `nix fmt` before finishing any change; run `nix flake check` to verify.
- COSMIC desktop packages come from `nixpkgs-unstable` (stable pins older
  releases). Add new cosmic packages to the auto-discovered set in `flake.nix`.
- Config files under `~/.config` that symlink into `/nix/store` are owned by
  home-manager — never edit them in place; change the Nix source and rebuild.
- Commit style: conventional commits with scopes, e.g. `feat(tools): add jq`,
  `chore(deps): update nixpkgs`, `fix(flake): override cosmic-applibrary alias`.
  Trunk-based: default branch is `trunk`.
- Prefer existing module files over new ones unless the concern is distinct.