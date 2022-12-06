{config, pkgs, lib, ...}:
{
  services.syncthing = {
    enable = true;

    dataDir = "/home/agaia/Documents"; # Default folder for new synced folders 
    configDir = "/home/agaia/.config/syncthing"; # Folder for Syncthing's settings and keys
    # TODO: Backup the configDir? If this gets lost, we have to get a new key to the peer devices

    user = "agaia";
    group = "users";

    openDefaultPorts = true;
    guiAddress = "localhost:8384";

    # Override options set through the web UI. This config should be the only source of truth
    overrideDevices = true;
    overrideFolders = true;
  }; 
}
