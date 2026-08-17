{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

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
