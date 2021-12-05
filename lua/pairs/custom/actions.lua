local keys  = require 'pairs.keys'


local M = {}

function M.delete_left_and_right()
  return keys.delete .. keys.backspace
end

function M.enter_and_indent()
  return keys.enter .. keys.enter .. keys.up .. keys.tab
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
