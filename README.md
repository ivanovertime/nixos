# NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-system-blue.svg?style=for-the-badge&logo=NixOS&logoColor=white)](https://nixos.org/)
[![Reproducible Code](https://img.shields.io/badge/Reproducible-Yes-success.svg?style=for-the-badge)](#)
[![Declarative](https://img.shields.io/badge/Infrastructure_as_Code-Yes-orange.svg?style=for-the-badge)](#)

Yet another NixOS flake. This one belongs to me.

Everything my computer does is specified in `.nix` files. This is either the future of system administration or a very elaborate way to avoid learning how to configure things properly.

---

## Why NixOS?

- **Declarative Configuration:** My entire OS is one big config file. When it breaks, I know exactly where to look — the config file.
- **Reproducibility:** The same config produces the same setup on any machine. This is useful approximately once, when setting up a new machine.
- **Atomic Upgrades & Rollbacks:** If an update breaks everything, the bootloader lets me go back to when things worked. This happens more often than I'd like to admit.
- **Development Shells:** Isolated environments so my projects don't fight each other. I use this to avoid conflict resolution at the OS level.

## What This Demonstrates

If you're here to evaluate my technical abilities, this repo shows I can:

- Write Nix expressions that compile (eventually)
- Stare at a terminal for extended periods
- Turn minor configuration problems into multi-day rabbit holes
- Describe my workflow in grandiose terms

---

## Repository Structure

```
.
├── flake.nix                       # Entry point — inputs & outputs
├── flake.lock                      # Auto-generated; I don't touch this
├── hosts/
│   └── spica/
│       ├── default.nix             # My machine's personality
│       └── hardware.nix            # Auto-generated; I definitely don't touch this
├── modules/
│   ├── boot.nix                    # Boot loader, kernel params, zram swap
│   ├── desktop/
│   │   ├── cosmic.nix              # COSMIC DE, greeter, portals, env vars
│   │   └── fonts.nix              # Fonts, so things look nice
│   ├── hardware/
│   │   └── amd.nix                # AMD GPU stuff
│   ├── networking.nix             # NetworkManager, so Wi-Fi works
│   ├── nix.nix                    # Flakes, GC, auto-upgrade
│   ├── packages.nix               # GUI applications
│   ├── services.nix               # PipeWire, printing, Docker
│   └── users.nix                  # User accounts & groups
├── home/
│   ├── default.nix                # Home-manager entry
│   ├── shell/
│   │   ├── bash.nix               # How my terminal looks
│   │   └── tools.nix              # CLI tools I installed once
│   ├── editors/
│   │   └── helix.nix              # Helix config
│   ├── desktop/
│   │   ├── gtk.nix                # GTK theme
│   │   ├── icons.nix              # Icons
│   │   └── mime.nix               # Default apps
│   └── programs/
│       └── celluloid.nix          # Video player config
├── config/                        # Static dotfiles
│   └── celluloid/
│       ├── autosub.lua
│       └── input.conf
└── README.md                      # This file
```

## Usage

This configuration is for my machine. It will probably not work on yours without significant modification. You have been warned.

**1. Clone:**
```bash
git clone <your-repo-url> ~/Source/nixos
cd ~/Source/nixos
```

**2. Generate hardware config (because your hardware is different):**
```bash
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware.nix
```

**3. Build:**
```bash
sudo nixos-rebuild switch --flake .#spica
```

## Updating

```bash
nix flake update
sudo nixos-rebuild switch --flake .#spica
```

## Automatic Maintenance

The system updates itself weekly. Garbage collection runs weekly too. Old boot entries get cleaned up. This is all automated so I don't have to think about it.

### Check Timers

```bash
systemctl list-timers --all | grep -E 'nixos-upgrade|nix-gc|nix-optimise'
systemctl status nixos-upgrade.timer nix-gc.timer nix-optimise.timer
```

### Rollback

- At boot: pick an older generation from systemd-boot.
- From a running system:

```bash
sudo nixos-rebuild switch --rollback
```

---

*Maintained inconsistently.*
