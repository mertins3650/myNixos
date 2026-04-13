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

  perSystem = {pkgs, ...}: {
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
        mini-icons
        snacks-nvim
        mini-ai
        mini-surround
        mini-statusline
        luasnip
        conform-nvim
        rose-pine
        nvim-treesitter.withAllGrammars
        lz-n
        oil-nvim
        blink-cmp
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
