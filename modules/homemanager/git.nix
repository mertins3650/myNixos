{ lib, ... }:
{
    flake.homeModules.git = {
  programs = {
    git = {
      enable = true;
      userName = "Simon Mertins";
      userEmail = "simon@mertins.net";
    };
};
};
}
