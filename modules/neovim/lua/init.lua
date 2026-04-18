require("keymaps")
require("opts")
require("set")
require("lz.n").load("plugins")
require("hoppe").setup({})
vim.lsp.enable({
	-- lua
	"luals",
	-- nix
	"nixld",
})
