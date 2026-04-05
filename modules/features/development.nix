

{self, input, ... }: {
  flake.nixosModules.development = { pkgs, lib, ...}: {

    environment.systemPackages = with pkgs;[
      nodejs_24
    ];
  };
}
