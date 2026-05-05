return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml" },
	root_dir = { "rust-project.json" },
	settings = {
		formatting = {
			command = { "rustfmt" },
		},
	},
}
