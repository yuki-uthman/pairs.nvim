local custom_actions    = require 'pairs.custom.actions'
local custom_conditions = require 'pairs.custom.conditions'
local utils             = require 'pairs.utils'
local keys              = require 'pairs.keys'

local M = {}

local function open_pair(pair)
  local move_left = string.rep(keys.left, #pair.right)
  return pair.left .. pair.right .. move_left
end

local function right_is_close_pair(pair)
  if pair.left == pair.right and utils.get_right_char() == pair.right then
      return "right_is_close_pair"
  end
end

local function left_is_alpha_or_punc(pair)
  if pair.left == pair.right and string.find(utils.get_left_char(), "[%w%p]") then
    return "left_is_alpha_or_punc"
  end
end

-- Default
-- if left and right are of the same char eg. quote
-- it would skip over if another pair is on the right of the cursor
M.open = {
  conditions = {
    right_is_close_pair,
    left_is_alpha_or_punc,
    custom_conditions.right_is_letter,
    custom_conditions.left_is_letter,
  },
  actions = {
    custom_actions.jump_over,
    custom_actions.no_auto_close,
    custom_actions.no_auto_close,
    custom_actions.no_auto_close,
    fallback = open_pair
  }
}

-- Default
-- if closing pair is on the right of the cursor
-- it would skip over without inserting another closing pair
M.close = {
  conditions = {
    custom_conditions.right_is_close_pair,
  },

  actions = {
    custom_actions.jump_over,
  }
}

M.backspace = {
  conditions = {
    custom_conditions.empty
  },
  actions = {
    custom_actions.delete_left_and_right
  },
}

return M
