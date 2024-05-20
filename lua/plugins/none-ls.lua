return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		vim.lsp.buf.format({ timeout_ms = 2000 })

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.eslint_d,
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.code_actions.eslint_d,
				null_ls.builtins.formatting.autoflake,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
			},
		})
	end,
}
