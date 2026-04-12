{ pkgs, ... }:
{
    flake.homeModules.neovim = { pkgs, ... }: {
        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;

            extraPackages = [
                pkgs.lua-language-server
                pkgs.typescript-language-server
                pkgs.rust-analyzer
                pkgs.nixd
                pkgs.alejandra
                pkgs.mdx-language-server
            ];

            plugins = with pkgs.vimPlugins; [
                plenary-nvim
                nvim-lspconfig
                nvim-treesitter.withAllGrammars
                blink-cmp
            ];

            extraLuaConfig = ''
                vim.filetype.add({
                    extension = {
                        mdx = "mdx",
                    },
                })

                vim.lsp.enable("lua_ls")

                vim.lsp.config("ts_ls", {
                    settings = {
                        suggestionActions = {
                            enabled = false
                        }
                    }
                })
                vim.lsp.enable("ts_ls")

                vim.lsp.enable("rust_analyzer")

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

                vim.lsp.enable("mdx_analyzer")
            '';
        };
    };
}
