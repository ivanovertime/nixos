{ ... }:

{
  imports = [
    ./shell/bash.nix
    ./shell/tools.nix
    ./editors/helix.nix
    ./editors/vscodium.nix
    ./dev/tools.nix
    ./dev/nix.nix
    ./dev/languages.nix
    ./gui/media.nix
    ./gui/tools.nix
    ./desktop/gtk.nix
    ./desktop/icons.nix
    ./desktop/mime.nix
    ./programs/celluloid
    ./programs/pi
    ./programs/herdr
    ./programs/lf
    ./programs/opencode
  ];

  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "trunk";
      user = {
        name = "Ivan Alvarez";
        email = "20419834+ivanovertime@users.noreply.github.com";
      };
      credential = {
        "https://github.com".helper = "!/etc/profiles/per-user/ivan/bin/gh auth git-credential";
        "https://gist.github.com".helper = "!/etc/profiles/per-user/ivan/bin/gh auth git-credential";
      };
    };
  };

  programs.starship.enable = true;

  programs.home-manager.enable = true;
}
