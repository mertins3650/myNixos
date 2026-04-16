return {
	"rose-pine",
	colorscheme = "rose-pine-moon",
	require("rose-pine").setup({
		disable_background = true,
		styles = {
			italic = false,
		},
	}),
	vim.cmd.colorscheme("rose-pine-moon"),
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" }),
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }),
}
