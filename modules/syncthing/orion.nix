{config, pkgs, lib, ...}:
{
  # Open ports for syncthing TODO: darwin equivalent?
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
}
