{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./shell/bash.nix
    ./shell/tools.nix
    ./editors/helix.nix
    ./editors/emacs.nix
    ./desktop/gtk.nix
    ./desktop/icons.nix
    ./desktop/clipboard.nix
    ./desktop/mime.nix
    ./programs/celluloid
    ./programs/opencode
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
    gh
    curl
    wget
    unzip
    btop

    # GUI tools
    pkgs-unstable.vscode
    pkgs-unstable.antigravity

    # Nix tooling
    nil
    nixfmt

    # Development
    bruno
    livebook

    # Media
    qbittorrent

    # Language tools
    python3Packages.subliminal
    (aspellWithDicts (
      dicts: with dicts; [
        en
        es
      ]
    ))
  ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "trunk";
    };
  };

  programs.starship.enable = true;

  programs.home-manager.enable = true;
}
