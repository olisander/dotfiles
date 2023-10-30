return {
	"jose-elias-alvarez/null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				require("olisander.plugins.null-ls.dockerphpcbf"),
				require("olisander.plugins.null-ls.dockerstan"),
				null_ls.builtins.formatting.stylua,
			},
			debug = true,
		})
	end,
}
