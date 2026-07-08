{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;

    package = pkgs.emacs;

    extraPackages =
      epkgs: with epkgs; [
        vterm
        treesit-grammars.with-all-grammars
        doom-themes
      ];

    # This is injected directly into your Emacs init file (early-init.el / init.el)
    extraConfig = ''
      ;; Disable startup message
      (setq inhibit-startup-message t)

      ;; Disable GUI cruft for a cleaner look
      (tool-bar-mode -1)
      (menu-bar-mode -1)
      (scroll-bar-mode -1)

      ;; Enable line numbers globally
      (global-display-line-numbers-mode t)

      ;; Load the doom-zenburn theme (ensure it's in extraPackages above)
      (load-theme 'doom-zenburn t)
    '';
  };

  services.emacs = {
    enable = true;
    defaultEditor = false;
  };
}
