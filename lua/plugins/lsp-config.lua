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
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.tsserver.setup({})
			lspconfig.html.setup({})
			lspconfig.tailwindcss.setup({})
			lspconfig.pyright.setup({})
		end,
	},
}
