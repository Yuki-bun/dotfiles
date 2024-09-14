return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			columns = { "icon" },
			view_options = { show_hidden = true },
			win_options = {
				winbar = "%{v:lua.require('oil').get_current_dir()}",
			},
		})

		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { noremap = true, desc = "edit dir" })
	end,
}
