{ self, inputs, ... }: {
    flake.nixosModules.neovim = { pkgs, ... }: {
        programs.neovim = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim;
        };
    };

    perSystem = { pkgs, ... }: {
        packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;

            config = { wlib, pkgs, lib, ... }: {
                imports = [ wlib.wrapperModules.neovim ];
    	        specs.initLua = {
			data = null;
			before = ["MAIN_INIT"];
			config = ''
			  require('init')
			'';
		      };


                specs.general = with pkgs.vimPlugins; [
                    nvim-lspconfig
		    nvim-treesitter.withAllGrammars
		    ln-z
		    oil
		    blink-cmp
		    nvim-web-devicons
                ];

                specs.lazy = {
                    lazy = true;
                    data = with pkgs.vimPlugins; [
                        # plugins which are not loaded until you vim.cmd.packadd them ...
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
        kdePackages.qtdeclarative
        nixd
        alejandra
                ];

                settings.config_directory = ./.;
                # or lib.generators.mkLuaInline "vim.fn.stdpath('config')";
            };
        };
    };
}
