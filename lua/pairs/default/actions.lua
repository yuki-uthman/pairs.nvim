local utils   = require 'pairs.utils'
local keys     = require 'pairs.keys'

local M = {}

M.open = function(pair)

  local move_left = string.rep(keys.left, #pair.right)

  -- if the left and right are the same chars
  if pair.left == pair.right then
    --  skip over action
    if utils.get_right_char() == pair.right then
      return keys.right

    -- no autocomplete if there is letters, digits or symbols
    elseif string.find(utils.get_left_char(), "[%w%p]") then
      return pair.left

    end
  end

  return pair.left .. pair.right .. move_left

end

-- by default if closing pair is on the right of the cursor
-- it would skip over without inserting another closing pair
M.close = function(pair)
  if utils.get_right_char() == pair.right then
    return keys.right
  else
    return pair.right
  end
end

M.backspace = {

  condition = function(pair)
    local neighbours = utils.get_neighbours()
    if neighbours == pair.left .. pair.right then
      return true
    end
  end,

  action = function(pair)
    return keys.delete .. keys.backspace
  end,
}

return M
