
local helper = require 'pairs.helper'
local keys   = require 'pairs.keys'

local M = {}

M.single_quote = {
  left = "'",
  right = "'",
  open = {
    action = function(pair)
      local right = helper.get_right_char()
      local left = helper.get_left_char()

      if string.find(left, "[%a\\]") then
        return pair.left

      elseif right == pair.left then
        return keys.right

      else
        return pair.left .. pair.right .. keys.left

      end
    end
  },

  backspace = {
    condition = function()
      if helper.get_neighbours() == "''" then
        return true
      end
    end,

    action = function(self)
      return keys.delete .. keys.backspace
    end
  },
}

M.double_quote = {
  left = "\"",
  right = "\"",
  open = {
    action = function(pair)
      local right = helper.get_right_char()
      local left = helper.get_left_char()

      if string.find(left, "[\\]") then
        return pair.right
      elseif right == pair.right then
        return keys.right
      else
        return pair.left .. pair.right .. keys.left
      end
    end
  },

  backspace = {
    condition = function()
      if helper.get_neighbours() == "\"\"" then
        return true
      end
    end,

    action = function(self)
      return keys.delete .. keys.backspace
    end
  },
}

M.parenthesis = {
  left = "(",
  right = ")",
  open = {
    action = function(pair)
      return "()" .. keys.left
    end
  },

  close = {
    action = function(pair)
      if helper.get_right_char() == ")" then
        return keys.right
      else
        return ")"
      end
    end
  },

  backspace = {
    condition = function()
      if helper.get_neighbours() == "()" then
        return true
      end
    end,

    action = function(self)
      return keys.delete .. keys.backspace
    end
  },

  enter = {
    condition = function()
      if helper.get_right_char() == ")" then
        return true
      end
    end,

    action = function()
      return keys.enter .. keys.indent
    end
  },

  space = {
    condition = function()
      if helper.get_neighbours() == "()" then
        return true
      end
    end,

    action = function()
      return "  " .. keys.left
    end
  }
}

M.curly_braces = {
  left = "{",
  right = "}",

  open = {
    action = function()
      return "{}" .. keys.left
    end
  },

  close = {
    action = function()
      if helper.get_right_char() == "}" then
        return keys.right
      else
        return "}"
      end
    end
  },

  backspace = {
    condition = function()
      if helper.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function()
      return keys.delete .. keys.backspace
    end,
  },

  enter = {
    condition = function()
      if helper.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function(self)
      return keys.enter .. keys.enter .. keys.up .. keys.indent
    end
  },
  space = {
    condition = function()
      if helper.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function()
      return "  " .. keys.left
    end
  }

}

return M
