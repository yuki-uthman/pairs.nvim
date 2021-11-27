
local M = {}

function M.hello()
  print("Hello Lua")
end

local function escape(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

M.keys = {
  above     = escape('<C-o>O'),
  backspace = escape('<bs>'),
  enter     = escape('<cr>'),
  tab       = escape('<tab>'),
  space     = escape('<space>'),
  delete    = escape('<del>'),
  keep_undo = escape('<C-g>U'),
  indent    = escape('<C-f>'),
  up        = escape('<up>'),
  down      = escape('<down>'),
  left      = escape('<left>'),
  right     = escape('<right>')
}

local single_quote = {
  left = "'",
  right = "'",
  open = {
    action = function(pair)
      local right = M.get_right_char()
      local left = M.get_left_char()

      if string.find(left, "[%a\\]") then
        return pair.left

      elseif right == pair.left then
        return M.keys.right

      else
        return pair.left .. pair.right .. M.keys.left

      end
    end
  },

  backspace = {
    condition = function()
      if M.get_neighbours() == "''" then
        return true
      end
    end,

    action = function(self)
      return M.keys.delete .. M.keys.backspace
    end
  },
}

local double_quote = {
  left = "\"",
  right = "\"",
  open = {
    action = function(pair)
      local right = M.get_right_char()
      local left = M.get_left_char()

      if string.find(left, "[\\]") then
        return pair.right
      elseif right == pair.right then
        return M.keys.right
      else
        return pair.left .. pair.right .. M.keys.left
      end
    end
  },

  backspace = {
    condition = function()
      if M.get_neighbours() == "\"\"" then
        return true
      end
    end,

    action = function(self)
      return M.keys.delete .. M.keys.backspace
    end
  },
}

local parenthesis = {
  left = "(",
  right = ")",
  open = {
    action = function(pair)
      return "()" .. M.keys.left
    end
  },

  close = {
    action = function(pair)
      if M.get_right_char() == ")" then
        return M.keys.right
      else
        return ")"
      end
    end
  },

  backspace = {
    condition = function()
      if M.get_neighbours() == "()" then
        return true
      end
    end,

    action = function(self)
      return M.keys.delete .. M.keys.backspace
    end
  },

  enter = {
    condition = function()
      if M.get_right_char() == ")" then
        return true
      end
    end,

    action = function()
      return M.keys.enter .. M.keys.indent
    end
  },

  space = {
    condition = function()
      if M.get_neighbours() == "()" then
        return true
      end
    end,

    action = function()
      return "  " .. M.keys.left
    end
  }
}

local curly_braces = {
  left = "{",
  right = "}",

  open = {
    action = function()
      return "{}" .. M.keys.left
    end
  },

  close = {
    action = function()
      if M.get_right_char() == "}" then
        return M.keys.right
      else
        return "}"
      end
    end
  },

  backspace = {
    condition = function()
      if M.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function()
      return M.keys.delete .. M.keys.backspace
    end,
  },

  enter = {
    condition = function()
      if M.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function(self)
      return M.keys.enter .. M.keys.enter .. M.keys.up .. M.keys.indent
    end
  },
  space = {
    condition = function()
      if M.get_neighbours() == "{}" then
        return true
      end
    end,

    action = function()
      return "  " .. M.keys.left
    end
  }

}

function M.setup()
  -- Export module
  _G.Pairs = {
      single_quote  = single_quote,
      double_quote = double_quote,
      parenthesis  = parenthesis,
      curly_braces  = curly_braces,
  }

  -- Setup config

  -- Apply config
  M.apply_mappings()

end

function M.apply_mappings()

  for name, pair in pairs(Pairs) do
    local rhs = ("v:lua.PairsActions.open(\"%s\")"):format(name)
    vim.api.nvim_set_keymap("i", pair.left, rhs, { expr = true, noremap = true } )

    if pair.close and pair.close.action then
      local rhs = ("v:lua.PairsActions.close(\"%s\")"):format(name)
      vim.api.nvim_set_keymap("i", pair.right, rhs, { expr = true, noremap = true } )
      -- print(pair.close.key .. " --> " .. rhs)
    end
  end

  vim.api.nvim_set_keymap("i", "<bs>", "v:lua.PairsActions.backspace()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", "<cr>", "v:lua.PairsActions.enter()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", " ", "v:lua.PairsActions.space()", { expr = true, noremap = true } )

end

function M.get_neighbours()

  return M.get_left_char() .. M.get_right_char()
end

function M.get_right_char()
  local line = vim.api.nvim_get_current_line()
  local col  = vim.api.nvim_win_get_cursor(0)[2]

  local right = vim.fn.strpart(line, col, 1)

  return right
end

function M.get_left_char()
  local line = vim.api.nvim_get_current_line()
  local col  = vim.api.nvim_win_get_cursor(0)[2]

  local left  = vim.fn.strpart(line, col - 1, 1)

  return left
end


PairsActions = {}

function PairsActions.open(arg)

  -- return the pair table to open
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs[arg]

  return pair.open.action(pair)

end

function PairsActions.close(arg)

  -- return the pair table to close
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs[arg]

  return pair.close.action(pair)

end


function PairsActions.backspace()

  local neighbours = M.get_neighbours()

  for _, pair in pairs(Pairs) do

    -- skip if backspace is not implemented
    if not pair.backspace then
      goto next
    end

    if pair.backspace.condition and pair.backspace.condition() then
      return pair.backspace.action(pair)
    end

    ::next::
  end

  return escape('<bs>')
end

function PairsActions.enter()

  -- get char left and right of the cursor
  local neighbours = M.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs) do

    -- skip if enter is not implemented
    if not pair.enter then
      goto next
    end

    if pair.enter.condition and pair.enter.condition() then
      return pair.enter.action(pair)
    end

    ::next::
  end

  return escape('<cr>')
end

function PairsActions.space()

  -- get char open.key and close.key of the cursor
  local neighbours = M.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs) do

    -- skip if space is not implemented
    if not pair.space then
      goto next
    end

    if pair.space.condition and pair.space.condition() then
      return pair.space.action(pair)
    end

    ::next::
  end

  return escape(' ')
end

return M
