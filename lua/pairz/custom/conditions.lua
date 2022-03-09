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

return M
