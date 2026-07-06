{
  description = "NixOS configuration for Spica";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cursor-clip = {
      url = "github:Sirulex/cursor-clip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      cursor-clip,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.spica = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit cursor-clip pkgs-unstable; };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/spica
        ];
      };
    };
}
