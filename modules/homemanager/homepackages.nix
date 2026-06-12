{...}: {
  flake.homeModules.homepackages = {pkgs, ...}: {
    home.packages = with pkgs; [
      shared-mime-info
      xdg-utils
    ];
  };
}
