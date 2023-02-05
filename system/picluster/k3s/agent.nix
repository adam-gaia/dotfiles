{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./common.nix];
  services = {
    k3s = {
      role = "agent";
      tokenFile = ./server_token.key;
      serverAddr = "rpi01:6443";
    };
  };
}
