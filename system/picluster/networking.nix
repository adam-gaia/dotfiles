{
  config,
  lib,
  pkgs,
  hostName,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22]; # ssh
    };
    networkmanager.enable = true;
  };
}
