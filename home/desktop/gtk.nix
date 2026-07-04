{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    gtk4.theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; };
      name = "Tela-circle-green-dark";
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".force = true;

  # Keep cursor/theme defaults declarative so old state is overwritten on rebuild.
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
      gtk-theme = "adw-gtk3-dark";
      color-scheme = "prefer-dark";
      icon-theme = "Tela-circle-green-dark";
    };
  };
}
