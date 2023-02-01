{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../default.nix
  ];

  deployment.targetHost = "192.168.1.156";
  deployment.targetUser = "agaia";

  networking = {
    hostName = "rpi03"; # Define your hostname.
  };
}
