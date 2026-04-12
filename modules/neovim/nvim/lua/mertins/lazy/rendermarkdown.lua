return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim", -- if you use the mini.nvim suite
		-- 'echasnovski/mini.icons' or 'nvim-tree/nvim-web-devicons' can be used instead
	},
	---@module 'render-markdown'
	---@type render.md.UserConfig
	config = function()
		require("render-markdown").setup({
			completions = { lsp = { enabled = true } },
		})

		vim.keymap.set("n", "<leader>tm", "<CMD>RenderMarkdown toggle<CR>", { desc = "[t]toggle [M]arkdown" })
	end,
}
