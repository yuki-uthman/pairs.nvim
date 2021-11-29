local keys   = require 'pairs.keys'
local helper = require 'pairs.helper'

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

  -- if the left and right are the same chars
  -- then this condition provides the skip over action
  if pair.left == pair.right and helper.get_right_char == pair.right then
    return keys.right
  else
    return pair.left .. pair.right .. move_left
  end
end

return M
