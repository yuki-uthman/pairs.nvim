local keys  = require 'pairs.keys'


local M = {}

function M.open_pair(pair)
  local move_left = string.rep(keys.left, #pair.right)
  return pair.left .. pair.right .. move_left
end

function M.delete_left_and_right()
  return keys.delete .. keys.backspace
end

function M.enter_and_indent()
  return keys.enter .. keys.enter .. keys.up .. keys.indent
end

function M.expand_with_space()
  return "  " .. keys.left
end

function M.jump_over(pair)
  return keys.right
end

function M.no_auto_close(pair)
  return pair.left
end


return M
