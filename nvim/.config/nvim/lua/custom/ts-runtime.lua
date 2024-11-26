--- @param dir string|nil
local getPairentDir = function(dir)
	local parentDir = vim.fn.fnamemodify(dir, ":h")
	if parentDir == dir then
		return nil
	else
		return parentDir
	end
end

local getCurrentDir = function()
	return vim.fn.expand("%:p:h")
end

--- @param dir string
--- @return nil | { dir: string, type: 'node'|'deno'|'both' }
local function findRuntimeType(dir)
	local package_json = dir .. "/package.json"
	local deno_json = dir .. "/deno.json"
	local hasPackageJson = vim.fn.filereadable(package_json) == 1
	local denoJson = vim.fn.filereadable(deno_json) == 1

	if hasPackageJson and denoJson then
		return {
			dir = dir,
			type = "both",
		}
	elseif hasPackageJson then
		return {
			dir = dir,
			type = "node",
		}
	elseif denoJson then
		return {
			dir = dir,
			type = "deno",
		}
	end

	local parent_dir = getPairentDir(dir)
	if parent_dir == nil then
		return nil
	end
	return findRuntimeType(parent_dir)
end

--- @return table<string, true>
local function findAllConfigFiels()
	local dir = vim.fn.expand("~/.local/share/nvim/tsRuntimes")
	local files = {}

	local fd = vim.loop.fs_scandir(dir)
	while fd do
		local name, type = vim.loop.fs_scandir_next(fd)
		if not name then
			break
		end

		if type == "file" then
			local withoutLua = string.gsub(name, ".txt", "")
			files[withoutLua] = true
		end
	end

	return files
end

--- @param dir string
--- @param configFilestable table<string, true>
--- @param foundConfigDirHahes table<number, string>
--- @return table<number, string>
local function findConfigFiles(dir, configFilestable, foundConfigDirHahes)
	local hashedDir = vim.fn.sha256(dir)
	if configFilestable[hashedDir] then
		table.insert(foundConfigDirHahes, dir)
	end
	local parentDir = getPairentDir(dir)

	if parentDir == nil then
		return foundConfigDirHahes
	else
		return findConfigFiles(parentDir, configFilestable, foundConfigDirHahes)
	end
end

--- @param dirHash string
--- @return 'deno' | 'node' | nil
local function readConfigFile(dirHash)
	local dir = vim.fn.expand("~/.local/share/nvim/tsRuntimes/" .. dirHash .. ".txt")
	local file = io.open(dir, "r")
	if file == nil then
		return nil
	end
	local content = file:read("*l")
	file:close()
	if content == "deno" then
		return "deno"
	elseif content == "node" then
		return "node"
	else
		return nil
	end
end

--- @param dir string
--- @return table<number, {dir: string, type: 'deno'|'node'} | nil>
local function findRuntimeConfigs(dir)
	local allConfigFiles = findAllConfigFiels()
	local configFiles = findConfigFiles(dir, allConfigFiles, {})
	local runtimeConfigs = {}
	for _, configDir in ipairs(configFiles) do
		local dirHash = vim.fn.sha256(configDir)
		local runtime = readConfigFile(dirHash)
		if runtime ~= nil then
			table.insert(runtimeConfigs, {
				dir = configDir,
				type = runtime,
			})
		end
	end

	return runtimeConfigs
end

--- @param dir string
local function findRuntimeConfig(dir)
	local runtimeConfigs = findRuntimeConfigs(dir)
	if #runtimeConfigs == 0 then
		return nil
	end
	return runtimeConfigs[1]
end

--- @param dir string
--- @param runTime 'deno' | 'node'
local function writeConfig(dir, runTime)
	local dirHash = vim.fn.sha256(dir)
	local path = vim.fn.expand("~/.local/share/nvim/tsRuntimes/" .. dirHash .. ".txt")
	local file = io.open(path, "w")
	if file == nil then
		print("Failed to open file")
		return
	end
	file:write(runTime)
	file:close()
end

--- @param callback fun(selected: 'deno' | 'node')
local function getRuntimeSelection(callback)
	--- @type 'deno' | 'node'
	local selected
	vim.ui.select({ "deno", "node" }, {
		prompt = "Select runtime",
	}, function(_selected)
		selected = _selected
		callback(selected)
	end)

	return selected
end

local function main()
	if vim.g.ts_runtime_config == nil then
		local currentDir = getCurrentDir()
		local detectedRuntime = findRuntimeType(currentDir)
		if detectedRuntime ~= nil and detectedRuntime.type ~= "both" then
			vim.g.ts_runtime_config = detectedRuntime.type
		else
			local runtimeConfig = findRuntimeConfig(currentDir)
			if runtimeConfig ~= nil then
				vim.g.ts_runtime_config = runtimeConfig.type
			else
				getRuntimeSelection(function(selected)
					vim.g.ts_runtime_config = selected
					writeConfig(currentDir, selected)
				end)
			end
		end
	end

	local null_ls = require("null-ls")
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	if vim.g.ts_runtime_config == "deno" then
		lspconfig.denols.setup({ capabilities = capabilities })
	else
		lspconfig.ts_ls.setup({ capabilities = capabilities })
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.prettierd,
			},
		})
	end
end

_G.ts_runtime_once_called = _G.ts_runtime_once_called or false
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		if not _G.ts_runtime_once_called then
			main()
			_G.ts_runtime_once_called = true
			vim.cmd(":edit")
		end

		vim.api.nvim_buf_create_user_command(0, "TsRuntimeConfigFiles", function()
			local configs = findRuntimeConfigs(getCurrentDir())
			for _, config in ipairs(configs) do
				print(config.dir)
			end
		end, {})

		vim.api.nvim_buf_create_user_command(0, "DeleteTsRuntimeConfigFiles", function()
			local configs = findRuntimeConfigs(getCurrentDir())
			--- @type table<number, string>
			local configDirs = {}
			for _, config in ipairs(configs) do
				table.insert(configDirs, config.dir)
			end
			vim.ui.select(configDirs, {
				prompt = "delete ts runtime config files",
			}, function(dir)
				local dirHash = vim.fn.sha256(dir)
				local path = vim.fn.expand("~/.local/share/nvim/tsRuntimes/" .. dirHash .. ".txt")
				vim.fn.delete(path)
			end)
		end, {})
	end,
})
