local custom_actions    = require "pairs.custom.actions"
local custom_conditions = require "pairs.custom.conditions"

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

local M = {}

M.single_quote = {
  left = "'",
  right = "'",
  open = {
    conditions = {
      custom_conditions.left_is_backward_slash,
      custom_conditions.right_is_close_pair,
      custom_conditions.right_is_letter,
      custom_conditions.left_is_alphanumeric,
    },

    actions = {
      custom_actions.no_auto_close,
      custom_actions.jump_over,
      custom_actions.no_auto_close,
      custom_actions.no_auto_close,
    }
  },

}

M.double_quote = {
  left = "\"",
  right = "\"",
  open = {
    conditions = {
      custom_conditions.left_is_backward_slash,
      custom_conditions.right_is_close_pair,
      custom_conditions.right_is_letter,
      custom_conditions.left_is_alphanumeric,
    },

    actions = {
      custom_actions.no_auto_close,
      custom_actions.jump_over,
      custom_actions.no_auto_close,
      custom_actions.no_auto_close,
    }
  },
}

M.parenthesis = {
  left = "(",
  right = ")",

  enter = {
    conditions = {
      custom_conditions.empty,
      custom_conditions.right_is_close_pair
    },

    actions = {
      empty = function()
        return keys.enter
      end,
      right_is_close_pair = function(pair)
        -- find the position of opening parenthesis
        local pos = vim.fn.searchpairpos('(', '', ')', 'bn')
        local line, col = pos[1], pos[2]

        local current_line = vim.api.nvim_win_get_cursor(0)[1]

        local indent_level = current_line - line + 1
        local indent = string.rep("  ", indent_level)

        -- next line starts from the opening parenthesis col like in cindent
        local extra_space = string.rep(" ", col - 1) .. indent

        -- delete the whole line and add the space to accomodate
        -- different indent styles across file types
        return keys.enter .. keys.delete_line .. extra_space
      end
    }

  },

  space = {
    conditions = {
      custom_conditions.empty
    },

    actions = {
      empty = custom_actions.expand_with_space
    }
  }
}

M.curly_braces = {
  left = "{",
  right = "}",

  enter = {
    conditions = {
      custom_conditions.empty
    },
    
    actions = {
      empty = custom_actions.enter_and_indent
    }
  },

  space = {
    conditions = {
      custom_conditions.empty
    },

    actions = {
      empty = custom_actions.expand_with_space
    }
  }

}

M.tilda = {
  left = "`",
  right = "`",
}


return M
