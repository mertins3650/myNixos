return {
    "conform-nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    after = function()
        require("conform").setup({
            notify_on_error = true,

            format_on_save = function(bufnr)
                local disable_filetypes = {
                    c = true,
                    cpp = true,
                }

                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    lsp_format_opt = "never"
                else
                    lsp_format_opt = "fallback"
                end

                return {
                    timeout_ms = 500,
                    lsp_format = lsp_format_opt,
                }
            end,

            formatters_by_ft = {
                python = { "ruff" },
                lua = { "stylua" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                go = { "gofmt" },
                html = { "prettier" },
                astro = { "prettier" },
                json = { "jq" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                rust = { "rustfmt" },
		nix = { "alejandra" },
            },
        })
    end,

    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
}
