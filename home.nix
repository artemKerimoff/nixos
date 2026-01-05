{ inputs, pkgs, ... }:

{
  home.username = "artem";
  home.homeDirectory = "/home/artem";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = [
    inputs.ambxst.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
