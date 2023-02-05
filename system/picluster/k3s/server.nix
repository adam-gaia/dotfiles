{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./common.nix];
  networking.firewall.allowedTCPPorts = [6443];
  services.k3s.role = "server";
}
