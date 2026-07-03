# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/refs/heads/release-26.05.tar.gz";
in
{
  imports = [
    ./hardware-configuration.nix
    "${home-manager}/nixos"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  # AMD Barcelo (Vega) APU + dual display (eDP + HDMI).
  # sg_display=0 avoids scatter-gather display buffers that glitch on APUs
  # using system RAM as VRAM. dcdebugmask=0x10 was REMOVED: it disables pipe
  # split and made the dcn21 secondary-pipe path (the one that warns/resets) worse.
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

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

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-store
    cosmic-player
  ];

  services.gvfs.enable = true;
  services.accounts-daemon.enable = true;
  programs.dconf.enable = true;

  services.system76-scheduler.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-cosmic
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

  environment.sessionVariables = {
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

  environment.systemPackages = with pkgs; [
    google-chrome

    git
    gh
    opencode

    nil
    wget
    ripgrep
    curl
    unzip
    btop

    vscode
    dbeaver-bin

    gimp
    loupe
    inkscape
    obs-studio
    celluloid
    transmission_4-gtk

    (tela-circle-icon-theme.override { colorVariants = [ "green" ]; })
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMonoNL Nerd Font Mono"
        "JetBrainsMonoNL Nerd Font"
        "JetBrainsMono Nerd Font Mono"
        "JetBrainsMono Nerd Font"
      ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}
