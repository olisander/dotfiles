---@class ComposerInformation
---@field composer_file string
---@field namespace_prefix string
---@field namespace_path string

---@class ComposerFileContent
---@field autoload ComposerFileAutoload | nil

---@class ComposerFileAutoload
---@field ["psr-4"] table<string, string> | nil

local setup_composer_information = function()
	---@type table<number, string>
	local composer_file_search_result = vim.fs.find({ "composer.json" }, { upward = false })
	if next(composer_file_search_result) ~= nil then
		local composer_file = composer_file_search_result[1]
		local composer_string = vim.fn.readfile(composer_file)

		---@type ComposerFileContent
		local composer_table = vim.json.decode(table.concat(composer_string, "\n"))

		local autoload = composer_table["autoload"]
		if autoload == nil then
			return
		end

		local psr4 = autoload["psr-4"]
		if psr4 == nil then
			return
		end

		for k, v in pairs(psr4) do
			local namespace_prefix = k
			local namespace_path = v

			---@type ComposerInformation
			return {
				composer_file = composer_file,
				namespace_prefix = namespace_prefix,
				namespace_path = namespace_path,
			}
		end
	end
end

local composer_info = nil

local namespace_query = [[
(namespace_definition)
 name: (namespace_name) @namespace_name
]]

local class_query = [[
(class_declaration name: (name) @class_name)
]]

local fix_php_file = function(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "php", {})
	local tree = parser:parse()[1]
	local root = tree:root()

	local ts_namespace_query = vim.treesitter.query.parse("php", namespace_query)
	for id, node in ts_namespace_query:iter_captures(root, bufnr, 0, -1) do
		local name = ts_namespace_query.captures[id]
		if name == "namespace_name" then
			local start_row, start_col, end_row, end_col = node:range()

			if composer_info == nil then
				return
			end

			local calculated_namespace = vim.fn
				.expand("%:p:h")
				:sub(#composer_info.composer_file:match("(.*/)") + 1)
				:gsub(composer_info.namespace_path, composer_info.namespace_prefix)
				:gsub("/", "\\")

			-- to get old namespace
			-- local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
			-- local old_namespace = lines[1]:sub(start_col, end_col)
			vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { calculated_namespace })
		end
	end
	local ts_class_query = vim.treesitter.query.parse("php", class_query)
	for id, node in ts_class_query:iter_captures(root, bufnr, 0, -1) do
		local name = ts_class_query.captures[id]
		if name == "class_name" then
			local start_row, start_col, end_row, end_col = node:range()

			local buf_file_name = vim.fn.expand("%:t:r")

			vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { buf_file_name })
		end
	end
end

vim.api.nvim_create_user_command("FixPHPFile", function()
	if composer_info == nil then
		composer_info = setup_composer_information()
	end
	fix_php_file(vim.api.nvim_get_current_buf())
end, {})

---@class CallbackArgs
---@field buf number
---@field event string
---@field file string
---@field group number
---@field id number
---@field match string

---@class PhpStanResponse
---@field errors table<string, number>			-- Map of filenames to the number of errors in each file
---@field files table<string, PhpStanFileData>	-- Map of filenames to file-specific diagnostic data
---@field totals PhpStanTotalsData              -- Total diagnostic counts

---@class PhpStanFileData
---@field errors number									-- Total number of errors in the file
---@field messages table<number, PhpStanMessageData>	-- List of diagnostic messages for the file

---@class PhpStanMessageData
---@field ignorable boolean  -- Whether the diagnostic message is ignorable
---@field line number        -- Line number where the diagnostic occurred
---@field message string     -- The diagnostic message itself

---@class PhpStanTotalsData
---@field errors number       -- Total number of errors across all files
---@field file_errors number  -- Number of files with errors

local group = vim.api.nvim_create_augroup("StanInsideDocker", { clear = true })
local ns = vim.api.nvim_create_namespace("phpstan")
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.php",
	---@param args CallbackArgs
	callback = function(args)
		local lsp = vim.lsp.get_active_clients()
		local intelephense = vim.tbl_filter(function(client)
			return client.name == "intelephense"
		end, lsp)
		if #intelephense == 0 then
			print("No intelephense client found")
			return
		end
		vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)

		local args_path = "/app/core" .. args.match:sub(#intelephense[1].config.root_dir + 1)
		local command = {
			"docker",
			"exec",
			"core-backend-php-fpm",
			"vendor/bin/phpstan",
			"analyze",
			"--memory-limit=4G",
			"--error-format=json",
			"--no-progress",
		}

		local diagnosticErrors = {}
		vim.fn.jobstart(command, {
			stdout_buffered = true,
			on_stdout = function(_, data)
				if not data or #data == 1 and data[1] == "" then
					return
				end

				for _, line in ipairs(data) do
					---@type PhpStanResponse
					local decoded = vim.json.decode(line)

					for file, file_data in pairs(decoded.files) do
						if file == args_path then
							for _, message in ipairs(file_data.messages) do
								table.insert(diagnosticErrors, {
									bufnr = args.buf,
									lnum = message.line - 1,
									col = 0,
									severity = vim.diagnostic.severity.ERROR,
									source = "phpstanSource",
									message = message.message,
									user_data = {},
								})
							end
						end
					end
				end
			end,
			on_stderr = function(_, data, code)
				if not data or #data == 1 and data[1] == "" then
					return
				end

				if data[1]:sub(1, 5) == "Note:" then
					return
				end

				data = vim.tbl_filter(function(line)
					return line ~= ""
				end, data)

				vim.api.nvim_err_writeln(table.concat(data, "\n"))
			end,
			on_exit = function(code, data, blub)
				vim.diagnostic.set(ns, args.buf, diagnosticErrors, {})
			end,
		})
	end,
})
