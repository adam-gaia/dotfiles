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
  };
  home.packages = with pkgs; [
    taskopen
    taskwarrior-tui
    timewarrior
  ];
  # TODO: backup timewarrior data like how taskwarrior data is backedup
  xdg.configFile = {
    taskopen = {
      source = ../dotfiles/taskopen;
      recursive = true;
    };
  };
}
