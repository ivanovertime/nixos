{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    fd
    ripgrep
    shellcheck
    gh
    curl
    jq
    wget
    htop

    # Archives. `_7zz` is the official 7-Zip Linux port (reads and writes 7z and
    # zip, including AES-encrypted zips; Info-ZIP `unzip` only handles legacy
    # ZipCrypto). Passwords: `7zz x -pPW f.7z`, `unzip -P PW f.zip`,
    # `unrar x -pPW f.rar`. Note _7zz installs only the `7zz` binary, not `7z`.
    #
    # Viewing an archive needs none of these: Celluloid opens a .7z/.zip as a
    # playlist and plays the media inside it (its libmpv is built with
    # libarchive). Only encrypted archives have to be extracted first — every
    # libarchive consumer refuses those.
    _7zz
    zip
    unzip
    unrar

    # CPU/GPU temperature (k10temp, amdgpu) and VA-API verification (`vainfo`)
    lm_sensors
    libva-utils

    # Brightness: internal panel from the CLI (`brightnessctl set 40%`) and the
    # external monitor over DDC/CI (`ddcutil setvcp 10 30`). Both need device
    # access set up in modules/hardware/amd.nix.
    brightnessctl
    ddcutil

    # Clipboard access for pi image paste (Ctrl+V) on Wayland (COSMIC)
    wl-clipboard

    # Google Antigravity CLI (free-tier Gemini via Google account OAuth,
    # login state already cached in ~/.gemini)
    pkgs-unstable.antigravity-cli

    # Anthropic Claude Code CLI (unfree; pkgs-unstable has allowUnfree set)
    pkgs-unstable.claude-code
  ];
}
