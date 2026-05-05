return {
	cmd = { "rust_analyser" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml" },
	settings = {
		formatting = {
			command = { "rustfmt" },
		},
	},
}
