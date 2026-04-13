require("keymaps")
require("opts")
require("set")
require("lz.n").load("plugins")
vim.lsp.enable({
	-- lua
	"luals",
	-- nix
	"nixld",
})
