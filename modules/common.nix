{
  self,
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nixpkgs.nix
  ];

  boot.readOnlyNixStore = true;

  nixpkgs.overlays = builtins.attrValues self.overlays;
  nixpkgs = {
    config = {
      allowUnsupportedSystem = false;
      allowUnfree = true;
      allowBroken = false;
    };
  };

  time.timeZone = "America/Denver";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      bash
      vim
      zsh
      tmux
      gnumake
      git
      gcc
      htop
      less
      curl
      wget
      file
      watch
      sqlite
    ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
      stable.source = "${inputs.stable}";
    };
    # Shells for /etc/shells
    shells = with pkgs; [bash zsh];
  };

  # Bootstrap home-manager using system config
  #hm = import ./home-manager; # TODO: do we need to do this?
  # See https://github.com/kclejeune/system

  # Let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = {inherit self inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];
  };
}
