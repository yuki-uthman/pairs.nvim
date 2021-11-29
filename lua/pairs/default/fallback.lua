local keys = require 'pairs.keys'

local M = {}

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode, true)
end

M.enter = function()

  feedkey("<CR>", "n")
  feedkey("<Plug>DiscretionaryEnd" , "")

  return ""
end

M.open = function(pair)
  local move_left = string.rep(keys.left, #pair.right)
  return pair.left .. pair.right .. move_left
end


return M
