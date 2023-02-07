{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./common.nix];
  networking.firewall.allowedTCPPorts = [6443];
  services.k3s = {
    role = "server";
    extraFlags = "--tls-san 192.168.1.227 --disable servicelb --node-taint node-role.kubernetes.io/master=true:NoSchedule";
    # --write-kubeconfig-mode 644 --disable local-storage --disable traefik --disable coredns --disable metrics-server
    # --cluster-cidr=10.69.0.0/16 --service-cidr=10.96.0.0/16 --cluster-dns=10.96.0.10
  };
}
