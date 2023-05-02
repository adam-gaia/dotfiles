{
  config,
  pkgs,
  lib,
  text-art,
  system,
  ...
}: {
  xdg.dataFile.text-art = {
    source = text-art.defaultPackage.${system};
    recursive = true;
  };
}
