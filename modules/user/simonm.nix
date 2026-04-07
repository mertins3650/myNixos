{
  system,
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  flake.homeModules.homeuser = {
  home.username = "simonm";
  home.homeDirectory = "/home/simonm";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
};
}
