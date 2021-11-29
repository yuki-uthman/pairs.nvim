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
  if pair.left == pair.right then
    if helper.get_right_char() == pair.right then
      return keys.right

    elseif string.find(helper.get_left_char(), "[%w%p]") then
      return pair.left

    end
  end

  -- if pair.left == pair.right and helper.get_right_char() == pair.right then
  --   return keys.right

  -- elseif pair.left == pair.right and string.find(helper.get_left_char(), "[%w%p]") then
  --   return pair.left

  -- else
  --   return pair.left .. pair.right .. move_left
  -- end

  return pair.left .. pair.right .. move_left

end

return M
