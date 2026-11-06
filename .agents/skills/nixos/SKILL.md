---
name: nixos
description: "Use when working on this NixOS configuration (~/Source/nixos): editing flakes, NixOS/home-manager modules, packages, or doing a rebuild. Covers the flake layout, verification workflow (nix fmt, nix flake check), and rebuild command. Trigger on any change to *.nix in this repo."
---

# NixOS Configuration Workflow

Everything is declarative and goes through the flake. Never hand-edit the live
system or `/etc` files — change a `.nix` source and rebuild.

## Layout

- `modules/` — system-level NixOS modules; one concern per file. Non-service
  concerns at the top level (boot, networking, nix, packages, users) and in
  `desktop/`, `hardware/`; services in `services/` (audio, printing, docker,
  livebook, postgres, journald)
- `home/` — home-manager config, imported as a NixOS module via `modules/users.nix`
- `hosts/spica/` — host identity/machine config; the only host is `spica`
- `flake.nix` — inputs, outputs, overlays, formatter, checks. Shared package
  overrides (e.g. `tela-circle-green` icon theme, COSMIC aliases) live in the
  overlay here, not in per-file imports.

A single rebuild applies both system and user (home-manager) config.

## Before finishing any change

1. `nix fmt` — format the module (runs `nixfmt` on git-tracked `*.nix`)
2. `nix flake check` — evaluates and builds `spica-system` + `spica-home`; this
   is the same check CI runs, and it catches most evaluation errors early

## Rebuild

- Update deps: `nix update` — bumps inputs, verifies with `nix flake check`, and reverts `flake.lock` automatically on failure.
- Activate with the gate: `nix upgrade` — runs `nix flake check` first, then `sudo nixos-rebuild switch` (works from any cwd; `/etc/nixos` symlinks to this repo, so the bare command is used — `--flake .#spica` only resolves inside it)
- Build only: `nixos-rebuild build`
- Rollback if a switch breaks the system: `nix upgrade --rollback`
- Never leave `flake.lock` dirty: a broken rev gets reverted, not worked around.

## Conventions

- COSMIC packages come from `nixpkgs-unstable`; add new cosmic packages to the
  auto-discovered set in `flake.nix` (`cosmicNames`).
- New packages/settings: prefer existing module files unless the concern is
  distinct.
- If adding a home-manager-managed config file under `~/.config`, declare it as
  `xdg.configFile` (or a program module option), never as a plain file the user
  edits in place — files symlinked into `/nix/store` must not be edited directly.
- Commit style: conventional commits with scopes (`feat(tools):`, `chore(deps):`,
  `fix(flake):`). Trunk-based dev on `trunk`.