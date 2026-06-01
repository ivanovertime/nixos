# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  pkgs-unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Keep boot menu from growing indefinitely.
  boot.loader.systemd-boot.configurationLimit = 10;

  # Enable ZRAM for better memory management
  zramSwap.enable = true;

  networking.hostName = "spica"; # Define your hostname.
  # Keep generation titles short in the boot menu.
  system.nixos.label = "Spica";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Caracas";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Required for Google Drive mounting via GNOME Online Accounts / Files.
  services.gnome.gnome-online-accounts.enable = true;
  services.gvfs.enable = true;
  services.gvfs.package = pkgs.gnome.gvfs.override {
    gnomeSupport = true;
    googleSupport = true;
  };
  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable firmware updates for supported devices.
  services.fwupd.enable = true;

  # Enable sound with pipewire.
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Required for GVFS Google Drive backend (services.gvfs.package override).
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Automated Nix store maintenance.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  # Unattended weekly system upgrades on the unstable channel.
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    channel = "https://nixos.org/channels/nixos-unstable";
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

  programs.neovim = {
    enable = true;
    defaultEditor = false;
    vimAlias = true;
    viAlias = true;
    configure = {
      customRC = ''
        " Minimal Neovim defaults without plugins.
        set number
        set relativenumber
        set mouse=a
        set clipboard=unnamedplus

        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smartindent

        set ignorecase
        set smartcase
        set incsearch
        set hlsearch

        set termguicolors
        set signcolumn=yes
        set updatetime=300
      '';
    };
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
    "audio/aac" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/flac" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/mp4" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/mpeg" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/ogg" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/wav" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/webm" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/x-flac" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/x-m4a" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/x-ms-wma" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/x-vorbis+ogg" = "io.github.celluloid_player.Celluloid.desktop";
    "audio/x-wav" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-matroska" = "io.github.celluloid_player.Celluloid.desktop";
    "video/webm" = "io.github.celluloid_player.Celluloid.desktop";
    "video/x-msvideo" = "io.github.celluloid_player.Celluloid.desktop";
    "video/quicktime" = "io.github.celluloid_player.Celluloid.desktop";
    "video/mpeg" = "io.github.celluloid_player.Celluloid.desktop";
  };

  # Force Chromium/Electron apps to use native Wayland
  # Needed for Figma on Chrome.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Web Browsers
    pkgs-unstable.google-chrome

    # Core CLI Tools
    git
    gh # GitHub CLI
    github-copilot-cli
    pkgs-unstable.antigravity
    nil # Nix LSP server for vscode-nix-ide

    wget
    ripgrep
    curl
    unzip

    # Development Environments & Editors
    pkgs-unstable.vscode # from nixos-unstable channel
    dbeaver-bin # Universal database tool
    postman # or insomnia
    slack

    # Media
    celluloid
    fragments

    # GNOME app to browse, search, and manage shell extensions
    gnome-extension-manager
    # Install the closest supported Tela Circle dark variant in current Nixpkgs
    (tela-circle-icon-theme.override { colorVariants = [ "green" ]; })

    # GNOME Tweaks is required to change the desktop icon theme
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

  # Microcode updates for AMD Ryzen

  hardware.cpu.amd.updateMicrocode = true;

  # Enable graphics/hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
