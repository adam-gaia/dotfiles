{
  config,
  pkgs,
  lib,
  ...
}: {
  home = {
    sessionVariables = {
      EDITOR = "vim";
      PAGER = "less";
    };

    packages = with pkgs; [
      neofetch
      less
      tree
      rsync
      ripgrep
      lsd
      fd
    ];
  };

  programs = {
    command-not-found.enable = true;
    htop.enable = true;
    man.enable = true;
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      completionInit = "autoload -Uz compinit && compinit";
    };
  };
}
