return {
  { -- Autoformat
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        notify_on_error = true,
        format_on_save = function(bufnr)
          local lsp_fallback_by_type = {}
          return {
            timeout_ms = 5000,
            lsp_fallback = lsp_fallback_by_type[vim.bo[bufnr].filetype] or false,
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          -- Conform can also run multiple formatters sequentially
          -- python = { "isort", "black" },
          --
          -- You can use a sub-list to tell conform to run *until* a formatter
          -- is found.
          typescriptreact = { 'prettierd', 'eslint_d' },
          typescript = { 'prettierd', 'eslint_d' },
          php = { 'trim_whitespace', 'pretty-php', 'php_cs_fixer', 'phpcbf' },
          rust = { 'rustfmt', 'leptosfmt' },
          typst = { 'typstfmt' },
        },
        formatters = {
          phpcbf = {
            cwd = require('conform.util').root_file({ 'composer.json' }),
            require_cwd = true,
          },
          php_cs_fixer = {
            env = {
              PHP_CS_FIXER_IGNORE_ENV = 1,
            },
          },
        },
      })
    end,
  },
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
}
