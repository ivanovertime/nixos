{ ... }:

{
  imports = [
    ./hardware.nix

    # System modules
    ../../modules/boot.nix
    ../../modules/networking.nix
    ../../modules/desktop/cosmic.nix
    ../../modules/desktop/fonts.nix
    ../../modules/hardware/amd.nix
    ../../modules/hardware/battery.nix
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

  # ── Host identity ──────────────────────────────────────────────────────
  networking.hostName = "spica";
  system.nixos.label = "Spica";

  # nvme0n1p3 holds the swap partition (label `swap`). It was coming up only
  # because systemd discovers it on its own; declaring it makes the setup
  # explicit. `hardware.nix` is auto-generated, so the entry lives here.
  swapDevices = [ { device = "/dev/disk/by-uuid/eab1711b-915f-4d96-b405-4c7d27423d2d"; } ];

  # ── Locale & timezone ─────────────────────────────────────────────────
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
