return {
	"hoppe.nvim",
	cmd = "Hoppe", -- optional command to trigger
	after = function()
		require("hoppe").setup({})
	end,
}
