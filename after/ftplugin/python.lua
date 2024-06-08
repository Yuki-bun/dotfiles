print("configd")
vim.keymap.set(
	"n",
	"<C-n>",
	":lua GoToNextReference()<CR>",
	{ noremap = true, silent = true, desc = "go to next reference", buffer = 0 }
)
vim.keymap.set(
	"n",
	"<C-p>",
	":lua GoToPrevReference()<CR>",
	{ noremap = true, silent = true, desc = "go to prev reference", buffer = 0 }
)
