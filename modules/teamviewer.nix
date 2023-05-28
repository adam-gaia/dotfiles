{
  config,
  pkgs,
  lib,
  ...
}: {
  services.teamviewer = {
    enable = true;
  };
}
