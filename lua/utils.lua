local M = {}


-- Function to get the root directory from the active LSP client excluding null-ls
function M.get_lsp_root_dir()
  local clients = vim.lsp.get_active_clients()
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local root_dir = nil

  for _, client in pairs(clients) do
    if client.name ~= "null-ls" and client.config.filetypes and vim.fn.index(client.config.filetypes, buf_ft) ~= -1 then
      root_dir = client.config.root_dir
      break
    end
  end

  if root_dir then
    return root_dir
  else
    return vim.fn.getcwd()
  end
end

return M
