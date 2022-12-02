{config, pkgs, lib, ...}:
{
  programs.offlineimap = {
    # 'accounts.email.<name>.offlineimap.enable=true' is not creating the config file. Need to enable here for config. Home-manager bug?
    enable = true;
  };
}
