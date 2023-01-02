{
  config,
  pkgs,
  lib,
  ...
}: {
  homebrew.brews = [
    {
      name = "syncthing";
      start_service = true;
      restart_service = "changed";
      link = true;
    }
  ];
}
