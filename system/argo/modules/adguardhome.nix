{
  pkgs,
  lib,
  config,
  ...
}: {
  services = {
    adguardhome = {
      enable = true;
      mutableSettings = true;
      settings = {
        bindHost = "";
        bindPort = 3000;
        schema_version = pkgs.adguardhome.schema_version;
      };
    };
  };
}
