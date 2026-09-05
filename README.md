# NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-system-blue.svg?style=for-the-badge&logo=NixOS&logoColor=white)](https://nixos.org/)
[![Reproducible Code](https://img.shields.io/badge/Reproducible-Yes-success.svg?style=for-the-badge)](#)
[![Declarative](https://img.shields.io/badge/Infrastructure_as_Code-Yes-orange.svg?style=for-the-badge)](#)
[![CI](https://github.com/ivanovertime/nixos/actions/workflows/ci.yml/badge.svg)](https://github.com/ivanovertime/nixos/actions/workflows/ci.yml)

This is my NixOS system configuration. It defines everything about my computer — packages, services, desktop environment, boot settings — in code. I use it so I can rebuild my setup from scratch, or recover from a bad update, without losing a whole weekend.

The setup runs COSMIC desktop on AMD hardware, with home-manager handling user-level config.

---

## Why NixOS?

- **Declarative configuration:** Every part of the system is described in `.nix` files. No hidden state, no "how did that get installed?" moments.
- **Reproducibility:** The same config produces the same system on any machine. Setting up a new laptop takes minutes instead of hours.
- **Rollbacks:** If an update breaks something, boot into the previous generation and carry on. It's saved me more than once.
- **Isolated dev environments:** Each project gets its own dependencies via `nix develop`, so nothing bleeds into the host system.

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yml                 # Format + build checks on push/PR
├── .editorconfig                  # Editor style rules
├── .envrc                         # `use flake` — auto-loads devShell via direnv
├── flake.nix                      # Entry point — inputs, outputs, checks
├── flake.lock                     # Pinned dependency versions
├── lib/
│   └── icons.nix                  # Shared icon-theme override (system + home)
├── hosts/
│   └── spica/
│       ├── default.nix            # Host identity, locale, module imports
│       └── hardware.nix           # Machine-specific hardware (auto-generated)
├── modules/
│   ├── boot.nix                   # Boot loader, kernel params, zram swap
│   ├── desktop/
│   │   ├── cosmic.nix             # COSMIC DE, greeter, portals, env vars
│   │   └── fonts.nix              # Font packages & fontconfig
│   ├── hardware/
│   │   └── amd.nix                # AMD GPU, firmware, microcode
│   ├── networking.nix             # NetworkManager, Bluetooth
│   ├── nix.nix                    # Flakes, GC, optimise, auto-upgrade
│   ├── packages.nix               # System-wide GUI packages
│   ├── services.nix               # PipeWire, printing, fwupd, Docker
│   └── users.nix                  # User accounts, groups, home-manager bridge
├── home/
│   ├── default.nix                # Home-manager entry, imports, git, starship
│   ├── shell/
│   │   ├── bash.nix               # Bash config & aliases
│   │   ├── tmux.nix               # tmux config
│   │   └── tools.nix              # eza, yazi
│   ├── editors/
│   │   ├── helix.nix              # Helix editor & language servers
│   │   └── vscodium.nix           # VSCodium & extensions
│   ├── dev/
│   │   ├── tools.nix              # CLI dev tools (fd, ripgrep, gh, curl, ...)
│   │   ├── nix.nix                # Nix tooling (nil, nixfmt)
│   │   └── languages.nix          # Language/dev apps (bruno, aspell)
│   ├── gui/
│   │   ├── ides.nix               # GUI IDEs (Antigravity, VS Code, Copilot deps)
│   │   └── media.nix              # GUI media (qbittorrent, subliminal)
│   ├── desktop/
│   │   ├── clipboard.nix          # Cursor Clip clipboard daemon
│   │   ├── gtk.nix                # GTK theme, cursor, dconf
│   │   ├── icons.nix              # COSMIC icon aliases for Tela theme
│   │   └── mime.nix               # MIME default applications
│   └── programs/
│       ├── celluloid/
│       │   ├── default.nix        # Celluloid/mpv scripts & keybinds
│       │   ├── autosub.lua
│       │   └── input.conf
│       └── opencode/
│           ├── default.nix        # opencode config, MCP servers
│           └── skills/
│               └── lazy-senior-dev/
│                   └── SKILL.md
└── README.md
```

---

## Usage

This config is tailored to my machine and workflow. Feel free to use it as a starting point, but you'll need to adapt it to your own hardware.

**1. Clone the repository:**
```bash
git clone <your-repo-url> ~/Source/nixos
cd ~/Source/nixos
```

**2. Generate your hardware configuration:**
```bash
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware.nix
```

**3. Build and apply:**
```bash
sudo nixos-rebuild switch --flake .#spica
```

## Updating

```bash
nix flake update
sudo nixos-rebuild switch --flake .#spica
```

## Automatic Maintenance

The system handles its own upkeep:

- Weekly system upgrades via the flake (from the GitHub remote, so they work no matter where the checkout lives)
- Weekly garbage collection (removes store paths older than 30 days)
- Automatic store optimisation (deduplication)
- Boot menu limited to the latest 10 generations

Reboot is not automatic — new generations apply on next reboot, or you can rebuild manually.

### Check Timers

```bash
systemctl list-timers --all | grep -E 'nixos-upgrade|nix-gc|nix-optimise'
systemctl status nixos-upgrade.timer nix-gc.timer nix-optimise.timer
```

### Rollback

- At boot: select an older generation from systemd-boot.
- From a running system:

```bash
sudo nixos-rebuild switch --rollback
```

---

## Development

The flake ships a devShell with the repo's tools. Enter it with `nix develop` (or just `cd` here if you use direnv — there's a `.envrc`):

```bash
nix develop
```

From the devShell you can check your work before committing:

```bash
nix fmt -- --check   # formatting is enforced in CI
nix flake check   # evaluates + builds the system and home-manager configs
```

The same two checks run automatically on every push/PR in CI (see `.github/workflows/ci.yml`).

### Adding a package

- **System-wide** (GUI apps, greeter, anything a user might not have): add it to `environment.systemPackages` in `modules/packages.nix`.
- **User-level** CLI/dev tools: add it to the matching category file under `home/` — `dev/tools.nix`, `dev/nix.nix`, `dev/languages.nix`, `gui/ides.nix`, or `gui/media.nix` — whichever fits the tool's purpose.
- Prefer the stable channel (`pkgs`). Only use `pkgs-unstable.<pkg>` when you need a newer version than 26.05 ships.

### Adding a module

Drop a `.nix` file under `modules/` (or `home/` for user config) and `import` it from the host's `default.nix` (or `home/default.nix`). Keep modules focused: one concern per file.

### Adding a host

1. Create `hosts/<name>/hardware.nix`:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/<name>/hardware.nix
   ```
2. Copy `hosts/spica/default.nix` to `hosts/<name>/default.nix` and tweak identity/locale.
3. Add the host name to the `hosts` list in `flake.nix` — the `nixosConfigurations` output is generated from it.
4. Build it with `sudo nixos-rebuild switch --flake .#<name>`.

### Shared expressions

Anything referenced from both system modules and home-manager (like the icon theme) lives in `lib/` and is imported where needed — keep it that way instead of duplicating overrides.

---

## Troubleshooting

**`nix fmt -- --check` fails in CI but everything looks fine locally.** Run `nix fmt` from the devShell to reformat, then commit.

**The build works locally but CI fails.** Make sure the flake.lock is committed (`nix flake lock`), and that you've pushed the lockfile alongside your `.nix` changes.

**Auto-upgrade doesn't seem to do anything.** Check the timer (`systemctl list-timers`) and the remote ref in `modules/nix.nix` — upgrades pull from `github:ivanovertime/nixos`, so uncommitted local changes won't be applied until you push.

---

*Maintained with care and occasional frustration.*
