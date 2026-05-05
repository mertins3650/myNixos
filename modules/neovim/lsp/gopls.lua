return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "go.sum", "go.work" },
	settings = {
		formatting = {
			command = { "gofmt" },
		},
	},
}
