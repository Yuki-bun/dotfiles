return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "tsserver", "jsonls", "html", "tailwindcss", "pyright" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
			require("neodev").setup({})
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				local navbuddy = require("nvim-navbuddy")
				navbuddy.attach(client, bufnr)
			end
			lspconfig.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.tsserver.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.html.setup({})
			lspconfig.tailwindcss.setup({})
			lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
		end,
	},
}
