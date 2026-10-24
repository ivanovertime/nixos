{ ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/boot.nix
    ../../modules/networking.nix
    ../../modules/desktop/cosmic.nix
    ../../modules/desktop/fonts.nix
    ../../modules/hardware/amd.nix
    ../../modules/services/audio.nix
    ../../modules/services/printing.nix
    ../../modules/services/docker.nix
    ../../modules/services/livebook.nix
    ../../modules/services/postgres.nix
    ../../modules/services/journald.nix
    ../../modules/nix.nix
    ../../modules/packages.nix
    ../../modules/users.nix
  ];

  networking.hostName = "spica";
  system.nixos.label = "Spica";

  # explicit; systemd would discover it on its own (hardware.nix is auto-generated)
  swapDevices = [ { device = "/dev/disk/by-uuid/eab1711b-915f-4d96-b405-4c7d27423d2d"; } ];

  time.timeZone = "America/Caracas";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };

  system.stateVersion = "25.11"; # Do not change — see man configuration.nix(5).
}
