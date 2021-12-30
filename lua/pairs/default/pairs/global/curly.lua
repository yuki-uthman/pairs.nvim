local core = require "pairs.core"
local utils = require 'pairs.utils'

local action    = require "pairs.custom.actions"
local condition = require "pairs.custom.conditions"


local M = {}

local function inside_pair(pair)
  local left = utils.left_of_cursor_match("({)%s*$")
  local right = utils.right_of_cursor_match("%s*(})%p*")

  if left == pair.left and right == pair.right then
    return true
  end
end

local function space_on_both_side(pair)

  local left  = utils.left_of_cursor_match("({%s*)$")
  local right = utils.right_of_cursor_match("(%s*})%p*$")

  if not left or not right then
    return nil
  elseif #left == #right then
    return true
  end
end

local function to_one_liner(pair)

  local above = utils.above_match(".-({)%s*$")
  local below = utils.below_match("%s*(})%p*")
  local left = utils.trim(utils.get_line_before_cursor())

  if not above or not below or not left then
    return nil
  elseif above .. left .. below ==  "{}" then
    return true
  end
end


M = {
  left = "{",
  right = "}",

  enter = {
    conditions = {
      condition.empty,
      inside_pair
    },

    actions = {
      action.enter_and_indent,
      function(pair)

        local left = utils.left_of_cursor_match("%s*$") or ""

        if #left > 0 then
          for i = 1, #left do
            utils.feedkey("<BS>", "n")
          end
        end

        utils.feedkey("<CR>", "n")

        utils.feedkey("<C-O>", "n")
        utils.feedkey("f" .. pair.right, "n")

        local right = utils.right_of_cursor_match("(%s*)}$") or ""

        if #right > 0 then
          for i = 1, #right do
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

        local left = utils.get_left_char()
        local right = utils.right_of_cursor_match("%S(})%p*")

        if left == "{" and right == "}" then
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
      space_on_both_side,
      to_one_liner
    },

    actions = {
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

return core.new(M)
