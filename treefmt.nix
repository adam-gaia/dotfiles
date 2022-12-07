{
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    black.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    stylua.enable = true;
  };
  settings.formatter = {
    stylua.options = ["--indent-type" "Spaces"];
  };
}
