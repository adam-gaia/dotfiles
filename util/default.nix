{
  self,
  inputs,
  nixpkgs,
  home-manager,
  homePrefix,
  fortune-quotes,
  conda-flake,
  deploy-rs,
  text-art,
  settings-script,
  format-aliases,
  ...
}: rec {
  isDarwin = system: (builtins.elem system inputs.nixpkgs.lib.platforms.darwin);

  mkDeployNode = name: system: ip: {
    hostname = ip;
    # ssh in as agaia but run 'nixos-rebuild switch' as root
    sshUser = "agaia";
    user = "root";
    profiles = {
      system = {
        path =
          deploy-rs.lib."${system}".activate.nixos
          self.nixosConfigurations."${name}";
      };
      user = {
        user = "agaia";
        profilePath = "/nix/var/nix/profiles/per-user/agaia/home-manager";
        path =
          deploy-rs.lib.${system}.activate.custom
          self.homeConfigurations."agaia-rpi".activationPackage "$PROFILE/activate";
      };
    };
  };

  mkDeployNodeX86 = name: system: ip: {
    hostname = ip;
    # ssh in as agaia but run 'nixos-rebuild switch' as root
    sshUser = "agaia";
    user = "root";
    profiles = {
      system = {
        path =
          deploy-rs.lib."${system}".activate.nixos
          self.nixosConfigurations."${name}";
      };
      user = {
        user = "agaia";
        profilePath = "/nix/var/nix/profiles/per-user/agaia/home-manager";
        path =
          deploy-rs.lib.${system}.activate.custom
          self.homeConfigurations."agaia-argo".activationPackage "$PROFILE/activate";
      };
    };
  };

  mkDarwinConfig = {
    system ? "x86_64-darwin",
    nixpkgs ? inputs.nixpkgs,
    baseModules ? [
      home-manager.darwinModules.home-manager
      ../modules/darwin
    ],
    extraModules ? [],
  }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      modules = baseModules ++ extraModules;
      specialArgs = {inherit self inputs nixpkgs;};
    };

  mkNixosConfig = {
    system ? "x86_64-linux",
    nixpkgs ? inputs.nixpkgs,
    baseModules ? [
      home-manager.nixosModules.home-manager
      ../modules/nixos
    ],
    extraModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = baseModules ++ extraModules;
      specialArgs = {inherit self inputs nixpkgs settings-script system;};
    };

  mkHomeConfig = {
    username,
    system,
    term ? "xterm-256color",
    nixpkgs ? inputs.nixpkgs,
    stable ? inputs.stable,
    baseModules ? [
      ../modules/home-manager
      {
        home = {
          inherit username;
          homeDirectory = "${homePrefix system}/${username}";
          sessionVariables = {
            NIX_PATH = "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH:+:}$NIX_PATH";
          };
        };
      }
    ],
    extraModules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;}; # TODO: remove - set elsewhere?
        overlays = builtins.attrValues self.overlays;
      };
      extraSpecialArgs = {inherit self inputs nixpkgs system term conda-flake fortune-quotes text-art format-aliases;};
      modules = baseModules ++ extraModules;
    };
}
