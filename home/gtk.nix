{ pkgs, ... }:

{
  # Cursor theme (applies to GTK, Hyprland and XWayland apps).
  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  # GTK theming. Adwaita-dark is used as a safe, always-present dark theme;
  # the Tela Circle (green) icon set matches the previous GNOME setup.
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
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };

  # Prefer dark mode for libadwaita / GTK4 apps and Qt (qgnomeplatform reads this).
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
