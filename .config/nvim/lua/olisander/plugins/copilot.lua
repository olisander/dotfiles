return {
  'github/copilot.vim',
  event = 'VimEnter',
  config = function()
    -- Disable Copilot by default
    vim.g.copilot_enabled = 0
  end,
}
