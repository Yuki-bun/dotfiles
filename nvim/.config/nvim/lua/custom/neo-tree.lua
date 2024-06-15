local utils = require("utils")

local tree = require("neo-tree.command")
vim.keymap.set("n", "<leader>fe", function()
	tree.execute({ toggle = true, dir = utils.get_lsp_root_dir() })
end, { noremap = true, desc = "neo-tree (Root dir)"})

vim.keymap.set("n", "<leader>fE", function()
	tree.execute({ toggle = true, dir = vim.g.initial_cwd })
end, { noremap = true, desc = "neo-tree (Cwd)" })
