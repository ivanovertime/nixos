# AGENTS.md — NixOS config for Spica

Declarative NixOS + home-manager configuration. Every change goes through the
flake; nothing is hand-edited directly on the live system.

## Structure

- `hosts/spica/` — host identity, locale, module imports, hardware
- `modules/` — system-level NixOS modules (boot, desktop, hardware, services, users, nix)
- `home/` — home-manager config (shell, editors, dev, gui, programs)
- `pkgs/` — custom package expressions
- `lib/` — shared helpers
- `flake.nix` — inputs, outputs, formatter, checks

home-manager is bridged in as a NixOS module (`modules/users.nix`), so a single
rebuild applies both system and user config.

## Commands

- `nix fmt` — format all `*.nix` (runs `nixfmt` on git-tracked files)
- `nix fmt -- --check` — CI format check
- `nix flake check` — evaluate + build both `spica-system` and `spica-home`
- `sudo nixos-rebuild switch --flake .#spica` — build and activate (may prompt password)

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