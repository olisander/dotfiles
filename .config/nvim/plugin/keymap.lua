-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Exit File' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected line up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected line down' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without losing copied' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Center view on half page down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Center view on half page up' })

-- Quickfix
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', { desc = 'Move quickfix up' })
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', { desc = 'Move quickfix down' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Move diagnostic up' })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Move diagnostic down' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
