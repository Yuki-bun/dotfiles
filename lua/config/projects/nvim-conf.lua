vim.api.nvim_create_augroup("auto-format", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = "auto-format",
  desc = "auto save",
  callback = function()
    vim.lsp.buf.format()
  end,
})
