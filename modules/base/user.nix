{self, input, ... }: {
  flake.nixosModules.user = { pkgs, lib, ...}: {
home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.simonm = {
      imports = [
        self.homeModules.homeuser
      ];
};
  home.username = "simonm";
  home.homeDirectory = "/home/simonm";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
};
}
