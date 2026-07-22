{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.homemanager = {pkgs, ...}: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.extraSpecialArgs = {
      inherit inputs;
    };

    users.users.simonm = {
      isNormalUser = true;
      description = "Simon Mertins";
      extraGroups = ["networkmanager" "wheel" "docker"];
      shell = pkgs.zsh;
    };
    home.pointerCursor.enable = true;
    programs.zsh.enable = true;

    home-manager.users.simonm.imports = [
      self.homeModules.simonm
    ];
  };
}
