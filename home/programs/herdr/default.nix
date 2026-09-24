{
  lib,
  pkgs,
  ...
}:

let
  # herdr's `system` toast delivery shells out to `notify-send` from PATH.
  libnotify = pkgs.libnotify;

  # Integration hooks have to live inside each agent's own config directory
  # (~/.pi, ~/.gemini), so they cannot be symlinked from the store. Re-run the
  # installer on activation instead; it is idempotent and reports "current"
  # when the installed hook already matches this herdr version.
  integrations = [
    "pi"
    "opencode"
    "antigravity-cli"
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
