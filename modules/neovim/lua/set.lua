vim.opt.runtimepath:prepend(vim.fn.expand("~/Work/hoppe.nvim/"))
local augroup = vim.api.nvim_create_augroup
local MertinsGroup = augroup("Mertins", {})

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufWritePre" }, {
	group = MertinsGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("BufEnter", {
	group = MertinsGroup,
	callback = function()
		pcall(vim.cmd.colorscheme, "rose-pine-moon")
	end,
})

autocmd("LspAttach", {
	group = MertinsGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
	end,
})
