{config, pkgs, lib, conda-flake, ...}:
{
  home.packages = with pkgs; [
    conda-flake.packages.${system}.default
  ]; 
}
