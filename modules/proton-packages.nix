{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    protonvpn-gui
    protonvpn-cli
  ];
}
