return {
	"miniharp.nvim",
	after = function()
		local miniharp = require("miniharp")
		-- set keymaps after the module is loaded
		vim.keymap.set("n", "<leader>m", miniharp.toggle_file, { desc = "miniharp: toggle file mark" })
		vim.keymap.set("n", "<C-n>", miniharp.next, { desc = "miniharp: next file mark" })
		vim.keymap.set("n", "<C-p>", miniharp.prev, { desc = "miniharp: prev file mark" })
		vim.keymap.set("n", "<leader>l", miniharp.show_list, { desc = "miniharp: list marks" })
	end,
}
