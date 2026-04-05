
{self, input, ... }: {
  flake.nixosModules.neovim = { pkgs, lib, ...}: {

    environment.systemPackages = with pkgs;[
      vimPlugins.nvim-treesitter
      neovim
      tree-sitter
      lua
    ];
  };
}
