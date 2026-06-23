# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/refs/heads/release-26.05.tar.gz";

  harunaDesktop = "org.kde.haruna.desktop";
  gwenviewDesktop = "org.kde.gwenview.desktop";
  okularDesktop = "org.kde.okular.desktop";
  arkDesktop = "org.kde.ark.desktop";
  kateDesktop = "org.kde.kate.desktop";
in
{
  imports = [
    ./hardware-configuration.nix
    "${home-manager}/nixos"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  zramSwap.enable = true;

  networking.hostName = "spica";
  system.nixos.label = "Spica";

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

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

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.gvfs.enable = true;
  services.accounts-daemon.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.fwupd.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;

  users.users.ivan = {
    isNormalUser = true;
    description = "Ivan Alvarez";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = [
      #  thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    channel = "https://nixos.org/channels/nixos-26.05";
    allowReboot = false;
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  # Home Manager is imported through the NixOS module.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    users.ivan = import ./home.nix;
  };

  xdg.mime.defaultApplications = {
    "audio/aac" = harunaDesktop;
    "audio/flac" = harunaDesktop;
    "audio/mp4" = harunaDesktop;
    "audio/mpeg" = harunaDesktop;
    "audio/ogg" = harunaDesktop;
    "audio/wav" = harunaDesktop;
    "audio/webm" = harunaDesktop;
    "audio/x-flac" = harunaDesktop;
    "audio/x-m4a" = harunaDesktop;
    "audio/x-ms-wma" = harunaDesktop;
    "audio/x-vorbis+ogg" = harunaDesktop;
    "audio/x-wav" = harunaDesktop;
    "video/mp4" = harunaDesktop;
    "video/mpeg" = harunaDesktop;
    "video/quicktime" = harunaDesktop;
    "video/webm" = harunaDesktop;
    "video/x-matroska" = harunaDesktop;
    "video/x-msvideo" = harunaDesktop;

    "application/pdf" = okularDesktop;

    "image/bmp" = gwenviewDesktop;
    "image/gif" = gwenviewDesktop;
    "image/jpeg" = gwenviewDesktop;
    "image/png" = gwenviewDesktop;
    "image/svg+xml" = gwenviewDesktop;
    "image/tiff" = gwenviewDesktop;
    "image/webp" = gwenviewDesktop;

    "application/zip" = arkDesktop;
    "application/x-7z-compressed" = arkDesktop;
    "application/x-rar" = arkDesktop;
    "application/x-tar" = arkDesktop;
    "application/x-xz" = arkDesktop;
    "application/gzip" = arkDesktop;

    "text/plain" = kateDesktop;
  };

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    google-chrome

    git
    gh
    github-copilot-cli

    nil
    wget
    ripgrep
    curl
    unzip
    htop

    vscode
    antigravity
    gemini-cli
    dbeaver-bin

    gimp
    inkscape
    obs-studio
    haruna

    qbittorrent

    (tela-circle-icon-theme.override { colorVariants = [ "green" ]; })
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font Mono"
        "JetBrainsMono Nerd Font"
      ];
    };
  };

  hardware.cpu.amd.updateMicrocode = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}
