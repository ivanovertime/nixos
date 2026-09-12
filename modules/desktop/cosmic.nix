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
  ];

  programs.dconf.enable = true;

  services.system76-scheduler.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "cosmic";
    NIXOS_OZONE_WL = "1";
    COSMIC_DATA_CONTROL_ENABLED = "1";
    # Disabling direct/overlay scanout stops cosmic-comp from promoting windows
    # to hardware planes. On this Barcelo (DCN21) APU the secondary-pipe/bandwidth
    # validation fails (see dmesg: dcn21_validate_bandwidth / MODE2 reset), which
    # shows up as flicker when a window like Chrome is composited. These are the
    # real cosmic-comp variables (verified in the binary), unlike COSMIC_FORCE_VRR.
    COSMIC_DISABLE_DIRECT_SCANOUT = "1";
    COSMIC_DISABLE_OVERLAY_SCANOUT = "1";
  };
}
