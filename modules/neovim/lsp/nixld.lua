return {
	cmd = { "nixd" },
	filetypes = { "nix" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "alejandra" },
			},
		},
	},
}
