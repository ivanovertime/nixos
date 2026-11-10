{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        consult
        denote
        denote-journal
        magit
        marginalia
        markdown-mode
        vertico
      ];
  };

  # init.el lives in this repo; link it like the vscodium theme.
  home.file.".config/emacs/init.el".source = ./emacs/init.el;
}
