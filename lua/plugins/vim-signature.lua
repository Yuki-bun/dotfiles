return {
	"kshenoy/vim-signature",
	config = function()
		vim.keymap.set("n", "<leader>ma", ":SignatureToggle<CR>", { noremap = true, desc = "toggle show mark" })
	end,
}
