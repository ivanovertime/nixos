# ❄️ NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-system-blue.svg?style=for-the-badge&logo=NixOS&logoColor=white)](https://nixos.org/)
[![Reproducible Code](https://img.shields.io/badge/Reproducible-Yes-success.svg?style=for-the-badge)](#)
[![Declarative](https://img.shields.io/badge/Infrastructure_as_Code-Yes-orange.svg?style=for-the-badge)](#)

Welcome to my personal [NixOS](https://nixos.org/) system configuration repository! 

This repository serves as a single source of truth for my computing environment. By leveraging the power of NixOS, my entire operating system—including packages, configurations, user permissions, and services—is defined purely through code.

---

## 🚀 Why NixOS? (Developer Perspective)

For engineers and developers aiming for a robust workflow, Nix OS provides world-class guarantees:
- **Declarative Configuration:** The complete system architecture is mapped out in readable `.nix` files, eliminating unpredictable "system rot" and hidden state.
- **Reproducibility:** A given configuration reliably produces the exact same environment across different machines. No more *"it works on my machine"* anomalies.
- **Atomic Upgrades & Rollbacks:** Changes to the system are atomic. If an update breaks the environment, I can trivially rollback to the previous generation via the bootloader.
- **Development Shells:** Strict isolation of project dependencies via `nix-shell` or `nix develop`, keeping the host system completely clean.

## 👨‍💻 Highlights for Recruiters

If you're evaluating my technical background, this repository is a practical demonstration of my skills in:
- **Infrastructure as Code (IaC):** Treating system administration as software engineering.
- **Linux Systems Architecture:** Low-level configuration of bootloaders, kernel modules, filesystems, and `systemd` daemon services.
- **Automation First:** Demonstrating a relentless commitment to automation, reliability, and eliminating manual configuration toil.
- **Functional Package Management:** Using advanced dependency graphs and immutable system directories to eliminate variable side effects.

---

## 📂 Repository Structure

```
.
├── flake.nix                       # Entry point — inputs (nixpkgs, home-manager) & outputs
├── flake.lock                      # Auto-generated pinned dependency lockfile
├── hosts/
│   └── spica/
│       ├── default.nix             # Host entry — identity, locale, module imports
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
│   ├── default.nix                # HM entry — user identity, CLI packages, starship
│   ├── shell/
│   │   ├── bash.nix               # Bash config & aliases
│   │   └── tools.nix              # eza, yazi, tmux, zellij
│   ├── editors/
│   │   └── helix.nix              # Helix editor & language servers
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

## 🛠️ Usage

> **Note:** This configuration is highly tailored to my own hardware and workflow. It is recommended to use it as inspiration rather than applying it wholesale to your machine.

**1. Clone the repository:**
```bash
git clone <your-repo-url> ~/Source/nixos
cd ~/Source/nixos
```

**2. Generate your hardware configuration:**
*(Make sure to generate your own `hardware.nix` so the OS knows how to boot on your machine).*
```bash
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware.nix
```

**3. Build and apply the configuration:**
```bash
sudo nixos-rebuild switch --flake .#spica
```

## ⬆️ Manual NixOS Update

```bash
# Update all flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Rebuild with the updated inputs
sudo nixos-rebuild switch --flake .#spica
```

### Verify and Roll Back

```bash
nixos-version
sudo nixos-rebuild switch --rollback
```

Reboot is recommended after updates that include a new kernel or low-level system components:

```bash
sudo reboot
```

## 🔄 Automatic Updates And Cleanup

This setup now includes automated maintenance through NixOS:
- Weekly automatic system upgrades via the flake
- Weekly garbage collection of old store paths older than 30 days
- Automatic store optimization (deduplication)
- Boot menu retention limited to the latest 10 system configurations

Automatic reboot after upgrades is disabled. New system versions are applied and become active on next reboot unless you rebuild manually.

### Verify Timers

```bash
systemctl list-timers --all | grep -E 'nixos-upgrade|nix-gc|nix-optimise'
systemctl status nixos-upgrade.timer nix-gc.timer nix-optimise.timer
```

### Rollback If Needed

- At boot: select an older generation from the systemd-boot menu.
- From a running system:

```bash
sudo nixos-rebuild switch --rollback
```

---
*Maintained with ❤️ and purely functional constraints.*
