if true then
  return {}
end

return {
  "vim-test/vim-test",
  config = function()
    vim.keymap.set("n", "<leader>tT", ":TestNearest<CR>")
    vim.keymap.set("n", "<leader>tt", ":TestFile<CR>")
    vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>")
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")
    vim.keymap.set("n", "<leader>tg", ":TestVisit<CR>")
  end,
}
