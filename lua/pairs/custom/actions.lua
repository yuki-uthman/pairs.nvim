local keys  = require 'pairs.keys'
local utils = require 'pairs.utils'


local M = {}

function M.open_pair(pair)

  utils.feedkey(pair.left .. pair.right, "n")

  for i = 1, #pair.right do
    utils.feedkey("<left>", "n")
  end

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
