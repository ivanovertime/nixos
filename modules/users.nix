{ pkgs-unstable, ... }:

{
  users.users.ivan = {
    isNormalUser = true;
    description = "Ivan Alvarez";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  # Home Manager is loaded as a NixOS module via the flake.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit pkgs-unstable; };
    users.ivan = import ../home;
  };
}
