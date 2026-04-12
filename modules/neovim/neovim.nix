{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.neovim = {pkgs, ...}: {
    programs.neovim = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim;
    };
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;

      specs.initLua = {
        data = null;
        before = ["MAIN_INIT"];
        config = ''
          require('init')
        '';
      };

      specs.general = with pkgs.vimPlugins; [
        conform-nvim
        rose-pine
        colorful-menu-nvim
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        lz-n
        oil-nvim
        lspkind-nvim
        blink-cmp
        nvim-web-devicons
      ];
      specs.lazy = {
        lazy = true;
        data = with pkgs.vimPlugins; [
          lazydev-nvim
        ];
      };

      info = {
        values = "for lua";
        which = "will be placed in the generated info plugin for access";
      };

      extraPackages = with pkgs; [
        lua-language-server
        astro-language-server
        typescript-language-server
        rust-analyzer
        nixd
        alejandra

        # formatters
        prettier
        stylua
        go
        rustfmt
      ];

      settings.config_directory = ./.;
    };
  };
}
