-- lsp keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, desc = "hover" })
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { noremap = true, desc = "go to definitions" })
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { noremap = true, desc = "go to refernces" })

vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { noremap = true, desc = "format" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, desc = "code actions" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { noremap = true, desc = "shoe diagnostics" })

vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, desc = "delete buffer" })

vim.keymap.set("n", "<leader>|", "<CMD>vsplit<CR>", { noremap = true, desc = "split vertically" })
vim.keymap.set("n", "<leader>-", "<CMD>split<CR>", { noremap = true, desc = "split horizontally" })

vim.keymap.set("n", "<M-h>", "<c-w>5<")
vim.keymap.set("n", "<M-l>", "<c-w>5>")
vim.keymap.set("n", "<M-k>", "<C-W>+")
vim.keymap.set("n", "<M-j>", "<C-W>-")
