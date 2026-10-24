# terminal-only; Nix pinning keeps one version and one SQLite DB
{ pkgs-unstable, ... }:

{
  home.packages = [ pkgs-unstable.opencode ];

  # fixed DB name, no self-update; initExtra covers herdr's non-login panes
  programs.bash.initExtra = ''
    export OPENCODE_DB="opencode.db"
    export OPENCODE_DISABLE_CHANNEL_DB="1"
    export OPENCODE_DISABLE_AUTOUPDATE="1"
  '';
}
