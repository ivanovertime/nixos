{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "ivan" ];
    auto-optimise-store = true;

    # 16 GB / 8 cores: the defaults swap this box to death.
    max-jobs = 4;
    cores = 8;
    extra-substituters = [ "https://herdr.cachix.org" ];
    extra-trusted-public-keys = [ "herdr.cachix.org-1:3nH7IStRsS0ASfdonA0DCRR2ZrSCeWitZ7Kwew0cR4I=" ];
  };

  programs.nix-ld.enable = true;
  # safety net for ad-hoc binaries; `ldd` names what to add
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    openssl
    curl
    zlib
    expat
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # store is optimised on write; no periodic timer needed

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = "github:ivanovertime/nixos";
    allowReboot = false;
  };
}
