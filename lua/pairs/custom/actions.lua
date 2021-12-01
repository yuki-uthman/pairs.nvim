local keys  = require 'pairs.keys'


local M = {}

function M.delete_left_and_right()
  return keys.delete .. keys.backspace
end


return M
