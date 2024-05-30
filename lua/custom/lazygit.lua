-- This is not working propery
local M = {}

-- Function to get the project root directory
local function get_root()
  local cwd = vim.fn.getcwd()
  if vim.fn.isdirectory(cwd .. "/.git") == 1 then
    return cwd
  end

  local parent = vim.fn.fnamemodify(cwd, ":h")
  while parent and parent ~= cwd do
    if vim.fn.isdirectory(parent .. "/.git") == 1 then
      return parent
    end
    cwd = parent
    parent = vim.fn.fnamemodify(cwd, ":h")
  end
  return vim.loop.os_homedir()
end

-- Function to create a floating terminal
local function open_float_term(cmd, opts)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * (opts.size and opts.size.width or 0.9))
  local height = math.floor(vim.o.lines * (opts.size and opts.size.height or 0.9))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = opts.border or "rounded",
  })

  local job_id = vim.fn.termopen(cmd, {
    cwd = opts.cwd,
    env = opts.env,
    pty = true,
    width = width,
    height = height,
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
      end
    end,
    on_stderr = function(_, data, _)
      for _, line in ipairs(data) do
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
      end
    end,
    on_exit = function()
      vim.api.nvim_win_close(win, true)
    end,
  })

  vim.cmd("startinsert")

  return { buf = buf, win = win, job_id = job_id, toggle = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    else
      open_float_term(cmd, opts)
    end
  end }
end

-- Function to check clipboard with retries
local function get_relative_filepath(retries, delay)
  local relative_filepath
  for i = 1, retries do
    relative_filepath = vim.fn.getreg("+")
    if relative_filepath ~= "" then
      return relative_filepath -- Return filepath if clipboard is not empty
    end
    vim.defer_fn(function() end, delay) -- Wait before retrying
  end
  return nil -- Return nil if clipboard is still empty after retries
end

-- Function to handle editing from Lazygit
function M.lazygit_edit(original_buffer)
  local current_bufnr = vim.fn.bufnr("%")
  local channel_id = vim.fn.getbufvar(current_bufnr, "terminal_job_id")

  if not channel_id or channel_id == 0 then
    vim.notify("No terminal job ID found.", vim.log.levels.ERROR)
    return
  end

  vim.fn.chansend(channel_id, "\15") -- \15 is <c-o>
  vim.cmd("close") -- Close Lazygit

  local relative_filepath = get_relative_filepath(5, 50)
  if not relative_filepath then
    vim.notify("Clipboard is empty or invalid.", vim.log.levels.ERROR)
    return
  end

  local winid = vim.fn.bufwinid(original_buffer)

  if winid == -1 then
    vim.notify("Could not find the original window.", vim.log.levels.ERROR)
    return
  end

  vim.fn.win_gotoid(winid)
  vim.cmd("e " .. relative_filepath)
end

-- Function to start Lazygit in a floating terminal
function M.start_lazygit()
  local current_buffer = vim.api.nvim_get_current_buf()
  local float_term = open_float_term("lazygit", { cwd = get_root(), size = { width = 0.9, height = 0.9 }, border = "rounded" })

  vim.api.nvim_buf_set_keymap(
    float_term.buf,
    "t",
    "<c-e>",
    string.format([[<Cmd>lua require("custom.lazygit").lazygit_edit(%d)<CR>]], current_buffer),
    { noremap = true, silent = true }
  )
end

vim.api.nvim_set_keymap("n", "<leader>gg", [[<Cmd>lua require("custom.lazygit").start_lazygit()<CR>]], { noremap = true, silent = true })

return M

