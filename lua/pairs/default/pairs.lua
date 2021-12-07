local custom_actions    = require "pairs.custom.actions"
local custom_conditions = require "pairs.custom.conditions"

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

local function trim(input)
  if not input then
    return false
  end
  return string.match(input, '^%s*(.-)%s*$')
end

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
  },

  backspace = {
    conditions = {
      custom_conditions.empty,

      function(pair)
        if utils.get_neighbours(2) == pair.left .. "  ".. pair.right then
          return true
        else
          return false
        end
      end,

      function(pair)

        local above = trim(utils.get_line(-1))
        local below = trim(utils.get_line(1))

        if not above or not below then
          return false
        end

        local before_cursor = trim(utils.get_line_before_cursor())

        if above .. before_cursor .. below ==  "{}" then
          return true
        else
          return false
        end
      end

    },

    actions = {
      custom_actions.delete_left_and_right,
      custom_actions.delete_left_and_right,
      function(pair)

        utils.feedkey("<C-G>u", "n")

        -- remove all indent and join with the line above
        utils.feedkey("0<C-D>", "n")
        utils.feedkey("<C-U>", "n")

        utils.feedkey("<down>", "n")
        utils.feedkey("<left>", "n")

        -- remove all indent and join with the line above
        utils.feedkey("0<C-D>", "n")
        utils.feedkey("<C-U>", "n")

        -- restore the cursor inside the opening brace
        utils.feedkey("<C-O>", "n")
        utils.feedkey("^", "n")
        utils.feedkey("<right>", "n")


        return ""
      end,

    }
  }

}

M.tilda = {
  left = "`",
  right = "`",
}


return M


