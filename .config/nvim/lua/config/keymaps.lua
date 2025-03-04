-- lsp keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, desc = "hover" })
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { noremap = true, desc = "go to definitions" })
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { noremap = true, desc = "go to refernces" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { noremap = true, desc = "keymaps" })
vim.keymap.set("n", "<space>fV", ":Telescope file_browser<CR>")
-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>fv", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { noremap = true, desc = "rename variable" })
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format()
end, { noremap = true, desc = "format" })
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

vim.keymap.set({ "i", "s" }, "jj", "<ESC>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "turn off hightlight" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers["signature_help"], {
	border = "single",
	close_events = { "CursorMoved", "BufHidden" },
})
vim.keymap.set({ "i", "n" }, "<c-s>", vim.lsp.buf.signature_help)

vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set("v", "<leader>c", '"*y<CR>', { noremap = true, desc = "copy to clipboard", silent = true })

local ls = require("luasnip")

vim.keymap.set({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
	ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

vim.keymap.set(
	"n",
	"<leader><leader>s",
	"<cmd>source ~/.config/nvim/lua/custom/snippets.lua<CR>",
	{ desc = "source snippets" }
)

require("custom.snippets")

vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
