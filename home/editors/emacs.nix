{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;

    package = pkgs.emacs;

    extraPackages =
      epkgs: with epkgs; [
        vterm
        treesit-grammars.with-all-grammars
        dashboard
        doom-themes
        projectile
        vertico
        marginalia
        which-key
      ];

    # Kept in ./emacs/init.el so it's version-controlled and diffable like
    # everything else in this repo.
    extraConfig = builtins.readFile ./emacs/init.el;
  };

  services.emacs = {
    enable = true;
    defaultEditor = false;
  };
}
