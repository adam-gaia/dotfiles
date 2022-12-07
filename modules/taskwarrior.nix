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
}
