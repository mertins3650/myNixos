return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			telemtry = {
				enable = false,
			},
			workspace = {
				checkThidParty = "Apply",
			},
		},
	},
}
