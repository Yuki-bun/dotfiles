-- lsp keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, desc = "hover" })
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { noremap = true, desc = "go to definitions" })
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { noremap = true, desc = "go to refernces" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { noremap = true, desc = "keymaps" })

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { noremap = true, desc = "rename variable" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { noremap = true, desc = "format" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, desc = "code actions" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { noremap = true, desc = "show diagnostics" })
vim.keymap.set("n", "<leader>cD", function()
	vim.diagnostic.open_float()
	vim.diagnostic.open_float()
end, { noremap = true, desc = "show and move into diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, desc = "next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, desc = "prev diagnostic" })

vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, desc = "delete buffer" })

vim.keymap.set("n", "<leader>|", "<CMD>vsplit<CR>", { noremap = true, desc = "split vertically" })

vim.keymap.set("n", "<leader>-", "<CMD>split<CR>", { noremap = true, desc = "split horizontally" })

vim.keymap.set("n", "<M-h>", "<c-w>5<")
vim.keymap.set("n", "<M-l>", "<c-w>5>")
vim.keymap.set("n", "<M-k>", "<C-W>+")
vim.keymap.set("n", "<M-j>", "<C-W>-")

vim.keymap.set("n", "bp", ":bprevious<CR>", { desc = "previous buffer", silent = true })
vim.keymap.set("n", "bn", ":bnext<CR>", { desc = "next buffer", silent = true })

vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "turn off hightlight" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers["signature_help"], {
	border = "single",
	close_events = { "CursorMoved", "BufHidden" },
})
vim.keymap.set({ "i", "n" }, "<c-s>", vim.lsp.buf.signature_help)
