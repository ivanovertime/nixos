{
  description = "NixOS configuration for Spica";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cursor-clip = {
      url = "github:Sirulex/cursor-clip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, cursor-clip, ... }:
    {
      nixosConfigurations.spica = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit cursor-clip; };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/spica
        ];
      };
    };
}
