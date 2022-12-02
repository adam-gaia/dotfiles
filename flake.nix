{
  description = "My system configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
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
    , nixpkgs
    , nixpkgs-unstable
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
      defaultSystems =
        [ "x86_64-linux" "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      mkDarwinConfig =
        { system ? "x86_64-darwin"
        , nixpkgs ? inputs.nixpkgs
        , nixpkgs-unstable ? inputs.nixpkgs-unstable
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
        , nixpkgs-unstable ? inputs.nixpkgs-unstable
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
        , system ? "x86_64-linux"
        , term ? "xterm-256color"
        , nixpkgs ? inputs.nixpkgs 
        , nixpkgs-unstable ? inputs.nixpkgs-unstable
        , unstable-pkgs ? import nixpkgs-unstable { inherit system; config = {allowUnfree = true;};}
        , baseModules ? [ ]
        , extraModules ? [ ]
        ,
        }:
          inputs.home-manager.lib.homeManagerConfiguration rec {
          inherit system;
          inherit username;
          homeDirectory = "${homePrefix system}/${username}";
          pkgs = import nixpkgs {
            inherit system;
            config = {allowUnfree = true;};
            overlays = builtins.attrValues self.overlays;
          };
          extraSpecialArgs = { inherit self inputs system term pkgs unstable-pkgs nixpkgs nixpkgs-unstable shim git-track-repos conda-flake; };
          configuration = {
            imports = baseModules ++ extraModules;
          }; 
        };

      mkChecks = { arch, os, username ? "agaia", }: {
        "${arch}-${os}" = {
          "${username}_${os}" = (if os == "darwin" then
            self.darwinConfigurations
          else
            self.nixosConfigurations)."${username}@${arch}-${os}".config.system.build.toplevel;
          "${username}_home" =
            self.homeConfigurations."${username}@${arch}-${os}".activationPackage;
          devShell = self.devShells."${arch}-${os}".default;
        };
      };
    in
    {
    #  checks = { } // (mkChecks {
    #    arch = "aarch64";
    #    os = "darwin";
    #  }) // (mkChecks {
    #    arch = "x86_64";
    #    os = "darwin";
    #  }) // (mkChecks {
    #    arch = "aarch64";
    #    os = "linux";
    #  }) // (mkChecks {
    #    arch = "x86_64";
    #    os = "linux";
    #  });

      nixosConfigurations = {
        "orion" = mkNixosConfig {
          extraModules = [ ./system/orion ./modules/persistence ./modules/gnome ];
        };
        "nixbox" = mkNixosConfig {
          extraModules = [ ./system/nixbox ./modules/persistence ./modules/gnome ];
        };
      };

      darwinConfigurations = {
        "helix" = mkDarwinConfig { extraModules = [ ./system/helix ]; };
      };

      homeConfigurations = {
        "agaia" = mkHomeConfig {
          username = "agaia";
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
        in
        rec {
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
          nixpkgs-unstable =
            import inputs.nixpkgs-unstable { system = prev.system; };
          nixpkgs-small = import inputs.nixpkgs-small { system = prev.system; };
        };
        extraPackages = final: prev: {
          sysdo = self.packages.${prev.system}.sysdo;
        };
        devshell = inputs.devshell.overlay;
      };

    };
}
