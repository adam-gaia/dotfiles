{ config, pkgs, unstable-pkgs, ... }:
let
  packages = with pkgs; [
    neovim
    unstable-pkgs.bat
    unstable-pkgs.ripgrep
    unstable-pkgs.fd
  ];
in
{
	programs = {
	  # Let home manager install and enable itself
	  home-manager.enable = true;
	  zsh.enable = true;
	  direnv = {
	    enable = true;
	    enableZshIntegration = true;
	    nix-direnv.enable = true;
	  };
	  git = {
	    enable = true;
	  };
	  fzf = {
	    enable = true;
	    enableZshIntegration = true;
	  };
	};
	nixpkgs.config.allowUnfree = true;
	home.packages = packages;
}