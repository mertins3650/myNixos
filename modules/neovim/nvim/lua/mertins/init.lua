require("mertins.set")
require("mertins.remap")
require("mertins.lazy_init")

local augroup = vim.api.nvim_create_augroup
local MertinsGroup = augroup("mertins", {})

local autocmd = vim.api.nvim_create_autocmd

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd({ "BufWritePre" }, {
	group = MertinsGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})
