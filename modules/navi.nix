{...}: {
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      finder = {
        command = "fzf";
      };
      shell = {
        command = "zsh";
      };
    };
  };
}
