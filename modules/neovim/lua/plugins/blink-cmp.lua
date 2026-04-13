return {
	"blink.cmp",
	lazy = false,

	after = function()
		require("blink.cmp").setup({
			keymap = { ["<C-k>"] = nil },
			snippets = { preset = "luasnip" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				trigger = { prefetch_on_insert = false },
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind" } },
					},
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
			signature = { enabled = true },
		})
	end,
}
