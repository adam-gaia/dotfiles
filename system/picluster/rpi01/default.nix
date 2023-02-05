{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../k3s/server.nix
  ];

  networking = {
    hostName = "rpi01";
  };
}
