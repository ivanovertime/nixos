{ cursor-clip, pkgs, ... }:

let
  cursor-clip-pkg = cursor-clip.packages.${pkgs.system}.default;
in
{
  # Cursor Clip — GTK4/Libadwaita Wayland clipboard manager.
  # Uses zwlr_data_control_manager_v1 (enabled via COSMIC_DATA_CONTROL_ENABLED=1)
  # and zwlr_layer_shell_v1 for overlay positioning.
  # Being Libadwaita, it automatically follows the system dark/light theme.

  home.packages = [ cursor-clip-pkg ];

  systemd.user.services.cursor-clip = {
    Unit = {
      Description = "Cursor Clip clipboard daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${cursor-clip-pkg}/bin/cursor-clip --daemon";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
