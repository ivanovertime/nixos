{ pkgs, ... }:

{
  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  # Keep cursor/theme defaults declarative so old state is overwritten on rebuild.
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Tela-circle-green-dark";
      package = pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
      gtk-theme = "Adwaita-dark";
      icon-theme = "Tela-circle-green-dark";
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/wm/preferences" = {
      theme = "Adwaita-dark";
    };
  };

  programs.home-manager.enable = true;
}
