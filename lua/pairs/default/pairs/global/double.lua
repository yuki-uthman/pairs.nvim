local action    = require "pairs.custom.actions"
local condition = require "pairs.custom.conditions"

local M = {}

M = {
  left = "\"",
  right = "\"",
  open = {
    conditions = {
      condition.left_is_backward_slash,
      condition.right_is_close_pair,
      condition.right_is_letter,
      condition.left_is_alphanumeric,
    },

    actions = {
      action.no_auto_close,
      action.jump_over,
      action.no_auto_close,
      action.no_auto_close,
    }
  },
}

return M
