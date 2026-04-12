{
    inputs,
    self,
    ...
}: {
    flake.modules.neovim.main = {
        config,
        wlib,
        lib,
        pkgs,
        ...
    }: {
        options = {
            dynamicMode = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                    If true, use impure config instead for fast edits

                    Both versions of the package may be installed simultaneously
                '';
            };

            initLua = lib.mkOption {
                type = wlib.types.stringable;
                default = ./nvim;
            };

            dynamicInitLua = lib.mkOption {
                type = lib.types.either wlib.types.stringable lib.types.luaInline;
                default = lib.generators.mkLuaInline
                    "vim.uv.os_homedir() .. '/myNixos/modules/neovim/nvim'";
            };
        };

        config = {
            settings.config_directory =
                if config.dynamicMode
                then config.dynamicInitLua
                else config.initLua;

            extraPackages = [
                pkgs.ffmpeg-full
                pkgs.wl-clipboard
            ];

            specs.init = {
                data = null;
                before = ["MAIN_INIT"];
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
                    pkgs.vimPlugins.mini-files
                ];
            };
        };
    };

    perSystem = {
        pkgs,
        self',
        ...
    }: {
        packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;
            dynamicMode = true;
            imports = [
                self.modules.neovim.main
                self.modules.neovim.allServers
            ];
        };
    };
}
