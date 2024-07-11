---@class ComposerInformation
---@field composer_file string
---@field namespace_prefix string
---@field namespace_path string

---@class ComposerFileContent
---@field autoload ComposerFileAutoload | nil

---@class ComposerFileAutoload
---@field ["psr-4"] table<string, string> | nil

local setup_composer_information = function()
  ---@type table<number, string>
  local composer_file_search_result = vim.fs.find({ 'composer.json' }, { upward = false })
  if next(composer_file_search_result) ~= nil then
    local composer_file = composer_file_search_result[1]
    local composer_string = vim.fn.readfile(composer_file)

    ---@type ComposerFileContent
    local composer_table = vim.json.decode(table.concat(composer_string, '\n'))

    local autoload = composer_table['autoload']
    if autoload == nil then
      return
    end

    local psr4 = autoload['psr-4']
    if psr4 == nil then
      return
    end

    for k, v in pairs(psr4) do
      local namespace_prefix = k
      local namespace_path = v

      ---@type ComposerInformation
      return {
        composer_file = composer_file,
        namespace_prefix = namespace_prefix,
        namespace_path = namespace_path,
      }
    end
  end
end

local composer_info = nil

local namespace_query = [[
(namespace_definition)
 name: (namespace_name) @namespace_name
]]

local class_query = [[
(class_declaration name: (name) @class_name)
]]

local fix_php_file = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, 'php', {})
  local tree = parser:parse()[1]
  local root = tree:root()

  local ts_namespace_query = vim.treesitter.query.parse('php', namespace_query)
  for id, node in ts_namespace_query:iter_captures(root, bufnr, 0, -1) do
    local name = ts_namespace_query.captures[id]
    if name == 'namespace_name' then
      local start_row, start_col, end_row, end_col = node:range()

      if composer_info == nil then
        return
      end

      local calculated_namespace = vim.fn
        .expand('%:p:h')
        :sub(#composer_info.composer_file:match('(.*/)') + 1)
        :gsub(composer_info.namespace_path, composer_info.namespace_prefix)
        :gsub('/', '\\')

      -- to get old namespace
      -- local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
      -- local old_namespace = lines[1]:sub(start_col, end_col)
      vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { calculated_namespace })
    end
  end
  local ts_class_query = vim.treesitter.query.parse('php', class_query)
  for id, node in ts_class_query:iter_captures(root, bufnr, 0, -1) do
    local name = ts_class_query.captures[id]
    if name == 'class_name' then
      local start_row, start_col, end_row, end_col = node:range()

      local buf_file_name = vim.fn.expand('%:t:r')

      vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { buf_file_name })
    end
  end
end

vim.api.nvim_create_user_command('FixPHPFile', function()
  if composer_info == nil then
    composer_info = setup_composer_information()
  end
  fix_php_file(vim.api.nvim_get_current_buf())
end, {})
