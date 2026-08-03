;; Injected into your Emacs init file (early-init.el / init.el) by
;; home-manager via programs.emacs.extraConfig.

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

;; Enhanced minibuffer completion (better M-x)
(savehist-mode 1)
(vertico-mode 1)
(marginalia-mode 1)

;; Show available keybindings after a short delay
(which-key-mode 1)

;; Maximize frame on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Doom-style landing screen
(require 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-startup-banner 'logo)
