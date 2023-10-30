
return {
	-- NOTE: Yes, you can install new plugins here!
	"theprimeagen/harpoon",
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<leader>a", mark.add_file)
		vim.keymap.set("n", "L", ui.nav_next)
		vim.keymap.set("n", "H", ui.nav_prev)
		vim.keymap.set("n", "<leader>l", ui.toggle_quick_menu)

		--vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
		--vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
		--vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
		--vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
	end,
}
