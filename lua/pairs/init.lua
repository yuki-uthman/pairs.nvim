local default = require 'pairs.default'
local actions = require 'pairs.actions'

local M = {}

function M.setup()
  -- Export module

  _G.Pairs = {}

  _G.Pairs.actions  = actions
  _G.Pairs.fallback = default.fallback
  _G.Pairs.pairs    = default.pairs

  -- Setup config

  -- Apply config
  M.apply_mappings()

end

function M.apply_mappings()

  for name, pair in pairs(Pairs.pairs) do
    local rhs = ("v:lua.Pairs.actions.open(\"%s\")"):format(name)
    vim.api.nvim_set_keymap("i", pair.left, rhs, { expr = true, noremap = true } )

    if pair.close and pair.close.action then
      local rhs = ("v:lua.Pairs.actions.close(\"%s\")"):format(name)
      vim.api.nvim_set_keymap("i", pair.right, rhs, { expr = true, noremap = true } )
      -- print(pair.close.key .. " --> " .. rhs)
    end
  end

  vim.api.nvim_set_keymap("i", "<bs>", "v:lua.Pairs.actions.backspace()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", "<cr>", "v:lua.Pairs.actions.enter()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", " ", "v:lua.Pairs.actions.space()", { expr = true, noremap = true } )

end

return M
