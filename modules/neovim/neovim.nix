{
    inputs,
    self,
    ...
}: let
    mainModule = { pkgs, ... }: {
        config = {
            settings.config_directory = ./nvim;

            extraPackages = [
                pkgs.ffmpeg-full
                pkgs.wl-clipboard
            ];

            specs.init = {
                data = null;
                before = [ "MAIN_INIT" ];
                config = "require('init')";
            };

            specs.plugins = {
                data = [
                    pkgs.vimPlugins.plenary-nvim
                    pkgs.vimPlugins.nvim-lspconfig
                    pkgs.vimPlugins.nvim-treesitter.withAllGrammars

                    pkgs.vimPlugins.nvim-web-devicons
                    pkgs.vimPlugins.blink-cmp

                    pkgs.vimPlugins.snacks-nvim
                    pkgs.vimPlugins.oil-nvim
                    pkgs.vimPlugins.lualine-nvim
                    pkgs.vimPlugins.luasnip
                ];
            };

            specs.lazyPlugins = {
                lazy = true;
                data = [
                    pkgs.vimPlugins.lazydev-nvim
                    pkgs.vimPlugins.nvim-autopairs
                    pkgs.vimPlugins.mini-files
                ];
            };
        };
    };
in {
    flake.modules.neovim.main = mainModule;

    flake.nixosModules.neovim = { pkgs, ... }: {
        programs.neovim = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
        };
    };

    perSystem = { pkgs, ... }: {
        packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;
            imports = [
                mainModule
                self.modules.neovim.allServers
            ];
        };
    };
}
