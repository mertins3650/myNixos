return {
	"mini.statusline",
	after = function()
		require("mini.statusline").setup({
			use_icons = vim.g.have_nerd_font,
			section_location = function()
				return "%2l:%-2v"
			end,
		})
	end,
}
