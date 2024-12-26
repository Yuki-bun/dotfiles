local M = {}

-- Function to get the root directory from the active LSP client excluding null-ls
function M.get_lsp_root_dir()
	local clients = vim.lsp.get_active_clients()
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local root_dir = nil

	for _, client in pairs(clients) do
		if
			client.name ~= "null-ls"
			and client.config.filetypes
			and vim.fn.index(client.config.filetypes, buf_ft) ~= -1
		then
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

function _G.P(t, indent)
	indent = indent or ""
	local next_indent = indent .. "  "
	if type(t) ~= "table" then
		print(indent .. tostring(t))
		return
	end
	print(indent .. "{")
	for k, v in pairs(t) do
		local key = string.format("%q", k)
		if type(v) == "table" then
			print(next_indent .. key .. ": ")
			_G.P(v, next_indent)
		else
			local value = type(v) == "string" and string.format("%q", v) or tostring(v)
			print(next_indent .. key .. ": " .. value .. ",")
		end
	end
	print(indent .. "}")
end

function M.tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

return M
