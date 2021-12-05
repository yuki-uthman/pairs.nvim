local utils = require 'pairs.utils'

local M = {}

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

function M.left_is_alphanumeric(pair)
  local left  = utils.get_left_char()

  if string.find(left, "[%w]") then
    return "left_is_alphanumeric"
  else
    return false
  end

end

function M.left_is_backward_slash(pair)
  local left  = utils.get_left_char()
  if string.find(left, "[\\]") then
    return "left_is_backward_slash"
  end
end

function M.right_is_close_pair(pair)
  if utils.get_right_char() == pair.right then
    return "right_is_close_pair"
  end
end


return M
