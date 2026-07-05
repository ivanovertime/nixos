{ pkgs, ... }:

{
  # CopyQ clipboard manager — autostart with the graphical session.
  # COSMIC sets QT_QPA_PLATFORMTHEME=cosmic, so CopyQ inherits the
  # desktop's dark theme and accent colour automatically.

  systemd.user.services.copyq = {
    Unit = {
      Description = "CopyQ clipboard manager";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.copyq}/bin/copyq --start-server";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
