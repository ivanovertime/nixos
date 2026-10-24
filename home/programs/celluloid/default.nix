{ pkgs, ... }:

let
  celluloidAutosub = ./autosub.lua;
  celluloidInput = ./input.conf;
in
{
  home.packages = [ pkgs.celluloid ];

  # autosub for plain mpv and Celluloid alike
  xdg.configFile."mpv/scripts/autosub.lua".source = celluloidAutosub;
  xdg.configFile."celluloid/scripts/autosub.lua".source = celluloidAutosub;

  # explicit keymaps resolve autosub conflicts
  xdg.configFile."mpv/input.conf".source = celluloidInput;
  xdg.configFile."celluloid/input.conf".source = celluloidInput;
}
