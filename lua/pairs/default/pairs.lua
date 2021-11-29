
local utils = require 'pairs.utils'
local keys   = require 'pairs.keys'

local M = {}

M.single_quote = {
  left = "'",
  right = "'",
  open = {
    action = function(pair)
      local right = utils.get_right_char()
      local left = utils.get_left_char()

      if string.find(left, "[\\]") then
        return pair.left

      elseif right == pair.left then
        return keys.right

      elseif string.find(left, "[%w%p]") then
        return pair.left

      else
        return pair.left .. pair.right .. keys.left

      end
    end
  },

  backspace = {
    condition = function()
      if utils.get_neighbours() == "''" then
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
      local right = utils.get_right_char()
      local left = utils.get_left_char()

      if string.find(left, "[\\]") then
        return pair.left

      elseif right == pair.left then
        return keys.right

      elseif string.find(left, "[%w%p]") then
        return pair.left

      else
        return pair.left .. pair.right .. keys.left

      end
    end
  },

  backspace = {
    condition = function()
      if utils.get_neighbours() == "\"\"" then
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
      if utils.get_right_char() == ")" then
        return keys.right
      else
        return ")"
      end
    end
  },

  backspace = {
    condition = function()
      if utils.get_neighbours() == "()" then
        return true
      end
    end,

    action = function(self)
      return keys.delete .. keys.backspace
    end
  },

  enter = {
    condition = function()
      if utils.get_right_char() == ")" then
        return true
      end
    end,

    action = function(pair)
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
  },

  space = {
    condition = function()
      if utils.get_neighbours() == "()" then
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
      if utils.get_right_char() == "}" then
        return keys.right
      else
        return "}"
      end
    end
  },

  backspace = {
    condition = function()
      if utils.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function()
      return keys.delete .. keys.backspace
    end,
  },

  enter = {
    condition = function()
      if utils.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function(self)
      return keys.enter .. keys.enter .. keys.up .. keys.indent
    end
  },
  space = {
    condition = function()
      if utils.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function()
      return "  " .. keys.left
    end
  }

}

M.tilda = {
  left = "`",
  right = "`",
}


return M
