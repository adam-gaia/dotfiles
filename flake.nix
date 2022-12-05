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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nonstdlib = { url = "gitlab:adam_gaia/nonstdlib/test"; };
    shim = { url = "gitlab:adam_gaia/shim"; };
    git-track-repos = { url = "gitlab:adam_gaia/git-track-repos"; };
    conda-flake = { url = "gitlab:adam_gaia/conda-flake"; };
  };

  outputs =
    inputs@{ self
    , darwin
    , home-manager
    , flake-utils
    , nonstdlib
    , nixos-hardware
    , shim
    , git-track-repos
    , conda-flake
    , ...
    }:
    let
      inherit (flake-utils.lib) eachSystemMap; 

      isDarwin = system:
        (builtins.elem system inputs.nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";
      defaultSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
       ];

      mkDarwinConfig =
        { system ? "x86_64-darwin"
        , nixpkgs ? inputs.nixpkgs
        , stable ? inputs.stable
        , baseModules ? [
            home-manager.nixosModules.home-manager
            ./modules/darwin
          ]
        , extraModules ? [ ]
        ,
        }:
        inputs.darwin.lib.darwinSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = { inherit self inputs nixpkgs; };
        };

      mkNixosConfig =
        { system ? "x86_64-linux"
        , nixpkgs ? inputs.nixpkgs
        , stable ? inputs.stable
        , baseModules ? [
            home-manager.nixosModules.home-manager
            ./modules/nixos
          ]
        , extraModules ? [ ]
        ,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = { inherit self inputs nixpkgs; };
        };

      mkHomeConfig =
        { username
        , system
        , term ? "xterm-256color"
        , nixpkgs ? inputs.nixpkgs 
        , stable ? inputs.stable
        , baseModules ? [
          ./modules/home-manager
          {
            home = {
              inherit username;
              homeDirectory = "${homePrefix system}/${username}";
              sessionVariables = {
                NIX_PATH = "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH:+:}$NIX_PATH";
              };
            };
          }
        ]
        , extraModules ? [ ]
        ,
        }:
          inputs.home-manager.lib.homeManagerConfiguration rec {
            pkgs = import nixpkgs {
              inherit system;
              #config = { allowUnfree = true; }; # TODO: remove - set elsewhere?
              overlays = builtins.attrValues self.overlays;
            };
            extraSpecialArgs = { inherit self inputs nixpkgs system term shim git-track-repos conda-flake; };
              modules = baseModules ++ extraModules;
            };

      mkChecks = { arch, os, username ? "agaia", }: {
        "${arch}-${os}" = {
          "${username}_${os}" = (if os == "darwin" then
            self.darwinConfigurations
          else
            self.nixosConfigurations)
            ."${username}@${arch}-${os}".config.system.build.toplevel;
          "${username}_home" =
            self.homeConfigurations."${username}@${arch}-${os}".activationPackage;
          devShell = self.devShells."${arch}-${os}".default;
        };
      };
    in
    {
      checks = { } // (mkChecks {
        arch = "x86_64";
        os = "darwin";
      }) // (mkChecks {
        arch = "x86_64";
        os = "linux";
      });

      #// (mkChecks {
      #  arch = "aarch64";
      #  os = "darwin";
      #}) // (mkChecks {
      #  arch = "aarch64";
      #  os = "linux";
      #}) 

      nixosConfigurations = {
        "agaia@x86_64-linux" = mkNixosConfig {
          system = "x86_64-linux";
          extraModules = [ ./system/orion ./modules/persistence ./modules/gnome ];
        };
        #"nixbox@x86_64-linux" = mkNixosConfig {
        #  system = "x86_64-linux";
        #  extraModules = [ ./system/nixbox ./modules/persistence ./modules/gnome ];
        #};
      };

      darwinConfigurations = {
        "agaia@x86_64-darwin" = mkDarwinConfig {
          system = "x86_64-darwin";
          extraModules = [ ./system/helix ];
        };
      };

      homeConfigurations = {
        # TODO: figure out how to inherit system here so we dont have to have the duplicate
        "agaia@x86_64-linux" = mkHomeConfig {
          username = "agaia";
          system = "x86_64-linux";
          extraModules = [
            ./users/agaia
            ./modules/systemd-user-services.nix
            ./modules/proton-packages.nix
            ./modules/conda-flake.nix
            ./modules/git-track-repos.nix
            ./modules/shim.nix
            ./modules/firefox.nix
            ./modules/chromium.nix
            ./modules/offlineimap.nix
            ./modules/dconf.nix
	    ./modules/ansible.nix
          ];
        };
        "agaia@x86_64-darwin" = mkHomeConfig {
          username = "agaia";
          system = "x86_64-darwin";
          extraModules = [./users/agaia];
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
              nonstdlib.defaultPackage.${system}
              git-crypt
              nixfmt
              pre-commit
              shellcheck
              shfmt
              dconf2nix
            ];
            commands = [{
              name = "sysdo";
              package = self.packages.${system}.sysdo;
              category = "utilities";
              help = "perform actions on this repository";
            }];
          };
        });

      packages = eachSystemMap defaultSystems (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };
        in rec {
          sysdo = pkgs.writeShellApplication {
            name = "sysdo";
            text = (builtins.readFile ./scripts/sysdo);
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
          stable = import inputs.stable { system=prev.system; };
          small = import inputs.small { system = prev.system; };
        };
        extraPackages = final: prev: {
          sysdo = self.packages.${prev.system}.sysdo;
        };
        devshell = inputs.devshell.overlay;
      };

    };
}
