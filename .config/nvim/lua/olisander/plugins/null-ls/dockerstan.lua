local null_ls = require("null-ls")
local null_helpers = require("null-ls.helpers")
local null_utils = require("null-ls.utils")
local helpers = require("olisander.helpers")

-- local php_dir = vim.fs.dirname(vim.fs.find({ "composer.json" }, { upward = false })[1])
local php_dir = null_utils.root_pattern("composer.json")(vim.fn.expand("%:p"))

return {
	name = "dockerstan",
	method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
	filetypes = { "php" },
	generator = null_ls.generator({
		cwd = function()
			return php_dir
		end,
		command = "docker",
		args = function(params)
			local args_path = helpers.replace_string(params.bufname, params.cwd, "/app/core")
			local args = {
				"exec",
				"core-backend-php-fpm",
				"vendor/bin/phpstan",
				"analyze",
				"--memory-limit=4G",
				"--error-format=json",
				"--no-progress",
				args_path,
			}
			return args
		end,
		format = "json_raw",
		to_temp_file = true,
		check_exit_code = function(code, stdout)
			if code == 0 then
				return true
			end
			print("dockerstan", code, stdout)
			return code <= 1
		end,
		on_output = function(params)
			local path = helpers.replace_string(params.bufname, params.cwd, "/app/core")
			local parser = null_helpers.diagnostics.from_json({})
			params.messages = params.output
				and params.output.files
				and params.output.files[path]
				and params.output.files[path].messages
				or {}

			return parser({ output = params.messages })
		end,
	}),
}
