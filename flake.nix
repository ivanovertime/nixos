{
  description = "NixOS configuration for Spica";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      hosts = [ "spica" ];

      homeConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgs-unstable; };
        modules = [ ./home ];
      };

      mkSystem =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs-unstable; };
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/${host}
          ];
        };
    in
    {
      formatter.${system} = pkgs.writeShellScriptBin "nixfmt-flake" ''
        set -euo pipefail
        cd "''${PRJ_ROOT:-$(pwd)}"
        exec ${pkgs.nixfmt}/bin/nixfmt "$@" $(${pkgs.git}/bin/git ls-files '*.nix')
      '';

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixfmt
          pkgs.statix
          pkgs.alejandra
          pkgs.nixos-rebuild
        ];
      };

      checks.${system} = {
        spica-system = (mkSystem "spica").config.system.build.toplevel;
        spica-home = homeConfig.activationPackage;
      };

      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkSystem;
    };
}
