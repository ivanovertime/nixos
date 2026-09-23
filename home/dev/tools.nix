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

    # Clipboard access for pi image paste (Ctrl+V) on Wayland (COSMIC)
    wl-clipboard

    # Google Antigravity CLI (free-tier Gemini via Google account OAuth,
    # login state already cached in ~/.gemini)
    pkgs-unstable.antigravity-cli

    # Anthropic Claude Code CLI (unfree; pkgs-unstable has allowUnfree set)
    pkgs-unstable.claude-code
  ];
}
