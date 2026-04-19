require("keymaps")
require("opts")
require("set")
require("lz.n").load("plugins")
require("hoppe")
vim.lsp.enable({
	-- lua
	"luals",
	-- nix
	"nixld",
})
