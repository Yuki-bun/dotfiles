return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()

			vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", { noremap = true, desc = "preview hunk" })
			vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { noremap = true, desc = "reset hunk" })
			vim.keymap.set("n", "<leader>gn", ":Gitsigns next_hunk<CR>", { noremap = true, desc = "next hunk" })
			vim.keymap.set("n", "<leader>gp", ":Gitsigns prev_hunk<CR>", { noremap = true, desc = "prev hunk" })
			vim.keymap.set("n", "<leader>gRR", ":Gitsigns reset_buffer<CR>", { noremap = true, desc = "reset buffer" })
		end,
	},
	{
		"f-person/git-blame.nvim",
		config = function()
			require("gitblame").setup({ enabled = false })
			vim.keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", { noremap = true, desc = "toggle git blame" })
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			if vim.fn.executable("nvr") == 1 then
				vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
			end
		end,
	},
}
