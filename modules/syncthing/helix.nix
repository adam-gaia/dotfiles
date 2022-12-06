{
  devices = {
    "orion" = { id = (builtins.readFile ./orion.id); };
  };

  # Share these folder from this machine to the specified devices
  #folders = {
  #  "Repo" = {
  #    path = "/home/agaia/repo"; 
  #    devices = [ "orion" ];
  #  };

  #  "Desktop" = {
  #    path = "/home/agaia/Desktop";
  #    devices = [ "orion" ];
  #  };
  #};
}
