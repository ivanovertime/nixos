{ pkgs, ... }:

{
  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

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
    gtk4.theme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
    theme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
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
      gtk-theme = "Breeze";
      icon-theme = "Tela-circle-green-dark";
      color-scheme = "default";
    };

    "org/gnome/desktop/wm/preferences" = {
      theme = "Breeze";
    };
  };

  programs.tmux.enable = true;

  programs.ranger.enable = true;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    theme = "base16_default_dark";

    settings = {
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
