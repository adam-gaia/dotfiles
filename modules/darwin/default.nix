{ config, pkgs, home-manager, ... }:
{
  imports = [
    ../common.nix
  ];

  nix = {
    nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
    extraOptions = ''
      extra-platforms = x86_64-darwin
    '';
  };

}
