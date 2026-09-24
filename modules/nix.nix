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
    extra-substituters = [ "https://herdr.cachix.org" ];
    extra-trusted-public-keys = [ "herdr.cachix.org-1:3nH7IStRsS0ASfdonA0DCRR2ZrSCeWitZ7Kwew0cR4I=" ];
  };

  programs.nix-ld.enable = true;
  # Minimal CLI-class core for foreign binaries. No installed program uses
  # nix-ld today — this is a safety net for ad-hoc downloads. Add libraries
  # here when a binary complains about a missing .so; `ldd` on it names them.
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

  # Store paths are optimised on write (auto-optimise-store), so no periodic
  # optimise timer is needed on top.

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = "github:ivanovertime/nixos";
    allowReboot = false;
  };
}
