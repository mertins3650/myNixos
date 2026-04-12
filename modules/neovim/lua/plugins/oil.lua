return {
	"oil-nvim",
	cmd = "Oil",
	after = function()
		require("oil").setup({
			view_options = { show_hidden = true },
			default_file_explorer = true,
		})
	end,
	vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "[E]explorer" }),
}
