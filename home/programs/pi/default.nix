{ pkgs-unstable, ... }:

{
  home.packages = [ pkgs-unstable.pi-coding-agent ];

  home.sessionVariables = {
    # Nix upgrades pi on rebuild; skip pi's own update check at startup.
    PI_SKIP_VERSION_CHECK = "1";
  };
}
