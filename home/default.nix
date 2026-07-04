{ pkgs, ... }:

{
  imports = [
    ./shell/bash.nix
    ./shell/tools.nix
    ./editors/helix.nix
    ./desktop/gtk.nix
    ./desktop/icons.nix
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
    opencode
    curl
    wget
    unzip
    btop

    # Nix tooling
    nil
    nixfmt

    # Language tools
    python3Packages.subliminal
    (aspellWithDicts (
      dicts: with dicts; [
        en
        es
      ]
    ))
  ];

  programs.starship.enable = true;

  programs.antigravity.enable = true;

  programs.home-manager.enable = true;
}
