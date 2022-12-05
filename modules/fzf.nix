{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fzf = {
    enable = true;
    # Fzf keybinds (ctrl-r history, ctrl-t file paths, alt-c cd to dir)
    enableZshIntegration = true;
  };
}
