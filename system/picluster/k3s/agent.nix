{
  config,
  lib,
  pkgs,
  k3sPort,
  ...
}: {
  imports = [./common.nix];
  services = {
    k3s = {
      role = "agent";
      tokenFile = ./server_token.key;
      serverAddr = "https://rpi01:6443";
    };
  };
}
