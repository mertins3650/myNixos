vim.pack.add({
	{
		src = "https://github.com/vieitesss/miniharp.nvim",
		version = vim.version.range("v*"), -- latest stable release
		-- version = 'nightly', -- latest changes from main
	},
})

require("miniharp").setup({
	autoload = true, -- load marks for this cwd on startup (default: true)
	autosave = true, -- save marks for this cwd on exit (default: true)
	show_on_autoload = false, -- show popup list after a successful autoload (default: false)
	vim.keymap.set("n", "<leader>m", require("miniharp").toggle_file, { desc = "miniharp: toggle file mark" }),
	vim.keymap.set("n", "<C-n>", require("miniharp").next, { desc = "miniharp: next file mark" }),
	vim.keymap.set("n", "<C-p>", require("miniharp").prev, { desc = "miniharp: prev file mark" }),
	vim.keymap.set("n", "<leader>l", require("miniharp").show_list, { desc = "miniharp: list marks" }),
})
