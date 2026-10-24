{ pkgs-unstable, ... }:

{
  home.packages = [ pkgs-unstable.pi-coding-agent ];

  home.sessionVariables = {
    # Nix owns updates; skip the CLI's check
    PI_SKIP_VERSION_CHECK = "1";
  };
}
