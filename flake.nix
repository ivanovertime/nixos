{
  description = "NixOS configuration for Spica";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      git-hooks,
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

      # All COSMIC packages from unstable — stable (26.05) pins older releases
      # (e.g. cosmic-comp 1.2.0 vs 1.5.0). Kept self-maintaining so new cosmic
      # packages are picked up automatically.
      cosmicNames = builtins.filter (
        n: builtins.match "^(cosmic|xdg-desktop-portal-cosmic).*" n != null
      ) (builtins.attrNames pkgs-unstable);

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
            {
              nixpkgs.overlays = [
                (
                  final: prev:
                  (nixpkgs.lib.genAttrs cosmicNames (n: pkgs-unstable.${n}))
                  // {
                    # Stable 26.05's COSMIC module still references the pre-rename
                    # name, which unstable carries as a warn-alias ("has been
                    # renamed..."). Map it straight to the real package to keep
                    # eval silent.
                    cosmic-applibrary = pkgs-unstable.cosmic-app-library;
                  }
                )
              ];
            }
            home-manager.nixosModules.home-manager
            ./hosts/${host}
          ];
        };

      hooks = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt = {
            enable = true;
            entry = "${pkgs.nixfmt}/bin/nixfmt";
            files = "\\.nix$";
          };
        };
      };
    in
    {
      formatter.${system} = pkgs.writeShellScriptBin "nixfmt-flake" ''
        set -euo pipefail
        cd "''${PRJ_ROOT:-$(pwd)}"
        exec ${pkgs.nixfmt}/bin/nixfmt "$@" $(${pkgs.git}/bin/git ls-files '*.nix')
      '';

      gitHooks = hooks;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixfmt
          pkgs.statix
          pkgs.alejandra
          pkgs.nixos-rebuild
        ];
        shellHook = hooks.shellHook;
      };

      checks.${system} = {
        spica-system = (mkSystem "spica").config.system.build.toplevel;
        spica-home = homeConfig.activationPackage;
      };

      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkSystem;
    };
}
