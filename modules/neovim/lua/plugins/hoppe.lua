return {
	"hoppe.nvim",
	enabled = true,
	after = function()
		require("hoppe").setup({})
	end,
}
