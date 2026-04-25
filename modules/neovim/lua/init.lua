require("keymaps")
require("opts")
require("set")
-- Lazy plugins
require("lz.n").load("plugins")
-- Plugins
require("oil")
require("snacks")
-- LSP
vim.lsp.enable({
	-- lua
	"luals",
	-- nix
	"nixld",
})
