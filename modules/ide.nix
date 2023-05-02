{
  config,
  pkgs,
  lib,
  ide,
  system,
  ...
}: {
  home.packages = [
    ide.packages.${system}.default
  ];
}
