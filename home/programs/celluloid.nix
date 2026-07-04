{ ... }:

let
  celluloidAutosub = ../../config/celluloid/autosub.lua;
  celluloidInput = ../../config/celluloid/input.conf;
in
{
  # Keep autosub available for both plain mpv config and Celluloid's plugin dir.
  xdg.configFile."mpv/scripts/autosub.lua".source = celluloidAutosub;
  xdg.configFile."celluloid/scripts/autosub.lua".source = celluloidAutosub;

  # Resolve key conflicts by mapping keys explicitly to autosub script commands.
  xdg.configFile."mpv/input.conf".source = celluloidInput;
  xdg.configFile."celluloid/input.conf".source = celluloidInput;
}
