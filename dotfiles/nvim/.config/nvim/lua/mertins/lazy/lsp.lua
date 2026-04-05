return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "/home/simonm/.local/share/LuaAddons/love2d/library" },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("K", function()
						vim.lsp.buf.hover()
					end, "Hover")
					map("<leader>vrr", vim.lsp.buf.rename, "[r]ename")
					map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })
					map("<leader>vd", vim.diagnostic.open_float, "[d]iagnostics")
					map("<leader>vws", vim.lsp.buf.workspace_symbol, "[w]orkspace [s]ymbol")
					map("C-h", vim.lsp.buf.signature_help, "Signature Help", "i")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local servers = {
				gopls = {},
				ts_ls = {},
				bashls = {},
				templ = {},
				html = {},
				pyright = {},
				tailwindcss = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								globals = { "love" },
							},
							workspace = {
								library = { "/home/simonm/.local/share/LuaAddons/love2d/library" },
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
			}

			local tools = {
				"ruff",
				"stylua",
				"biome",
				"jq",
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, tools)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
