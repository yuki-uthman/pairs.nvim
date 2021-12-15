local utils = require 'pairs.utils'

local M = {}

local function right_char_is_(regex, string)
  return function(pair)
    local right  = utils.get_right_char()
    if string.find(right, regex) then
      return string
    end
  end
end

local function left_char_is_(regex, string)
  return function(pair)
    local left  = utils.get_left_char()
    if string.find(left, regex) then
      return string
    end
  end
end

function M.empty(pair)
  if utils.get_neighbours() == pair.left .. pair.right then
    return "empty"
  end
end

function M.left_is_open_pair(pair)
  if utils.get_left_char() == pair.left then
    return "left_is_open_pair"
  end
end

function M.right_is_close_pair(pair)
  if utils.get_right_char() == pair.right then
    return "right_is_close_pair"
  else
    return false
  end
end

M.right_is_letter = right_char_is_("%a", "right_is_letter")
M.left_is_letter  = left_char_is_("%a", "left_is_letter")

M.left_is_alphanumeric = left_char_is_("%w", "left_is_alphanumeric")
M.left_is_backward_slash = left_char_is_("\\", "left_is_backward_slash")

return M
