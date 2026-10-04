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
    unzip
    htop

    # CPU/GPU temperature (k10temp, amdgpu) and VA-API verification (`vainfo`)
    lm_sensors
    libva-utils

    # Clipboard access for pi image paste (Ctrl+V) on Wayland (COSMIC)
    wl-clipboard

    # Google Antigravity CLI (free-tier Gemini via Google account OAuth,
    # login state already cached in ~/.gemini)
    pkgs-unstable.antigravity-cli

    # Anthropic Claude Code CLI (unfree; pkgs-unstable has allowUnfree set)
    pkgs-unstable.claude-code
  ];
}
