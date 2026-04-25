require("oil").setup({
	view_options = { show_hidden = true },
	default_file_explorer = true,
})
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>")
