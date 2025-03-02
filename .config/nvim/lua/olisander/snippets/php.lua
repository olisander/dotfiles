require('luasnip.session.snippet_collection').clear_snippets('php')

local ls = require('luasnip')

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.conditions')
local conds_expand = require('luasnip.extras.conditions.expand')

ls.add_snippets('php', {
  s({
    trig = 'prif',
    name = 'private function',
  }, fmt('private function {}({}): {}\n{{\n    {}\n}}', { i(1), i(2), i(3, 'void'), i(0) })),
  s({
    trig = 'pubf',
    name = 'public function',
  }, fmt('public function {}({}): {}\n{{\n    {}\n}}', { i(1), i(2), i(3, 'void'), i(4) })),
  s({
    trig = 'if',
    name = 'if',
  }, fmt('if ({}) {{\n    {}\n}}', { i(1), i(2) })),
  s({
    trig = 'foreach',
    name = 'foreach',
  }, fmt('foreach ({} as {}) {{\n    {}\n}}', { i(1), i(2, '$item'), i(3) })),
})
