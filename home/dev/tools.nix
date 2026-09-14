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

    # Google Antigravity CLI (free-tier Gemini via Google account OAuth,
    # login state already cached in ~/.gemini)
    pkgs-unstable.antigravity-cli
  ];
}
