{
  pkgs,
  config,
  lib,
  ...
}: {
  networing = {
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
