local action    = require "pairs.custom.actions"
local condition = require "pairs.custom.conditions"

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

local M = {}

M = {
  left = "{",
  right = "}",

  enter = {
    conditions = {
      condition.empty,
      function(pair)

        local before_cursor = utils.left_of_cursor_match("({)%s*$")
        local after_cursor = utils.right_of_cursor_match("%s*(})%p*")

        if before_cursor == "{" and after_cursor == "}" then
          return true
        else
          return false
        end
      end
    },

    actions = {
      action.enter_and_indent,
      function(pair)

        local before_cursor = utils.left_of_cursor_match("%s*$")

        if #before_cursor > 0 then
          for i = 1, #before_cursor do
            utils.feedkey("<BS>", "n")
          end
        end

        utils.feedkey("<CR>", "n")

        utils.feedkey("<C-O>", "n")
        utils.feedkey("f" .. pair.right, "n")

        local after_cursor = utils.right_of_cursor_match("(%s*)}$")

        if after_cursor and #after_cursor > 0 then
          for i = 1, #after_cursor do
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
      condition.empty,
      function()

        local before_cursor = utils.get_left_char()

        local after_cursor = utils.get_line_after_cursor()
        local after_cursor = string.match(after_cursor, "%S(})%p*")

        if before_cursor == "{" and after_cursor == "}" then
          return "empty"
        end

      end
    },

    actions = {
      empty = action.expand_with_space,
    }
  },

  backspace = {
    conditions = {
      condition.empty,

      function(pair)

        local before_cursor = utils.get_line_before_cursor(pair)
        if not before_cursor then
          return false
        end

        local before_cursor = string.match(before_cursor, "({%s*)$")
        if not before_cursor then
          return false
        end

        local after_cursor = utils.get_line_after_cursor(pair)
        if not after_cursor then
          return false
        end

        local after_cursor = string.match(after_cursor, "(%s*})%p*$")
        if not before_cursor then
          return false
        end

        if #before_cursor == #after_cursor then
          return true
        else
          return false
        end
      end,

      function(pair)

        local before_cursor = utils.get_line_before_cursor(pair)
        local before_cursor = string.match(before_cursor, "({)%s*$")

        local left = utils.left_of_cursor_match("({)%s*$")

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

        local before_cursor = utils.trim(utils.get_line_before_cursor())

        if above .. before_cursor .. below ==  "{}" then
          return true
        else
          return false
        end
      end

    },

    actions = {
      action.delete_left_and_right,
      function(pair)
        local pos = vim.fn.searchpos(pair.right, 'nc', vim.fn.line('.'))
        local lnum, col = pos[1], pos[2]

        vim.api.nvim_buf_set_text(0, lnum - 1, col - 2, lnum - 1, col - 1, {''} )

        utils.feedkey("<bs>", "n")
      end,
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

return M
