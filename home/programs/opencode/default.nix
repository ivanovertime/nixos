# opencode is used from the terminal inside herdr worktrees, never via the
# VSCode OpenChamber extension. Pinning it in Nix gives a single version and a
# single SQLite database, which is what keeps the DB from getting corrupted.
{ pkgs-unstable, ... }:

{
  home.packages = [ pkgs-unstable.opencode ];

  # opencode keeps every session in one SQLite database under
  # ~/.local/share/opencode. Pin the file name and disable self-update so a
  # channel change can no longer silently pick opencode-<channel>.db, and the
  # binary cannot be swapped out from under a running TUI.
  #
  # Set in initExtra (not home.sessionVariables) because herdr panes run
  # non-login interactive shells, which do not source the login profile.
  programs.bash.initExtra = ''
    export OPENCODE_DB="opencode.db"
    export OPENCODE_DISABLE_CHANNEL_DB="1"
    export OPENCODE_DISABLE_AUTOUPDATE="1"
  '';
}
