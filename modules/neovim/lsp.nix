{ self, ... }:
{
    flake.modules.neovim.plugins = { pkgs, ... }: {
        specs.plugins = {
            data = [
                pkgs.vimPlugins.lz-n
                pkgs.vimPlugins.plenary-nvim
                pkgs.vimPlugins.nvim-lspconfig
                pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            ];
        };
    };

    flake.modules.neovim.lua = { pkgs, ... }: {
        extraPackages = [
            pkgs.lua-language-server
        ];

        specs.lua = {
            data = [
                pkgs.vimPlugins.blink-cmp
            ];
            config = ''
                vim.lsp.enable("lua_ls")
            '';
        };
    };

    flake.modules.neovim.ts = { pkgs, ... }: {
        extraPackages = [
            pkgs.typescript-language-server
        ];

        specs.ts = {
            data = [ ];
            config =
                # lua
                ''
                    vim.lsp.config("ts_ls", {
                        settings = {
                            suggestionActions = {
                                enabled = false
                            }
                        }
                    })
                    vim.lsp.enable("ts_ls")
                '';
        };
    };

    flake.modules.neovim.rust = { pkgs, ... }: {
        extraPackages = [
            pkgs.rust-analyzer
        ];

        specs.rust = {
            data = [ ];
            config =
                # lua
                ''
                    vim.lsp.enable("rust_analyzer")
                '';
        };
    };

    flake.modules.neovim.nix = { pkgs, ... }: {
        extraPackages = [
            pkgs.nixd
            pkgs.alejandra
        ];

        specs.nix = {
            data = [ ];
            config =
                # lua
                ''
                    vim.lsp.config("nixd", {
                        cmd = { "nixd" },
                        settings = {
                            nixd = {
                                nixpkgs = {
                                    expr = "import <nixpkgs> { }",
                                },
                                formatting = {
                                    command = { "alejandra" },
                                },
                            },
                        },
                    })
                    vim.lsp.enable("nixd")
                '';
        };
    };

    flake.modules.neovim.mdx = { pkgs, ... }: {
        extraPackages = [
            pkgs.mdx-language-server
        ];

        specs.mdx = {
            data = [ ];
            config =
                # lua
                ''
                    vim.filetype.add({
                        extension = {
                            mdx = "mdx",
                        },
                    })
                    vim.lsp.enable("mdx_analyzer")
                '';
        };
    };

    flake.modules.neovim.lsp = {
        imports = [
            self.modules.neovim.plugins
            self.modules.neovim.lua
            self.modules.neovim.ts
            self.modules.neovim.rust
            self.modules.neovim.nix
            self.modules.neovim.mdx
        ];
    };
}
