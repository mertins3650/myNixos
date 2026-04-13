return {
	"snacks.nvim",
	after = function()
		require("snacks").setup({
			opts = {
				picker = {
					enabled = true,
					layout = "telescope",
				},
			},
			keys = {
				{
					"<leader>sf",
					function()
						Snacks.picker.files({ hidden = true })
					end,
					desc = "[F]iles",
				},
				{
					"<leader>gf",
					function()
						Snacks.picker.git_files()
					end,
					desc = "Find Git Files",
				},
				{
					"<leader>gb",
					function()
						Snacks.picker.git_branches()
					end,
					desc = "Git Branches",
				},
				{
					"<leader>gl",
					function()
						Snacks.picker.git_log()
					end,
					desc = "Git Log",
				},
				{
					"<leader>gL",
					function()
						Snacks.picker.git_log_line()
					end,
					desc = "Git Log Line",
				},
				{
					"<leader>gs",
					function()
						Snacks.picker.git_status()
					end,
					desc = "Git Status",
				},
				{
					"<leader>gS",
					function()
						Snacks.picker.git_stash()
					end,
					desc = "Git Stash",
				},
				{
					"<leader>gd",
					function()
						Snacks.picker.git_diff()
					end,
					desc = "Git Diff (Hunks)",
				},
				{
					"<leader>gf",
					function()
						Snacks.picker.git_log_file()
					end,
					desc = "Git Log File",
				},
				{
					"<leader>sg",
					function()
						Snacks.picker.grep()
					end,
					desc = "[G]rep",
				},
			},
		})
	end,
}
