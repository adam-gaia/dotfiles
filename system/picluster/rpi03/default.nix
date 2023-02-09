{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../k3s/agent.nix
  ];

  networking = {
    hostName = "rpi03";
  };
}
