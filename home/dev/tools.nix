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

    # _7zz is the only one that reads AES-encrypted zips.
    _7zz
    zip
    unzip
    unrar

    lm_sensors
    libva-utils

    # internal panel; needs the udev rule in modules/hardware/amd.nix
    brightnessctl

    # pi image paste (Ctrl+V) on Wayland
    wl-clipboard

    pkgs-unstable.antigravity-cli

    # unfree (unstable input has allowUnfree)
    pkgs-unstable.claude-code
  ];
}
