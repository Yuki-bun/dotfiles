local M = require("utils")
return {
	{
		"williamboman/mason.nvim",
		dependencies = { "jay-babu/mason-null-ls.nvim" },
		config = function()
			require("mason").setup()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"eslint_d",
					"prettier",
					"prettierd",
					"autoflake",
					"black",
					"isort",
					"swiftlint",
					"rustfmt",
					"sqlformat",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"jsonls",
					"html",
					"tailwindcss",
					"pyright",
					"clangd",
					"prismals",
					"rust_analyzer",
					"sqlls",
					"denols",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
			require("neodev").setup({})
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			--- @param dir string|nil
			local getPairentDir = function(dir)
				local parentDir = vim.fn.fnamemodify(dir, ":h")
				if parentDir == dir then
					return nil
				else
					return parentDir
				end
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

			local on_attach = function(client, bufnr)
				local navbuddy = require("nvim-navbuddy")
				navbuddy.attach(client, bufnr)
			end
			lspconfig.sqlls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				root_dir = function()
					local dir = vim.fn.expand("%:p:h")
					local runtime = findRuntimeType(dir)
					if runtime and runtime.type == "node" then
						return runtime.dir
					else
						return nil
					end
				end,
				single_file_support = false,
			})
			lspconfig.denols.setup({
				capabilities = capabilities,
				root_dir = function()
					local dir = vim.fn.expand("%:p:h")
					local runtime = findRuntimeType(dir)
					if runtime and (runtime.type == "deno" or runtime.type == "both") then
						return runtime.dir
					else
						return nil
					end
				end,
				single_file_support = true,
			})
			lspconfig.html.setup({})
			lspconfig.tailwindcss.setup({})
			lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.prismals.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.sourcekit.setup({ capabilities = capabilities, onattach = on_attach })
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust_analyzer"] = {
						cargo = {
							allFeatures = true,
						},
					},
				},
				lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach }),
				lspconfig.metals.setup({ capabilities = capabilities, on_attach = on_attach }),
			})

			--- @param direction '"next"'|'"prev"'
			local function goto_reference(direction)
				local bufnr = vim.api.nvim_get_current_buf()
				local params = vim.lsp.util.make_position_params()
				params.context = { includeDeclaration = true }

				vim.lsp.buf_request(bufnr, "textDocument/references", params, function(err, result, ctx, _)
					if err then
						print("Error: " .. vim.inspect(err))
						return
					end

					if not result then
						return
					end

					local references = {}
					local current_buf_uri = vim.uri_from_bufnr(bufnr)

					for _, ref in ipairs(result) do
						if ref.uri == current_buf_uri then
							table.insert(references, ref)
						end
					end

					if #references == 1 then
						return
					end

					local currentLine = params.position.line
					local currentCharacter = params.position.character
					local targetPositon = nil

					if direction == "next" then
						for _, ref in ipairs(references) do
							if
								ref.range.start.line > currentLine
								or (
									ref.range.start.line == currentLine
									and ref.range.start.character > currentCharacter
								)
							then
								targetPositon = ref
								break
							end
						end
						if not targetPositon then
							targetPositon = references[1]
						end
					elseif direction == "prev" then
						for i = #references, 1, -1 do
							local ref = references[i]
							if
								ref.range.start.line < currentLine
								or (
									ref.range.start.line == currentLine
									and ref.range["end"].character < currentCharacter
								)
							then
								targetPositon = ref
								break
							end
						end
						if not targetPositon then
							targetPositon = references[#references]
						end
					end

					if targetPositon then
						local targetLine = targetPositon.range.start.line + 1 -- Adjusting for 1-based indexing
						local targetChar = targetPositon.range.start.character
						vim.api.nvim_win_set_cursor(0, { targetLine, targetChar })
					end
				end)
			end
			function GoToNextReference()
				goto_reference("next")
			end

			function GoToPrevReference()
				goto_reference("prev")
			end

			-- Keybindings
			vim.api.nvim_set_keymap(
				"n",
				"<C-n>",
				":lua GoToNextReference()<CR>",
				{ noremap = true, silent = true, desc = "go to next reference" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<C-p>",
				":lua GoToPrevReference()<CR>",
				{ noremap = true, silent = true, desc = "go to prev reference" }
			)
		end,
	},
	{
		"mrcjkb/haskell-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		version = "^2", -- Recommended
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
		init = function()
			vim.g.haskell_tools = {}
		end,
	},
}
