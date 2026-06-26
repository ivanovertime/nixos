{ pkgs, ... }:

{
  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "application/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
    };
  };

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

  # Add COSMIC icon aliases in the active Tela theme to avoid duplicate launchers.
  xdg.dataFile."icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicFiles.svg".source =
    "${pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; }}/share/icons/Tela-circle-green-dark/scalable/apps/file-manager.svg";
  xdg.dataFile."icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicTerm.svg".source =
    "${pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; }}/share/icons/Tela-circle-green-dark/scalable/apps/terminal.svg";
  xdg.dataFile."icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicSettings.svg".source =
    "${pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; }}/share/icons/Tela-circle-green-dark/scalable/apps/preferences-system.svg";
  xdg.dataFile."icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicEdit.svg".source =
    "${pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; }}/share/icons/Tela-circle-green-dark/scalable/apps/text-editor.svg";
  xdg.dataFile."icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicPlayer.svg".source =
    "${pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; }}/share/icons/Tela-circle-green-dark/scalable/apps/totem.svg";
  xdg.dataFile."icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicReader.svg".source =
    "${pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; }}/share/icons/Tela-circle-green-dark/scalable/apps/accessories-document-viewer.svg";

  programs.tmux.enable = true;

  programs.ranger.enable = true;

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "base16_terminal";
      editor = {
        line-number = "relative";
        cursorline = true;
        true-color = true;
      };
    };

    languages = {
      language-server = {
        elixir-ls.command = "${pkgs.elixir-ls}/bin/elixir-ls";
        phpactor.command = "${pkgs.phpactor}/bin/phpactor";
        typescript-language-server = {
          command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
      };

      language = [
        {
          name = "nix";
          language-servers = [ "nil" ];
          auto-format = true;
        }
        {
          name = "elixir";
          language-servers = [ "elixir-ls" ];
          auto-format = true;
        }
        {
          name = "php";
          language-servers = [ "phpactor" ];
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
        }
      ];
    };
  };

  programs.home-manager.enable = true;
}
