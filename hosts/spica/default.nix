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
    ../../modules/services.nix
    ../../modules/nix.nix
    ../../modules/packages.nix
    ../../modules/users.nix
  ];

  # ── Host identity ──────────────────────────────────────────────────────
  networking.hostName = "spica";
  system.nixos.label = "Spica";

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
