{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    extra-substituters = [ "https://herdr.cachix.org" ];
    extra-trusted-public-keys = [ "herdr.cachix.org-1:3nH7IStRsS0ASfdonA0DCRR2ZrSCeWitZ7Kwew0cR4I=" ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    openssl
    zlib
    curl
    glib
    nss
    nspr
    expat
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    libdrm
    mesa
    gtk3
    pango
    cairo
    alsa-lib
    libGL
    libpulseaudio
    dbus
    atk
    at-spi2-core
    cups
    fontconfig
    freetype
    pixman
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
    flake = "github:ivanovertime/nixos";
    allowReboot = false;
  };
}
