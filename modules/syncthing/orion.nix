{ config, pkgs, lib, ...}:
{
  services.syncthing = {
    enable = true;
    guiAddress = "localhost:8384";

    dataDir = "/home/agaia/Documents";
    # TODO: the config dir must persist or this device will regen an ID. Find a way to do that better
    configDir = "/home/agaia/.config/syncthing";

    user = "agaia";
    group = "users";

    # Ignore settings set in the web UI - this file is the only source of truth
    overrideDevices = true; 
    overrideFolders = true;

    devices = {
      helix = { id = (builtins.readFile ./helix.id); };
    };

    # Take these folders on the host and put them 
    folders = {
      "Documents" = {
        path = "/home/agaia/Documents";
        ignorePerms = false;
        devices = ["helix"];
      };
    };
  };

  # Open ports for syncthing
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
