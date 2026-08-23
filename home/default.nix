{ ... }:

{
  imports = [
    ./shell/bash.nix
    ./shell/tools.nix
    ./shell/tmux.nix
    ./editors/helix.nix
    ./editors/emacs.nix
    ./editors/vscodium.nix
    ./dev/tools.nix
    ./dev/nix.nix
    ./dev/languages.nix
    ./gui/ides.nix
    ./gui/media.nix
    ./desktop/gtk.nix
    ./desktop/icons.nix
    ./desktop/mime.nix
    ./programs/celluloid
    ./programs/discord.nix
    ./programs/opencode
  ];

  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "trunk";
    };
  };

  programs.starship.enable = true;

  programs.home-manager.enable = true;
}
