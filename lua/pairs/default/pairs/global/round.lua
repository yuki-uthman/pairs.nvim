local core = require "pairs.core"
local utils = require 'pairs.utils'

local action    = require "pairs.custom.actions"
local condition = require "pairs.custom.conditions"


local M = {}

M = {
  left = "(",
  right = ")",

  open = {
    conditions = {
      condition.right_is_letter,
    },
    actions = {
      action.no_auto_close,
      fallback = action.open_pair
    }
  },

  enter = {
    conditions = {
      condition.empty,
      condition.right_is_close_pair
    },

    actions = {
      function()
        utils.feedkey("<CR>", "n")
      end,
      function(pair)
        -- find the position of opening parenthesis
        -- local pos = vim.fn.searchpairpos('(', '', ')', 'bn')
        -- local line, col = pos[1], pos[2]

        -- local current_line = vim.api.nvim_win_get_cursor(0)[1]

        -- local indent_level = current_line - line + 1
        -- local indent = string.rep("  ", indent_level)

        -- next line starts from the opening parenthesis col like in cindent
        -- local extra_space = string.rep(" ", col - 1) .. indent

        -- delete the whole line and add the space to accomodate
        -- different indent styles across file types
        utils.feedkey("<CR>", "n")
        -- return keys.enter .. keys.delete_line .. extra_space
      end
    }

  },


  space = {
    conditions = {
      condition.empty
    },

    actions = {
      empty = action.expand_with_space
    }
  }
}

return core.new(M)
