local default = require 'pairs.default'
local mappings = require 'pairs.mappings'

local M = {}

function M.setup()
  -- Export module

  _G.Pairs = {}

  _G.Pairs.mappings = mappings
  _G.Pairs.fallback = default.fallback
  _G.Pairs.pairs    = default.pairs

  -- Setup config

  -- Apply config
  M.apply_mappings()

end

function M.apply_mappings()

  for name, pair in pairs(Pairs.pairs) do
    local rhs = ("v:lua.Pairs.mappings.open(\"%s\")"):format(name)
    vim.api.nvim_set_keymap("i", pair.left, rhs, { expr = true, noremap = true } )

    if pair.close and pair.close.action then
      local rhs = ("v:lua.Pairs.mappings.close(\"%s\")"):format(name)
      vim.api.nvim_set_keymap("i", pair.right, rhs, { expr = true, noremap = true } )
      -- print(pair.close.key .. " --> " .. rhs)
    end
  end

  vim.api.nvim_set_keymap("i", "<bs>", "v:lua.Pairs.mappings.backspace()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", "<cr>", "v:lua.Pairs.mappings.enter()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", " ", "v:lua.Pairs.mappings.space()", { expr = true, noremap = true } )

end

return M
