return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("rose-pine").setup({
			-- disable_background = true,
			highlight_groups = {
				-- Telescope
				TelescopeBorder = { fg = "highlight_high", bg = "none" },
				TelescopeNormal = { bg = "none" },
				TelescopePromptNormal = { bg = "base" },
				TelescopeResultsNormal = { fg = "subtle", bg = "none" },
				TelescopeSelection = { fg = "text", bg = "base" },
				TelescopeSelectionCaret = { fg = "rose", bg = "base" },

				-- Statusline
				MiniStatuslineModeNormal = { fg = "base", bg = "rose" },
				MiniStatuslineModeInsert = { fg = "base", bg = "foam" },
				MiniStatuslineModeVisual = { fg = "base", bg = "iris" },
				MiniStatuslineModeReplace = { fg = "base", bg = "pine" },
				MiniStatuslineModeCommand = { fg = "base", bg = "love" },
				MiniStatuslineModeOther = { fg = "base", bg = "base" },
			},
			styles = {
				transparency = true,
			},
		})
		vim.cmd.colorscheme("rose-pine")
		-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		-- vim.api.nvim_set_hl(0, "SignColumn", { fg = "none" })
	end,
}
