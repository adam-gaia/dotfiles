{
  description = "My system configs";

  nixConfig = {
    allowUnfree = true;
  };

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    devshell = {
      url = "github:numtide/devshell";
    };
    nonstdlib = {
      url = "gitlab:adam_gaia/nonstdlib/test";
    };
    #shim = {
    #  url = "github:adam-gaia/shim";
    #};
    git-track-repos = {
      url = "gitlab:adam_gaia/git-track-repos";
    };
    conda-flake = {
      url = "gitlab:adam_gaia/conda-flake";
    };
    new-stow = {
      url = "github:adam-gaia/new-stow";
    };
    ind = {
      url = "github:adam-gaia/ind";
    };
    cbtr = {
      url = "github:adam-gaia/cbtr";
    };
    build-img = {
      url = "github:adam-gaia/nixos-docker-sd-image-builder";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    nix-serve-ng.url = "github:aristanetworks/nix-serve-ng";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , darwin
    , home-manager
    , flake-utils
    , nonstdlib
    , nixos-hardware
    , #shim,
      git-track-repos
    , conda-flake
    , new-stow
    , ind
    , cbtr
    , build-img
    , deploy-rs
    , treefmt-nix
    , ...
    }:
    let
      inherit (flake-utils.lib) eachSystemMap;

      util = import ./util {
        inherit
          self
          inputs
          nixpkgs
          home-manager
          homePrefix
          #shim

          git-track-repos
          new-stow
          ind
          cbtr
          conda-flake
          deploy-rs
          ;
      };

      homePrefix = system:
        if util.isDarwin system
        then "/Users"
        else "/home";

      defaultSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      # Checks taken from deploy-rs docs
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      nixosConfigurations = {
        "orion" = util.mkNixosConfig {
          system = "x86_64-linux";
          extraModules = [
            ./system/orion
            ./modules/persistence
            ./modules/desktop
            ./modules/parted.nix
            ./modules/syncthing/orion.nix
            ./modules/wireguard
          ];
        };
        "rpi01" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./system/picluster
            ./system/picluster/rpi01
          ];
        };
        "rpi02" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./system/picluster
            ./system/picluster/rpi02
          ];
        };
        "rpi03" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./system/picluster
            ./system/picluster/rpi03
          ];
        };
        "rpi04" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./system/picluster
            ./system/picluster/rpi04
          ];
        };
        "nixbox" = util.mkNixosConfig {
          system = "x86_64-linux";
          extraModules = [ ./system/nixbox ./modules/persistence ./modules/gnome ];
        };
      };

      darwinConfigurations = {
        "helix" = util.mkDarwinConfig {
          system = "x86_64-darwin";
          extraModules = [
            ./system/helix
            ./modules/homebrew.nix
            ./modules/syncthing/helix.nix
          ];
        };
      };

      homeConfigurations = {
        # TODO: figure out how to inherit system here so we dont have to have the duplicate
        "agaia@x86_64-linux" = util.mkHomeConfig {
          username = "agaia";
          system = "x86_64-linux";
          extraModules = [
            ./users/agaia
            ./modules/systemd-user-services.nix
            ./modules/proton-packages.nix
            ./modules/conda-flake.nix
            ./modules/git-track-repos.nix
            ./modules/ind.nix
            ./modules/cbtr.nix
            #./modules/shim.nix
            ./modules/new-stow.nix
            ./modules/firefox.nix
            ./modules/chromium.nix
            ./modules/offlineimap.nix
            ./modules/dconf.nix
            ./modules/ansible.nix
          ];
        };
        "agaia@x86_64-darwin" = util.mkHomeConfig {
          username = "agaia";
          system = "x86_64-darwin";
          extraModules = [ ./users/agaia ];
        };
        "agaia-rpi" = util.mkHomeConfig {
          username = "agaia";
          system = "aarch64-linux";
          extraModules = [ ./users/agaia-rpi ];
        };
      };

      devShells = eachSystemMap defaultSystems (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };
        in
        {
          default = pkgs.devshell.mkShell {
            packages = with pkgs; [
              nonstdlib.defaultPackage."${system}"
              git-crypt
              nixfmt
              pre-commit
              shellcheck
              shfmt
              dconf2nix
              #rpi-imager
              deploy-rs
              kubectl
              kubernetes-helm-wrapped
              build-img.defaultPackage."${system}"
              deploy-rs.defaultPackage."${system}"
              (treefmt-nix.lib.mkWrapper pkgs (import ./treefmt.nix))
            ];
            commands = [
              {
                name = "sysdo";
                package = self.packages.${system}.sysdo;
                category = "utilities";
                help = "perform actions on this repository";
              }
            ];
          };
        });

      packages = eachSystemMap defaultSystems (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };
        in
        rec {
          sysdo = pkgs.writeShellApplication {
            name = "sysdo";
            text = builtins.readFile ./scripts/sysdo;
          };
        });

      apps = eachSystemMap defaultSystems (system: rec {
        sysdo = {
          type = "app";
          program = "${self.packages.${system}.sysdo}/bin/sysdo";
        };
        default = sysdo;
      });

      overlays = {
        channels = final: prev: {
          # Expose other channels via overlays
          stable = import inputs.stable { system = prev.system; };
          small = import inputs.small { system = prev.system; };
        };
        extraPackages = final: prev: {
          sysdo = self.packages.${prev.system}.sysdo;
        };
        devshell = inputs.devshell.overlay;
      };

      deploy = {
        nodes = {
          #orion = util.mkDeployNode "orion" "x86_64-linux" "localhost";
          rpi01 = util.mkDeployNode "rpi01" "aarch64-linux" "192.168.1.226";
          rpi02 = util.mkDeployNode "rpi02" "aarch64-linux" "192.168.1.136";
          rpi03 = util.mkDeployNode "rpi03" "aarch64-linux" "192.168.1.156";
          rpi04 = util.mkDeployNode "rpi04" "aarch64-linux" "192.168.1.144";
        };
      };
    };
}
