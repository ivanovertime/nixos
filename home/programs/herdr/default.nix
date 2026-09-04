{ herdr, ... }:

{
  home.packages = [ herdr ];

  systemd.user.services.herdr-server = {
    Unit = {
      Description = "Herdr agent runtime server";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${herdr}/bin/herdr server";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = "PATH=/etc/profiles/per-user/ivan/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
