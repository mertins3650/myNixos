return {
	"miniharp.nvim",
	enabled = true,
	after = function()
		require("miniharp").setup({})
		vim.keymap.set("n", "<leader>m", require("miniharp").toggle_file, { desc = "miniharp: toggle file mark" })
		vim.keymap.set("n", "<C-n>", require("miniharp").next, { desc = "miniharp: next file mark" })
		vim.keymap.set("n", "<C-p>", require("miniharp").prev, { desc = "miniharp: prev file mark" })
		vim.keymap.set("n", "<leader>l", require("miniharp").show_list, { desc = "miniharp: list marks" })
	end,
}
