{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    enable = true;
    # six, packaging, pynvim, and tasklib are required for taskwiki, a vimwiki/taskwarrior integration tool
    extraPython3Packages = pyPkgs:
      with pyPkgs; [
        pynvim
        tasklib
        six
        packaging
        tasklib
        pynvim
      ];
  };

  #xdg.configFile.astronvim = {
  #  source = ../../dotfiles/astronvim;
  #  recursive = true;
  #};
}
