local utils = require 'pairz.utils'

local M = {}

function M.empty(pair)
  if M.left_is_open_pair(pair) and M.right_is_close_pair(pair)  then
    return 'empty'
  end
end

function M.left_is_open_pair(pair)
  return utils.left_char_match("%" .. pair.left)
end

function M.right_is_close_pair(pair)
  return utils.right_char_match("%" .. pair.right)
end

function M.right_is_letter()
  return utils.right_char_match("%a")
end

function M.left_is_letter()
  return utils.left_char_match("%a")
end

function M.left_is_alphanumeric()
  return utils.left_char_match("%w")
end

function M.left_is_backward_slash()
  return utils.left_char_match("\\")
end

local function left_has_space(pair)
  local left = utils.get_left_char(2)

  if left == pair.left .. " " then
    return true
  end
end

local function right_has_space(pair)
  local close_col = utils.get_close_pos(pair)
  local right = utils.get_line(0):sub(close_col - 1, close_col - 0)

  if right == " " .. pair.right then
    return true
  end
end

function M.space_on_both_side(pair)

  if left_has_space(pair) and right_has_space(pair) then
    return true
  end

end

return M
