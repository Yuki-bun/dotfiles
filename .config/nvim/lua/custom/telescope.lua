local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fF", function()
	builtin.find_files({ hidden = true })
end, { desc = "find all files" })
vim.keymap.set("n", "<leader>ff", builtin.git_files, { desc = "find git files" })
vim.keymap.set("n", "<leader>fg", function()
	builtin.live_grep({ grep_open_files = true, additional_args = { "--hidden" } })
end, { desc = "fuzzy grep" })
vim.keymap.set("n", "<leader>fG", builtin.current_buffer_fuzzy_find, { desc = "fuzzy grep (cuurent buffer)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "find files (buffer)" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "help" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { noremap = true, desc = "find marks" })
vim.keymap.set("n", "<leader>ct", "<CMD>Telescope themes<CR>", { noremap = true, desc = "find marks" })
vim.keymap.set("n", "<leader>fc", function()
	builtin.find_files({ cwd = "~/.config/nvim" })
end, { desc = "find files (config)" })