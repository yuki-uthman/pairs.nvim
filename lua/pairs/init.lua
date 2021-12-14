local default  = require 'pairs.default'
local mappings = require 'pairs.mappings'

local M = {}

function M.setup(user_config)

  -- Setup user config
  user_config = user_config or {}

  if user_config.pairs then

    for filetype, table in pairs(user_config.pairs) do

      if not default.pairs[filetype] then
        default.pairs[filetype] = {}
      end

      for key, table in pairs(table) do
        if table and default.pairs[filetype][key] then
          default.pairs[filetype][key] = vim.tbl_deep_extend("force", default.pairs[filetype][key], table)
        else
          default.pairs[filetype][key] = table
        end
      end

    end

  end

  if user_config.fallback then
    for key, func in pairs(user_config.fallback) do
      default.fallback[key] = func
    end
  end

  -- Export module
  _G.Pairs = {}
  _G.Pairs.mappings = mappings


  -- Apply config
  M.apply_mappings()

end

function M.apply_mappings()

  for name, pair in pairs(default.pairs.global) do
    if pair then
      local rhs = ("<cmd>call v:lua.Pairs.mappings.open(\"\\%s\")<CR>"):format(name)
      vim.api.nvim_set_keymap("i", pair.left, rhs, { expr = false, noremap = true } )

      if pair.left ~= pair.right then
      local rhs = ("<cmd>call v:lua.Pairs.mappings.close(\"\\%s\")<CR>"):format(name)
        vim.api.nvim_set_keymap("i", pair.right, rhs, { expr = false, noremap = true } )
      end
    end
  end

  -- apply mappings for other filetypes if not set by global
  for filetype, table in pairs(default.pairs) do

    -- skip global
    if filetype ~= "global" then
      for name, pair in pairs(table) do
        if pair then
          local rhs = ("<cmd>call v:lua.Pairs.mappings.open(\"\\%s\")<CR>"):format(name)
          vim.api.nvim_set_keymap("i", pair.left, rhs, { expr = false, noremap = true } )

          if pair.left ~= pair.right then
          local rhs = ("<cmd>call v:lua.Pairs.mappings.close(\"\\%s\")<CR>"):format(name)
            vim.api.nvim_set_keymap("i", pair.right, rhs, { expr = false, noremap = true } )
          end
        end
      end

    end
  end

  vim.api.nvim_set_keymap("i", "<bs>",    "<cmd>call v:lua.Pairs.mappings.backspace()<CR>", { expr = false, noremap = true } )
  vim.api.nvim_set_keymap("i", "<cr>",    "<cmd>call v:lua.Pairs.mappings.enter()<CR>",     { expr = false, noremap = true } )
  vim.api.nvim_set_keymap("i", "<space>", "<cmd>call v:lua.Pairs.mappings.space()<CR>",     { expr = false, noremap = true } )

end

return M
