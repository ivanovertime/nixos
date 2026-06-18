{ pkgs, ... }:

{
  # Cursor theme (applies to GTK, Hyprland and XWayland apps).
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  # GTK theming with Everforest.
  gtk = {
    enable = true;
    theme = {
      name = "Everforest-Dark-BL";
      package = pkgs.everforest-gtk-theme;
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

  # Configure Qt5/Qt6 apps via qt5ct/qt6ct with consistent Everforest theming.
  # qt5ct is the system platform theme; qt6ct is configured identically for consistency.
  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=/home/ivan/.config/qt5ct/colors/everforest.conf
    custom_palette=true
    icon_theme=Tela-circle-green-dark
    standard_dialogs=default
    style=Fusion

    [Fonts]
    fixed="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
    general="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=/home/ivan/.config/qt6ct/colors/everforest.conf
    custom_palette=true
    icon_theme=Tela-circle-green-dark
    standard_dialogs=default
    style=Fusion

    [Fonts]
    fixed="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
    general="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
  '';

  xdg.configFile."qt5ct/colors/everforest.conf".text = ''
    [ColorScheme]
    active_colors=#d3c6aa, #272e33, #2e383c, #d3c6aa, #a7c080, #272e33, #859289, #272e33, #d3c6aa, #e69875, #a7c080, #dbbc7f, #7fbbb3, #d699b6, #83c092, #e67e80, #272e33, #d3c6aa, #d3c6aa, #272e33, #272e33
    disabled_colors=#859289, #272e33, #2e383c, #859289, #2e383c, #272e33, #859289, #272e33, #859289, #7a8478, #7a8478, #7a8478, #7a8478, #7a8478, #7a8478, #7a8478, #272e33, #859289, #859289, #272e33, #272e33
    inactive_colors=#d3c6aa, #272e33, #2e383c, #d3c6aa, #a7c080, #272e33, #859289, #272e33, #d3c6aa, #e69875, #a7c080, #dbbc7f, #7fbbb3, #d699b6, #83c092, #e67e80, #272e33, #d3c6aa, #d3c6aa, #272e33, #272e33
  '';

  xdg.configFile."qt6ct/colors/everforest.conf".text = ''
    [ColorScheme]
    active_colors=#d3c6aa, #272e33, #2e383c, #d3c6aa, #a7c080, #272e33, #859289, #272e33, #d3c6aa, #e69875, #a7c080, #dbbc7f, #7fbbb3, #d699b6, #83c092, #e67e80, #272e33, #d3c6aa, #d3c6aa, #272e33, #272e33
    disabled_colors=#859289, #272e33, #2e383c, #859289, #2e383c, #272e33, #859289, #272e33, #859289, #7a8478, #7a8478, #7a8478, #7a8478, #7a8478, #7a8478, #7a8478, #272e33, #859289, #859289, #272e33, #272e33
    inactive_colors=#d3c6aa, #272e33, #2e383c, #d3c6aa, #a7c080, #272e33, #859289, #272e33, #d3c6aa, #e69875, #a7c080, #dbbc7f, #7fbbb3, #d699b6, #83c092, #e67e80, #272e33, #d3c6aa, #d3c6aa, #272e33, #272e33
  '';

  xdg.configFile."chrome-flags.conf".text = ''
    --enable-features=WebUIDarkMode,ForceDarkMode,WaylandWindowDecorations
    --force-dark-mode
  '';

  xdg.configFile."google-chrome-flags.conf".text = ''
    --enable-features=WebUIDarkMode,ForceDarkMode,WaylandWindowDecorations
    --force-dark-mode
  '';

  xdg.configFile."google-chrome-stable-flags.conf".text = ''
    --enable-features=WebUIDarkMode,ForceDarkMode,WaylandWindowDecorations
    --force-dark-mode
  '';

  # Prefer dark mode and pin GTK/icon themes for GTK/libadwaita apps.
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Everforest-Dark-BL";
    icon-theme = "Tela-circle-green-dark";
    gtk-decoration-layout = ":";
  };

  dconf.settings."org/gnome/desktop/wm/preferences" = {
    button-layout = ":";
  };
}
