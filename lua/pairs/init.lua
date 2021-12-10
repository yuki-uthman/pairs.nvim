local default  = require 'pairs.default'
local mappings = require 'pairs.mappings'

local M = {}

function M.setup(user_config)

  -- Export module
  _G.Pairs = {}


  -- Setup user config
  user_config = user_config or {}

  if user_config.pairs then
    for key, table in pairs(user_config.pairs) do
      if default.pairs[key] then
        default.pairs[key] = vim.tbl_deep_extend("force", default.pairs[key], table)
      else
        default.pairs[key] = table
      end
    end
  end

  if user_config.fallback then
    for key, func in pairs(user_config.fallback) do
      default.fallback[key] = func
    end
  end

  _G.Pairs.mappings = mappings
  _G.Pairs.fallback = default.fallback
  _G.Pairs.pairs    = default.pairs


  -- Apply config
  M.apply_mappings()

end

function M.apply_mappings()

  for name, pair in pairs(Pairs.pairs) do
    local rhs = ("<cmd>call v:lua.Pairs.mappings.open(\"%s\")<CR>"):format(name)
    vim.api.nvim_set_keymap("i", pair.left, rhs, { expr = false, noremap = true } )

    if pair.left ~= pair.right then
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
