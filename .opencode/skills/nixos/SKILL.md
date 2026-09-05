---
name: nixos
description: Use when working on this NixOS configuration (~/Source/nixos): editing flakes, NixOS/home-manager modules, packages, or doing a rebuild. Covers the flake layout, verification workflow (nix fmt, nix flake check), and rebuild command. Trigger on any change to *.nix in this repo.
---

# NixOS Configuration Workflow

Everything is declarative and goes through the flake. Never hand-edit the live
system or `/etc` files — change a `.nix` source and rebuild.

## Layout

- `modules/` — system-level NixOS modules (boot, desktop, hardware, services, users, nix)
- `home/` — home-manager config, imported as a NixOS module via `modules/users.nix`
- `hosts/spica/` — host identity/machine config; the only host is `spica`
- `pkgs/`, `lib/` — package expressions and shared helpers
- `flake.nix` — inputs, outputs, formatter, checks

A single rebuild applies both system and user (home-manager) config.

## Before finishing any change

1. `nix fmt` — format the module (runs `nixfmt` on git-tracked `*.nix`)
2. `nix flake check` — evaluates and builds `spica-system` + `spica-home`; this
   is the same check CI runs, and it catches most evaluation errors early

## Rebuild

- Dry-run/build only: `nixos-rebuild build --flake .#spica`
- Activate: `sudo nixos-rebuild switch --flake .#spica` (may prompt password)
- Rollback if a switch breaks the system: `sudo nixos-rebuild switch --rollback`

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