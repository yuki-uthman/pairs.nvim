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

M["'"] = {
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

M["\""] = {
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

M["("] = {
  left = "(",
  right = ")",

  open = {
    conditions = {
      custom_conditions.right_is_close_pair,
      custom_conditions.right_is_letter,
    },
    actions = {
      custom_actions.jump_over,
      custom_actions.no_auto_close,
      fallback = custom_actions.open_pair
    }
  },

  enter = {
    conditions = {
      custom_conditions.empty,
      custom_conditions.right_is_close_pair
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
      custom_conditions.empty
    },

    actions = {
      empty = custom_actions.expand_with_space
    }
  }
}

M["{"] = {
  left = "{",
  right = "}",

  enter = {
    conditions = {
      custom_conditions.empty,
      function(pair)

        local before_cursor = utils.get_line_before_cursor(pair)
        local before_cursor = string.match(before_cursor, "({)%s*$")

        local after_cursor = utils.get_line_after_cursor(pair)
        local after_cursor = string.match(after_cursor, "%s*(})%p*")

        if before_cursor == "{" and after_cursor == "}" then
          return true
        else
          return false
        end
      end
    },

    actions = {
      custom_actions.enter_and_indent,
      function(pair)
        local before_cursor = utils.get_line_before_cursor()
        local before_cursor = string.match(before_cursor, "%s*$")

        if #before_cursor > 0 then
          for i = 1, #before_cursor do
            utils.feedkey("<BS>", "n")
          end
        end

        utils.feedkey("<CR>", "n")

        utils.feedkey("<C-O>", "n")
        utils.feedkey("f" .. pair.right, "n")

        local before_cursor = utils.get_line(0)
        local before_cursor = string.match(before_cursor, "(%s*)}$")

        if before_cursor and #before_cursor > 0 then
          for i = 1, #before_cursor do
            utils.feedkey("<BS>", "n")
          end
        end

        utils.feedkey("<CR>", "n")

        utils.feedkey("<Up>", "n")

        utils.feedkey("<C-O>", "n")
        utils.feedkey("^", "n")

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

        local before_cursor = utils.get_line_before_cursor(pair)
        local before_cursor = string.match(before_cursor, "({)%s*$")

        local above = utils.get_line(-1)
        if not above then
          return false
        end

        local above = string.match(above, ".-({)%s*$")
        if not above then
          return false
        end

        local below = utils.get_line(1)
        if not below then
          return false
        end

        local below = string.match(below, "%s*(})%p*")
        if not below then
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
        utils.feedkey("<C-O>", "n")
        utils.feedkey("^", "n")
        -- utils.feedkey("F" .. pair.right, "n")
        -- utils.feedkey("<left>", "n")

        -- remove all indent and join with the line above
        utils.feedkey("0<C-D>", "n")
        utils.feedkey("<C-U>", "n")

        -- restore the cursor inside the opening brace
        utils.feedkey("<C-O>", "n")
        utils.feedkey("F" .. pair.left, "n")
        utils.feedkey("<right>", "n")

      end,

    }
  }

}

M["`"] = {
  left = "`",
  right = "`",
}


return M


