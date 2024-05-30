local null_ls = require("null-ls")

local remove_formatter = function(formatter)
  local builtins = null_ls.builtins.formatting
  local sources = {}
  -- P(builtins)
  for key, source in pairs(builtins) do
    if key ~= formatter then
      table.insert(sources, source)
    else
      print("removed", formatter)
    end
  end
  return sources
end

vim.api.nvim_create_augroup("Invoice", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.tsx",
  group = "Invoice",
  desc = "remove prettier formatting capabilitis",
  callback = function() end,
})
