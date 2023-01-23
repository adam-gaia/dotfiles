{
  config,
  pkgs,
  lib,
  ...
}: {
  # TODO: backup taskwarrior database? (defaults to '$XDG_DATA_HOME/task')
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-256";
    #config = {
    #  uda = {
    #    todoist_id = {
    #      type = string;
    #      
    #    };
    #    todoist_user_id = {
    #      type = string;
    #    };
    #  };
    #};
  };
  home.packages = with pkgs; [
    taskopen
    taskwarrior-tui
    timewarrior
    python310Packages.bugwarrior
    # six, pynvim, and tasklib are required for taskwiki, a vimwiki/taskwarrior integration tool
    python310Packages.pynvim
    python310Packages.tasklib
    python310Packages.six
  ];
  # TODO: backup timewarrior data like how taskwarrior data is backedup
  xdg.configFile = {
    taskopen = {
      source = ../dotfiles/taskopen;
      recursive = true;
    };
    titwsync = {
      source = ../dotfiles/titwsync;
      recursive = true;
    };
  };
}
