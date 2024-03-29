local default  = require 'pairz.default'
local mappings = require 'pairz.mappings'

local M = {}

function M.setup(user_config)
  user_config = user_config or {}

  _G.Pairz = {}
  _G.Pairz.mappings = mappings

  setup_fallbacks(user_config)

  setup_pairz(user_config)
  apply_mappings_for_pairz()

  setup_registered_keys(user_config)
  apply_mappings_for_registered_keys()

end



function setup_fallbacks(user_config)
  if not user_config.fallback then return end

  for key, action in pairs(user_config.fallback) do
    default.fallback[key] = action
  end
end



function setup_pairz(user_config)
  if not user_config.pairz then return end

  for filetype, keys in pairs(user_config.pairz) do
    register_filetype(filetype)
    disable_keys(filetype, keys)
    enable_keys(filetype, keys)
  end
end

function register_filetype(filetype)
  if not is_filetype_registered(filetype) then
    add_filetype(filetype)
  end
end

function is_filetype_registered(filetype)
  if default.pairz[filetype] then
    return true
  end
end

function add_filetype(filetype)
  default.pairz[filetype] = {}
end

function disable_keys(filetype, keys)
  for key, action in pairs(keys) do
    if action == false then
      default.pairz[filetype][key] = false
    end
  end
end

function enable_keys(filetype, keys)
  for key, action in pairs(keys) do
    if not action then goto next end

    if default.pairz[filetype][key] then
      default.pairz[filetype][key] = vim.tbl_deep_extend("force", default.pairz[filetype][key], action)
    else
      default.pairz[filetype][key] = action
    end

    ::next::
  end
end



function apply_mappings_for_pairz()
  apply_open_key_mappings()
  apply_close_key_mappings()
end

function apply_open_key_mappings()
  for filetype, table in pairs(default.pairz) do
    for key, pair in pairs(table) do
      if not pair then goto next end

      local rhs = ("<cmd>call v:lua.Pairz.mappings.open(\"\\%s\")<CR>"):format(key)
      vim.api.nvim_set_keymap("i", pair.left, rhs, { expr = false, noremap = true } )

      ::next::
    end
  end
end

function apply_close_key_mappings()
  for filetype, table in pairs(default.pairz) do
    for key, pair in pairs(table) do
      if not pair then goto next end
      if close_key_not_needed(pair) then goto next end

      local rhs = ("<cmd>call v:lua.Pairz.mappings.close(\"\\%s\")<CR>"):format(key)
      vim.api.nvim_set_keymap("i", pair.right, rhs, { expr = false, noremap = true } )

      ::next::
    end
  end
end

function close_key_not_needed(pair)
  if pair.left == pair.right then return true end
end



function setup_registered_keys()

end



function apply_mappings_for_registered_keys()
  vim.api.nvim_set_keymap("i", "<bs>",    "<cmd>call v:lua.Pairz.mappings.backspace()<CR>", { expr = false, noremap = true } )
  vim.api.nvim_set_keymap("i", "<cr>",    "<cmd>call v:lua.Pairz.mappings.enter()<CR>",     { expr = false, noremap = true } )
  vim.api.nvim_set_keymap("i", "<space>", "<cmd>call v:lua.Pairz.mappings.space()<CR>",     { expr = false, noremap = true } )
end



return M
