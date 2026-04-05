
{self, input, ... }: {
  flake.nixosModules.neovim = { pkgs, lib, ...}: {

    environment.systemPackages = with pkgs;[
      neovim
      lua
      hererocks
    ];
  };
}
