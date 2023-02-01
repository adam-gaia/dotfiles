{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../defaut.nix
  ];

  networking = {
    hostName = "rpi04"; # Define your hostname.
  };
}
