local null_ls = require("null-ls")
local utils = require("null-ls.utils")
local helpers = require("olisander.helpers")

-- local php_dir = vim.fs.dirname(vim.fs.find({ "composer.json" }, { upward = false })[1])
local php_dir = utils.root_pattern("composer.json")(vim.fn.expand("%:p"))

return {
	name = "dockerphpcbf",
	method = null_ls.methods.FORMATTING,
	filetypes = { "php" },
	generator = null_ls.formatter({
		cwd = function()
			return php_dir
		end,
		command = "docker",
		args = function(params)
			local args_path = helpers.replace_string(params.bufname, params.cwd, "/app/core")
			local args = {
				"exec",
				"core-backend-php-fpm",
				"vendor/bin/phpcbf",
				"-q",
				"--stdin-path=" .. args_path,
				"-",
			}
			return args
		end,
		to_stdin = true,
		check_exit_code = function(code)
			return code <= 2
		end,
	}),
}
