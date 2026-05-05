require("keymaps")
require("opts")
require("set")
-- Lazy plugins
require("lz.n").load("plugins")
-- Plugins
require("p-oil")
require("p-snacks")
-- LSP
vim.lsp.enable({
	-- lua
	"luals",
	-- nix
	"nixld",
	-- go
	"gopls",
	-- rust
	"rust_analyzer",
})
