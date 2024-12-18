return {
	"github/copilot.vim",
	config = function()
		vim.g.copilot_no_tab_map = true

		vim.keymap.set(
			"i",
			"<C-g>",
			'copilot#Accept("<CR>")',
			{ silent = true, expr = true, script = true, replace_keycodes = false }
		)
	end,
}
