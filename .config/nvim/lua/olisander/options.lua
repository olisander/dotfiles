local options = {
    -- Set Cursor to Block
    guicursor = "",
    -- Make line numbers default
    nu = true,
    -- Relative Line Numbers
    relativenumber = true,
    -- Content of File is Changeable
    ma = true,
    -- Enable mouse mode
    mouse = "a",
    -- Highlight current line
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
    -- Minum Lines above and below cursor
    scrolloff = 8,
    -- Make backup before overwriting a file
    backup = false,
    -- Make backup before overwriting a file
    writebackup = false,
    -- Use a swapfile for the Buffer
    swapfile = false,
    undofile = true,
    undodir = os.getenv("HOME") .. "/.vim/undodir",
    -- Sync clipboard between OS and Neovim.
    --  Remove this option if you want your OS clipboard to remain independent.
    --  See `:help 'clipboard'`
    clipboard = "unnamedplus",

    -- Set highlight on search
    hlsearch = false,
    -- Enable break indent
    -- breakindent = true,
    -- Visual Column for Linebreak
    colorcolumn = "80",
    -- Time in Milliseconds before swap is written to Disk
    updatetime = 50,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
