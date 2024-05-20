vim.cmd("set expandtab")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")
vim.cmd("set tabstop=2")

vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.opt.number = true

-- Function to get the current file path
local function get_filepath()
  return vim.fn.expand("%:p")
end

-- Set the winbar with an autocommand to update it on specific events
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "BufWritePost" }, {
  pattern = "*",
  callback = function()
    vim.wo.winbar = get_filepath()
  end,
})
