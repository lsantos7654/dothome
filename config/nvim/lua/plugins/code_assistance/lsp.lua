return {
	"neovim/nvim-lspconfig",
	cmd = { "LspInfo", "LspStart" },
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },
	},
	config = function()
		-- Enhanced diagnostics configuration
		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				prefix = "●",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Customize diagnostic signs
		local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		-- Custom server configs
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		-- Enable all servers (binaries provided by Nix extraPackages)
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("pyright")
		vim.lsp.enable("clangd")
		vim.lsp.enable("jsonls")
		vim.lsp.enable("bashls")
		vim.lsp.enable("eslint")
		vim.lsp.enable("html")
		vim.lsp.enable("nil_ls")
		vim.lsp.enable("ts_ls")
	end,
}
