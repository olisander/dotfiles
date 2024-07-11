---@class CallbackArgs
---@field buf number
---@field event string
---@field file string
---@field group number
---@field id number
---@field match string

---@class PhpStanResponse
---@field errors table<string, number>			-- Map of filenames to the number of errors in each file
---@field files table<string, PhpStanFileData>	-- Map of filenames to file-specific diagnostic data
---@field totals PhpStanTotalsData              -- Total diagnostic counts

---@class PhpStanFileData
---@field errors number									-- Total number of errors in the file
---@field messages table<number, PhpStanMessageData>	-- List of diagnostic messages for the file

---@class PhpStanMessageData
---@field ignorable boolean  -- Whether the diagnostic message is ignorable
---@field line number        -- Line number where the diagnostic occurred
---@field message string     -- The diagnostic message itself

---@class PhpStanTotalsData
---@field errors number       -- Total number of errors across all files
---@field file_errors number  -- Number of files with errors

local group = vim.api.nvim_create_augroup('StanInsideDocker', { clear = true })
local ns = vim.api.nvim_create_namespace('phpstan')
local is_running = false
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.php',
  group = group,
  ---@param args CallbackArgs
  callback = function(args)
    local composer_files = vim.fs.find({ 'composer.json' }, { upward = true, path = args.file })
    if #composer_files == 0 then
      print('No composer file found')
      return
    end
    local composer_file = composer_files[1]
    local composer_dir = vim.fs.dirname(composer_file)

    vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
    local args_path = '/app/core' .. args.file:sub(#composer_dir + 1)
    local command = {
      'docker',
      'exec',
      'core-backend-php-fpm',
      'vendor/bin/phpstan',
      'analyze',
      '--memory-limit=4G',
      '--error-format=json',
      '--no-progress',
    }

    local diagnosticErrors = {}
    if is_running then
      return
    end
    is_running = true
    vim.fn.jobstart(command, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if not data or #data == 1 and data[1] == '' then
          return
        end

        for _, line in ipairs(data) do
          ---@type PhpStanResponse
          local decoded = vim.json.decode(line)

          for file, file_data in pairs(decoded.files) do
            if file == args_path then
              for _, message in ipairs(file_data.messages) do
                table.insert(diagnosticErrors, {
                  bufnr = args.buf,
                  lnum = message.line - 1,
                  col = 0,
                  severity = vim.diagnostic.severity.ERROR,
                  source = 'phpstanSource',
                  message = message.message,
                  user_data = {},
                })
              end
            end
          end
        end
      end,
      on_stderr = function(_, data, code)
        if not data or #data == 1 and data[1] == '' then
          return
        end

        if data[1]:sub(1, 5) == 'Note:' then
          return
        end

        data = vim.tbl_filter(function(line)
          return line ~= ''
        end, data)

        vim.api.nvim_err_writeln('PHPStan' .. table.concat(data, '\n'))
      end,
      on_exit = function(code, data, blub)
        is_running = false
        vim.diagnostic.set(ns, args.buf, diagnosticErrors, {})
      end,
    })
  end,
})
