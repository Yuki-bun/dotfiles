-- lsp keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, desc = "hover" })
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { noremap = true, desc = "go to definitions" })
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { noremap = true, desc = "go to refernces" })

vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { noremap = true, desc = "format" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, desc = "code actions" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { noremap = true, desc = "shoe diagnostics" })
