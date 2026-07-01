{ pkgs, ... }:

let
  autosubLua =
    builtins.replaceStrings
      [
        "            { 'English', 'en', 'eng' },"
        "            { 'Dutch', 'nl', 'dut' },"
        "--          { 'Spanish', 'es', 'spa' },"
      ]
      [
        "            { 'Spanish', 'es', 'spa' },"
        "            { 'English', 'en', 'eng' },"
        "--          { 'Dutch', 'nl', 'dut' },"
      ]
      (builtins.readFile "${pkgs.mpvScripts.autosub}/share/mpv/scripts/autosub.lua");
in
{
  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    DOOMDIR = "$HOME/.config/doom";
  };

  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];

  home.packages = with pkgs; [
    # Doom Emacs runtime dependencies and common helpers.
    emacs
    fd
    ripgrep
    shellcheck
    git
    nodejs
    (aspellWithDicts (dicts: with dicts; [ en es ]))
    nil
    nixfmt-rfc-style

    (writeShellScriptBin "doom-bootstrap" ''
      set -euo pipefail

      if [ ! -d "$HOME/.config/emacs/.git" ]; then
        echo "Cloning Doom Emacs..."
        git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
      fi

      # Plain `emacs` should point to Doom's core directory.
      if [ -e "$HOME/.emacs.d" ] && [ ! -L "$HOME/.emacs.d" ]; then
        rm -rf "$HOME/.emacs.d"
      fi
      ln -sfn "$HOME/.config/emacs" "$HOME/.emacs.d"

      mkdir -p "$HOME/.config/doom"

      if [ ! -f "$HOME/.config/doom/init.el" ]; then
        cat > "$HOME/.config/doom/init.el" <<'EOF'
(doom! :completion
       company
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       nav-flash
       ophints
       (popup +defaults)
       vc-gutter
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets

       :emacs
       dired
       electric
       undo
       vc

       :checkers
       syntax
       spell

       :tools
       direnv
       editorconfig
       eval
       lookup
       lsp
       magit
       tree-sitter

       :os
       (:if IS-LINUX tty)

       :lang
       emacs-lisp
       markdown
       (nix +lsp)
       (org +pretty)
       (python +lsp)
       (web +lsp)
       yaml

       :config
       (default +bindings +smartparens))
EOF
      fi

      if [ ! -f "$HOME/.config/doom/config.el" ]; then
        cat > "$HOME/.config/doom/config.el" <<'EOF'
(setq user-full-name "Ivan Alvarez"
      user-mail-address "alvarezlopezivanenrique@gmail.com")

(setq doom-theme 'doom-zenburn
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))
EOF
      fi

      if [ ! -f "$HOME/.config/doom/packages.el" ]; then
        cat > "$HOME/.config/doom/packages.el" <<'EOF'
;; Place your private package declarations here.
EOF
      fi

      if [ ! -f "$HOME/.local/share/doom/profiles.el" ]; then
        echo "Running first-time Doom install..."
        "$HOME/.config/emacs/bin/doom" install
      else
        echo "Doom already installed; syncing modules..."
        "$HOME/.config/emacs/bin/doom" sync -u
      fi
    '')
  ];

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

  # Keep autosub available for both plain mpv config and Celluloid's plugin dir.
  xdg.configFile."mpv/scripts/autosub.lua".text = autosubLua;
  xdg.configFile."celluloid/scripts/autosub.lua".text = autosubLua;

  # Resolve key conflicts by mapping keys explicitly to autosub script commands.
  xdg.configFile."mpv/input.conf".text = ''
    b script-binding autosub/download_subs
    n script-binding autosub/download_subs2
  '';
  xdg.configFile."celluloid/input.conf".text = ''
    b script-binding autosub/download_subs
    n script-binding autosub/download_subs2
  '';

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
