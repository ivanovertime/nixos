# NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-system-blue.svg?style=for-the-badge&logo=NixOS&logoColor=white)](https://nixos.org/)
[![Reproducible Code](https://img.shields.io/badge/Reproducible-Yes-success.svg?style=for-the-badge)](#)
[![Declarative](https://img.shields.io/badge/Infrastructure_as_Code-Yes-orange.svg?style=for-the-badge)](#)

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
├── flake.nix                       # Entry point — inputs & outputs
├── flake.lock                      # Pinned dependency versions
├── hosts/
│   └── spica/
│       ├── default.nix             # Host identity, locale, module imports
│       └── hardware.nix            # Machine-specific hardware (auto-generated)
├── modules/
│   ├── boot.nix                    # Boot loader, kernel params, zram swap
│   ├── desktop/
│   │   ├── cosmic.nix              # COSMIC DE, greeter, portals, env vars
│   │   └── fonts.nix              # Font packages & fontconfig
│   ├── hardware/
│   │   └── amd.nix                # AMD GPU, firmware, microcode
│   ├── networking.nix             # NetworkManager, Bluetooth
│   ├── nix.nix                    # Flakes, GC, optimise, auto-upgrade
│   ├── packages.nix               # System-wide GUI packages
│   ├── services.nix               # PipeWire, printing, fwupd, Docker
│   └── users.nix                  # User accounts, groups, home-manager bridge
├── home/
│   ├── default.nix                # Home-manager entry, CLI packages, starship
│   ├── shell/
│   │   ├── bash.nix               # Bash config & aliases
│   │   └── tools.nix              # eza, yazi, tmux, zellij
│   ├── editors/
│   │   ├── helix.nix              # Helix editor & language servers
│   │   └── emacs.nix              # Emacs with custom packages & init
│   ├── desktop/
│   │   ├── gtk.nix                # GTK theme, cursor, dconf
│   │   ├── icons.nix              # COSMIC icon aliases for Tela theme
│   │   └── mime.nix               # MIME default applications
│   └── programs/
│       └── celluloid.nix          # Celluloid/mpv scripts & keybinds
├── config/                        # Static dotfiles
│   └── celluloid/
│       ├── autosub.lua
│       └── input.conf
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

- Weekly system upgrades via the flake
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

*Maintained with care and occasional frustration.*
