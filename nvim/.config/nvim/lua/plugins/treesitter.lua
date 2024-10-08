return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			auto_install = true,
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"tsx",
				"typescript",
				"html",
				"python",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = {
				config = {
					javascript = {
						__default = "// %s",
						jsx_element = "{/* %s */}",
						jsx_fragment = "{/* %s */}",
						jsx_attribute = "// %s",
						comment = "// %s",
					},
					typescript = { __default = "// %s", __multiline = "/* %s */" },
				},
			},
		})
	end,
}
