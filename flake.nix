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

    herdr-nix = {
      url = "github:herdrdev/herdr-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://herdr.cachix.org" ];
    extra-trusted-public-keys = [ "herdr.cachix.org-1:3nH7IStRsS0ASfdonA0DCRR2ZrSCeWitZ7Kwew0cR4I=" ];
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      git-hooks,
      herdr-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      herdr = herdr-nix.packages.${system}.default;

      hosts = [ "spica" ];

      # COSMIC packages from unstable; stable pins older releases.
      cosmicNames = builtins.filter (
        n: builtins.match "^(cosmic|xdg-desktop-portal-cosmic).*" n != null
      ) (builtins.attrNames pkgs-unstable);

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
                    # stable's COSMIC module still uses the pre-rename name.
                    cosmic-applibrary = pkgs-unstable.cosmic-app-library;

                    # no local patch — upstream prunes its dangling symlinks.
                    tela-circle-green = prev.tela-circle-icon-theme.override {
                      colorVariants = [ "green" ];
                    };

                    herdr = herdr;
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
        ];
        shellHook = hooks.shellHook;
      };

      checks.${system} = {
        spica-system = (mkSystem "spica").config.system.build.toplevel;
        spica-home = (mkSystem "spica").config.home-manager.users.ivan.home.activationPackage;
      };

      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkSystem;
    };
}
