-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

local options = {
	-- Set Cursor to Block
	guicursor = "",
	-- Make line numbers default
	nu = true,
	-- You can also add relative line numbers, for help with jumping.
	relativenumber = true,
	-- Content of File is Changeable
	ma = true,
	-- Enable mouse mode, can be useful for resizing splits for example!
	mouse = "a",
	-- Don't show the mode, since it's already in status line
	showmode = false,
	-- Show which line your cursor is on
	cursorline = true,
	-- Amount of spaces per <Tab>
	tabstop = 4,
	-- Number of spaces used for autoindent
	shiftwidth = 4,
	-- Number of spaces per <Tab> while editing
	softtabstop = 4,
	-- Use the appropriate number of spaces in Insert mode
	expandtab = true,
	-- update file when it is changed outside Vim
	autoread = true,
	-- Minimal number of screen lines to keep above and below the cursor.
	scrolloff = 10,
	-- Make backup before overwriting a file
	backup = false,
	-- Make backup before overwriting a file
	writebackup = false,
	-- Use a swapfile for the Buffer
	swapfile = false,
	-- Enable break indent
	undofile = true,
	undodir = os.getenv("HOME") .. "/.vim/undodir",
	-- Sync clipboard between OS and Neovim.
	--  Remove this option if you want your OS clipboard to remain independent.
	--  See `:help 'clipboard'`
	clipboard = "unnamedplus",
	-- Set highlight on search
	hlsearch = false,
	-- Visual Column for Linebreak
	colorcolumn = "80",
	-- Decrease update time
	updatetime = 250,
	timeoutlen = 300,
	-- Keep signcolumn on by default
	signcolumn = "yes",
	-- Configure how new splits should be opened
	splitright = true,
	splitbelow = true,
	-- Enable break indent
	-- breakindent = true,
	-- Case-insensitive searching UNLESS \C or capital in search
	-- ignorecase = true,
	-- smartcase = true,
	-- Sets how neovim will display certain whitespace in the editor.
	--  See :help 'list'
	--  and :help 'listchars'
	-- list = true,
	-- listchars = { tab = "» ", trail = "·", nbsp = "␣", eol = "↵" },
	-- Preview substitutions live, as you type!
	-- inccommand = "split",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
