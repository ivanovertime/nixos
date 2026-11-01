<h1 align="center">NixOS Configuration</h1>

<p align="center">
  <a href="https://github.com/ivanovertime/nixos/actions/workflows/ci.yml"><img src="https://github.com/ivanovertime/nixos/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

This is my NixOS system configuration. It defines everything about my computer — packages, services, desktop environment, boot settings — in code. I use it so I can rebuild my setup from scratch, or recover from a bad update, without losing a whole weekend.

NixOS 26.05, one host (`spica`), fully flake-based. The setup runs COSMIC desktop on AMD hardware, with home-manager handling user-level config.

---

## What's in here

- **COSMIC desktop** on AMD hardware — PipeWire audio, the Tela icon theme, systemd-boot.
- **Everyday services**: Docker, PostgreSQL 16 with a local dev role, Livebook, printing.
- **A terminal-first workflow**: herdr for panes and agent sessions, `lf` as the file manager, helix and VSCodium as editors.
- **Automatic upkeep**: weekly upgrades, weekly garbage collection, the last 10 generations in the boot menu.
- **Nothing hidden**: every package, service and user setting is a `.nix` file in git — see [What's not in the repo](#whats-not-in-the-repo) for the handful of things that can't be.

---

## Hardware

`spica` is a Lenovo V15 G4 ABP laptop — Ryzen 7 7730U, 16 GB RAM, 256 GB NVMe, 15.3"
1080p. Device-level detail lives in `hosts/spica/hardware.nix`; the disk is one 1 GB
EFI partition, a 228.7 GB ext4 root and an 8.8 GB swap partition.

Only a few settings exist because of this hardware:

- `amdgpu.sg_display=0` — avoids display glitches on APUs that use system RAM as VRAM.
- AMD microcode updates and redistributable firmware, from `modules/hardware/amd.nix`.
- `kvm-amd` for virtualisation.
- Swap is 7.5 GiB of zram plus that 8.8 GB partition, declared by UUID in
  `hosts/spica/default.nix` because `hardware.nix` leaves `swapDevices` empty.

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
│   │   └── amd.nix                # AMD GPU, firmware, microcode, backlight
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
│       ├── opencode/default.nix   # opencode config + global AGENTS.md, no self-update
│       └── pi/default.nix         # pi coding agent (skip its update check)
└── README.md
```

---

## Usage

The config is tailored to this machine, so adapt the host name and hardware as you go.
`spica` is the only host today — [Adding a host](#adding-a-host) covers a second one.

**1. Clone the repository:**
```bash
git clone https://github.com/ivanovertime/nixos.git ~/Source/nixos
cd ~/Source/nixos
```

**2. Generate your hardware configuration:**
```bash
sudo nixos-generate-config --show-hardware-config > hosts/spica/hardware.nix
```

**3. Build and apply:**
```bash
sudo nixos-rebuild switch --flake .#spica
```

---

## What's not in the repo

Secrets and machine-local state stay out of git. A rebuild needs these copied over or
re-created by hand:

- **Credentials**: `~/.local/share/opencode/auth.json` (model provider keys),
  `~/.config/gh/hosts.yml` (GitHub token), `~/.gnupg/`, and `~/.ssh/` if you add keys.
- **App state**: browser profiles, `~/.local/share/opencode/opencode.db` (every agent
  session), and any file under `~/.config` that home-manager does not manage.
- **Your password**: the flake creates the account, not the password — that is set at
  install time and only exists on the disk.

---

## Updating

Bump every input and apply:

```bash
nix flake update
sudo nixos-rebuild switch --flake .#spica
```

To move one input instead — nixpkgs, say — pass it by name:

```bash
nix flake update nixpkgs nixpkgs-unstable
```

A bump can also move the agent tooling, and a new opencode version migrates its database
on first start. Snapshot it first:

```bash
nix shell nixpkgs#sqlite -c sqlite3 ~/.local/share/opencode/opencode.db ".backup $HOME/opencode.db.bak"
```

---

## Automatic Maintenance

The system handles its own upkeep:

- Weekly system upgrades via the flake (from the GitHub remote, so they work no matter where the checkout lives)
- Weekly garbage collection (removes store paths older than 14 days)
- Store optimisation (deduplication) happens automatically on every write
- Boot menu limited to the latest 10 generations

Reboot is not automatic — new generations apply on next reboot, or you can rebuild manually.

### Checking the timers

```bash
systemctl list-timers nixos-upgrade.timer nix-gc.timer
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

**The build fails with "No space left on device".** `/` runs close to full here. Drop older generations (`sudo nix-collect-garbage --delete-older-than 7d`) and re-run — recent rollback points survive, and a few GB come back. The store deduplicates on write already, so there is no separate optimise timer to chase.

---

*Maintained with care and occasional frustration.*
