{
  self,
  inputs,
  config,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";
    sessionVariables = {
      # Tell firefox to use wayland features
      MOZ_ENASBLE_WAYLAND = 1;
    };
    # Add ~/.local/bin to the path
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };
  programs = {
    home-manager = {
      enable = true;
      path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
    };
  };

  xdg.enable = true;
  xdg.configFile = {
    "nixpkgs/config.nix".source = ../nix-config.nix;
  };
}
