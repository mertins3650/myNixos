return {
	"snacks.nvim",
	after = function()
		require("snacks").setup({
			picker = {
				enabled = true,
				layout = "telescope",
			},
		})

		vim.keymap.set("n", "<leader>sf", function()
			Snacks.picker.files({ hidden = true })
		end, { desc = "[F]iles" })

		vim.keymap.set("n", "<leader>gf", function()
			Snacks.picker.git_files()
		end, { desc = "Find Git Files" })

		vim.keymap.set("n", "<leader>gb", function()
			Snacks.picker.git_branches()
		end, { desc = "Git Branches" })

		vim.keymap.set("n", "<leader>gl", function()
			Snacks.picker.git_log()
		end, { desc = "Git Log" })

		vim.keymap.set("n", "<leader>gL", function()
			Snacks.picker.git_log_line()
		end, { desc = "Git Log Line" })

		vim.keymap.set("n", "<leader>gs", function()
			Snacks.picker.git_status()
		end, { desc = "Git Status" })

		vim.keymap.set("n", "<leader>gS", function()
			Snacks.picker.git_stash()
		end, { desc = "Git Stash" })

		vim.keymap.set("n", "<leader>gd", function()
			Snacks.picker.git_diff()
		end, { desc = "Git Diff (Hunks)" })

		vim.keymap.set("n", "<leader>gF", function()
			Snacks.picker.git_log_file()
		end, { desc = "Git Log File" })

		vim.keymap.set("n", "<leader>sg", function()
			Snacks.picker.grep()
		end, { desc = "[G]rep" })
	end,
}
