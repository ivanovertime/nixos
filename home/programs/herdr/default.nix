{
  lib,
  pkgs,
  ...
}:

let
  libnotify = pkgs.libnotify;

  # hooks must live inside each agent's own config dir; reinstall on activation
  integrations = [
    "pi"
    "opencode"
    "antigravity-cli"
    "claude"
  ];
in
{
  home.packages = [
    pkgs.herdr
    libnotify
  ];

  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStringsSep "\n" (
      target:
      "run ${pkgs.herdr}/bin/herdr integration install ${target} "
      + ''|| echo "herdr: could not install the ${target} integration (continuing)" >&2''
    ) integrations
  );

  systemd.user.services.herdr-server = {
    Unit = {
      Description = "Herdr agent runtime server";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.herdr}/bin/herdr server";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = "PATH=/etc/profiles/per-user/ivan/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
