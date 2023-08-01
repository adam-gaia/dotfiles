{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    options = ["--cmd" "j"]; # Use 'j' to jump instead of 'z'
  };
}
