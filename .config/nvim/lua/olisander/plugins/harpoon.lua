return {
  -- NOTE: Yes, you can install new plugins here!
  'theprimeagen/harpoon',
  branch = 'harpoon2',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local harpoon = require('harpoon')

    harpoon:setup()

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end)
    vim.keymap.set('n', '<leader>l', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    vim.keymap.set('n', 'H', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', 'L', function()
      harpoon:list():next()
    end)
  end,
}
