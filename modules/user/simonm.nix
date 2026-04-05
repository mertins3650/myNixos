{
  system,
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  flake.homeModules.myHome = {
  home.username = "simonm";
  home.homeDirectory = "/home/simonm";
  home.stateVersion = "25.11";

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      clean.dates = "daily";
      flake = "/home/simonm/NixOS-config/";
    };
    git = {
      enable = true;
      userName = "Simon Mertins";
      userEmail = "simon@mertins.net";
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  programs.home-manager.enable = true;
};
}
