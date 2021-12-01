local keys  = require 'pairs.keys'


local M = {}

function M.delete_left_and_right()
  return keys.delete .. keys.backspace
end

function M.enter_and_indent()
  return keys.enter .. keys.enter .. keys.up .. keys.indent
end

function M.expand_with_space()
  return "  " .. keys.left
end


return M
