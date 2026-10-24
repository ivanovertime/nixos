{ pkgs, ... }:

{
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = false;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-store
    cosmic-player
  ];

  environment.systemPackages = with pkgs; [
    cutecosmic
    # not in the module's defaults
    cosmic-viewer
  ];

  programs.dconf.enable = true;

  services.system76-scheduler.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "cosmic";
    NIXOS_OZONE_WL = "1";
    COSMIC_DATA_CONTROL_ENABLED = "1";
    # Barcelo DCN21 fails its bandwidth check in dmesg; hardware-plane
    # scanout shows up as flicker. Real cosmic-comp variables.
    COSMIC_DISABLE_DIRECT_SCANOUT = "1";
    COSMIC_DISABLE_OVERLAY_SCANOUT = "1";
  };
}
