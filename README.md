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

## Hardware

The config targets a single machine, `spica`. Everything below is what the current
`hosts/spica/hardware.nix` and kernel are actually running on (read from DMI, `lscpu`,
`lsblk` and `/sys`, NixOS 26.05 / kernel 6.18):

| | |
|---|---|
| Model | Lenovo V15 G4 ABP (machine type `83CR`) |
| Board | `LNVNB161216` (NO DPK) · BIOS `MSCN20WW` (2025-01-09) |
| CPU | AMD Ryzen 7 7730U — 8C/16T, Zen 3, up to 4.55 GHz |
| GPU | AMD Barcelo/Radeon Vega iGPU (`1002:15e7`), `amdgpu` driver |
| RAM | 16 GB (14.9 GiB usable; SMBIOS reports 2 memory devices) |
| Storage | WD PC SN740 256 GB NVMe (`nvme0n1`) |
| Display | 15.3" 1920×1080 eDP panel (34×19 cm, per EDID) + HDMI-A-1 / DP-1 outputs |
| Wi-Fi / BT | MediaTek MT7921 (`mt7921e`) + Bluetooth |
| Ethernet | Realtek RTL8168/8111 (`r8169`) |
| Webcam | SunplusIT Integrated Camera |
| Audio | AMD HDA controllers (`snd_hda_intel`, `1002:1637` + `1022:15e3`) over PipeWire |
| Battery | SMP `L20M2PF0`, 38 Wh design (Li-poly) |
| Security | fTPM 2.0 (`tpm0`), AMD-V virtualisation |

### Disk layout

| Partition | Size | Mount | Filesystem |
|---|---|---|---|
| `nvme0n1p1` | 1 GB | `/boot` | vfat, partlabel `EFI` (systemd-boot) |
| `nvme0n1p2` | 228.7 GB | `/` | ext4, label `root` |
| `nvme0n1p3` | 8.8 GB | swap | swap, label `swap` |

Swap is 7.5 GiB of zram (`zramSwap`, zstd — compresses in RAM, so it costs far less
than 7.5 GiB of physical memory) plus the 8.8 GB `nvme0n1p3` partition, with
`vm.swappiness = 160`.

Note: `swapDevices` is empty in `hosts/spica/hardware.nix`, so the swap partition is not
declared by the flake — systemd picks it up at boot through its discoverable-partition
mechanism (`/dev/disk/by-designator/swap` → `nvme0n1p3`). It works, but it is implicit;
declaring it would make the setup honest.

### Hardware-specific settings

These are the bits of the config that exist because of this exact machine:

- `boot.kernelParams = [ "amdgpu.sg_display=0" ]` — avoids scatter-gather display buffers that glitch on APUs using system RAM as VRAM.
- `hardware.cpu.amd.updateMicrocode = true` and `hardware.enableRedistributableFirmware = true` in `modules/hardware/amd.nix`.
- `boot.kernelModules = [ "kvm-amd" ]` for AMD-V virtualisation (Docker/KVM workloads).

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yml                 # Format + build checks on push/PR
├── .editorconfig                  # Editor style rules
├── .envrc                         # `use flake` — auto-loads devShell via direnv
├── flake.nix                      # Entry point — inputs, outputs, overlays, checks
├── flake.lock                     # Pinned dependency versions
├── .agents/
│   └── skills/
│       └── nixos/SKILL.md         # Repo skill for AI agents (pi et al.)
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
│   ├── services/
│   │   ├── audio.nix              # PipeWire audio stack
│   │   ├── printing.nix           # Printing & firmware updates
│   │   ├── docker.nix             # Docker containers
│   │   ├── livebook.nix           # Livebook user service
│   │   ├── postgres.nix           # PostgreSQL 16 with a local dev role/db
│   │   └── journald.nix           # Journal size cap
│   └── users.nix                  # User accounts, groups, home-manager bridge
├── home/
│   ├── default.nix                # Home-manager entry, imports, git, starship
│   ├── shell/
│   │   ├── bash.nix               # Bash config & aliases
│   │   └── tools.nix              # eza (ls replacement)
│   ├── editors/
│   │   ├── helix.nix              # Helix editor & language servers
│   │   └── vscodium.nix           # VSCodium & extensions
│   ├── dev/
│   │   ├── tools.nix              # CLI dev tools (fd, ripgrep, gh, curl, ...)
│   │   ├── nix.nix                # Nix tooling (nil, nixfmt)
│   │   └── languages.nix          # Language/dev apps (aspell)
│   ├── gui/
│   │   └── default.nix            # GUI media & tools (qbittorrent, GNOME utils)
│   ├── desktop/
│   │   ├── gtk.nix                # GTK theme, cursor, dconf
│   │   ├── icons.nix              # COSMIC icon aliases for Tela theme
│   │   └── mime.nix               # MIME default applications
│   └── programs/
│       ├── celluloid/
│       │   ├── default.nix        # Celluloid/mpv scripts & keybinds
│       │   ├── autosub.lua
│       │   └── input.conf
│       ├── herdr/default.nix      # herdr + user systemd server service
│       ├── lf/
│       │   ├── default.nix        # lf file manager (git status, trash, previews)
│       │   ├── icons
│       │   └── previewer.sh
│       ├── opencode/default.nix   # pinned opencode (fixed DB, no self-update)
│       └── pi/default.nix         # pi coding agent (skip its update check)
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
- Weekly garbage collection (removes store paths older than 14 days)
- Store optimisation (deduplication) happens automatically on every write
- Boot menu limited to the latest 10 generations

Reboot is not automatic — new generations apply on next reboot, or you can rebuild manually.

### Check Timers

```bash
systemctl list-timers --all | grep -E 'nixos-upgrade|nix-gc'
systemctl status nixos-upgrade.timer nix-gc.timer
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
- **User-level** CLI/dev tools: add it to the matching category file under `home/` — `dev/tools.nix`, `dev/nix.nix`, `dev/languages.nix`, or `gui/default.nix` — whichever fits the tool's purpose.
- **Pinned programs with config** (a tool that needs its own modules, scripts, or settings, like `lf` or `opencode`): give it a directory under `home/programs/` and import it from `home/default.nix`.
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

Anything needed by both system modules and home-manager (like the `tela-circle-green` icon theme) is defined once as an overlay in `flake.nix`, not imported per file — keep it that way instead of duplicating overrides.

---

## Troubleshooting

**`nix fmt -- --check` fails in CI but everything looks fine locally.** Run `nix fmt` from the devShell to reformat, then commit.

**The build works locally but CI fails.** Make sure the flake.lock is committed (`nix flake lock`), and that you've pushed the lockfile alongside your `.nix` changes.

**Auto-upgrade doesn't seem to do anything.** Check the timer (`systemctl list-timers`) and the remote ref in `modules/nix.nix` — upgrades pull from `github:ivanovertime/nixos`, so uncommitted local changes won't be applied until you push.

---

*Maintained with care and occasional frustration.*
