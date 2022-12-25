{
  config,
  pkgs,
  lib,
  new-stow,
  ...
}: {
  home.packages = with pkgs; [
    new-stow.packages.${system}.default
  ];
}
