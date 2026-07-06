{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./shell/bash.nix
    ./shell/tools.nix
    ./editors/helix.nix
    ./desktop/gtk.nix
    ./desktop/icons.nix
    ./desktop/clipboard.nix
    ./desktop/mime.nix
    ./programs/celluloid.nix
  ];

  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.packages = with pkgs; [
    # CLI tools
    fd
    ripgrep
    shellcheck
    git
    gh
    pkgs-unstable.opencode
    pkgs-unstable.vscode
    pkgs-unstable.antigravity
    curl
    wget
    unzip
    btop
    starship

    # Nix tooling
    nil
    nixfmt

    # Development
    livebook

    # Language tools
    python3Packages.subliminal
    (aspellWithDicts (
      dicts: with dicts; [
        en
        es
      ]
    ))
  ];

  programs.home-manager.enable = true;
}
