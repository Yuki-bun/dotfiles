vim.api.nvim_create_augroup("nvim-con-lua", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = "nvim-con-lua",
	desc = "auto save",
	callback = function()
		print("formatting")
		vim.lsp.buf.format()
	end,
})
