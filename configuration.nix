# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/refs/heads/release-26.05.tar.gz";
    sha256 = "10y7xwm4ykcs3pqyj80ri8vwgwwvzzax32f2vgpqb8qc25xv2sv4";
  };

  celluloidDesktop = "io.github.celluloid_player.Celluloid.desktop";
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

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.gnome-online-accounts.enable = true;
  services.gvfs.enable = true;
  services.gvfs.package = pkgs.gnome.gvfs.override {
    gnomeSupport = true;
  };
  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;
  programs.dconf.enable = true;

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

  users.users.ivan = {
    isNormalUser = true;
    description = "Ivan Alvarez";
    extraGroups = [
      "networkmanager"
      "wheel"
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

  environment.gnome.excludePackages = with pkgs; [
    decibels
    epiphany
    geary
    gnome-connections
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    gnome-user-docs
    gnome-weather
    showtime
  ];

  xdg.mime.defaultApplications = {
    "audio/aac" = celluloidDesktop;
    "audio/flac" = celluloidDesktop;
    "audio/mp4" = celluloidDesktop;
    "audio/mpeg" = celluloidDesktop;
    "audio/ogg" = celluloidDesktop;
    "audio/wav" = celluloidDesktop;
    "audio/webm" = celluloidDesktop;
    "audio/x-flac" = celluloidDesktop;
    "audio/x-m4a" = celluloidDesktop;
    "audio/x-ms-wma" = celluloidDesktop;
    "audio/x-vorbis+ogg" = celluloidDesktop;
    "audio/x-wav" = celluloidDesktop;
    "video/mp4" = celluloidDesktop;
    "video/mpeg" = celluloidDesktop;
    "video/quicktime" = celluloidDesktop;
    "video/webm" = celluloidDesktop;
    "video/x-matroska" = celluloidDesktop;
    "video/x-msvideo" = celluloidDesktop;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    google-chrome

    git
    gh
    github-copilot-cli
    antigravity
    nil
    wget
    ripgrep
    curl
    unzip
    htop

    vscode
    dbeaver-bin
    cartero

    celluloid
    fragments
    gimp
    inkscape

    gnome-extension-manager
    menulibre
    (tela-circle-icon-theme.override { colorVariants = [ "green" ]; })

    gnome-tweaks
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
