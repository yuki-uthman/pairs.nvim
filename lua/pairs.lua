
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
  open = {
    key = "'",
    condition = function()
      return true
    end,
    action = function(self)
      local right = M.get_right_char()
      local left = M.get_left_char()

      if string.find(left, "[%a\\]") then
        return self.key

      elseif right == self.key then
        return M.keys.right

      else
        return "''" .. M.keys.left

      end
    end
  },

  close = {
    key = "'"
  },

  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,
}

local double_quote = {
  open = {
    key = "\"",

    condition = function()
      return true
    end,

    action = function(self)
      local right = M.get_right_char()
      local left = M.get_left_char()

      if string.find(left, "[\\]") then
        return self.key
      elseif right == self.key then
        return M.keys.right
      else
        return "\"\"" .. M.keys.left
      end
    end
  },

  close = {
    key = "\""
  },

  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,
}

local parenthesis = {
  open = {
    key = "(",

    condition = function()
      return true
    end,

    action = function()
      return "()" .. M.keys.left
    end
  },

  close = {
    key = ")",

    condition = function()
      return true
    end,

    action = function()
      local right = M.get_right_char()
      if right == ")" then
        return M.keys.right
      else
        return ")"
      end
    end
  },

  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,

  enter = {
    condition = function()

    end,

    action = function()
      local right = M.get_right_char()

      if right == ")" then
        return M.keys.enter .. M.keys.indent

      end

      return M.keys.enter .. M.keys.indent
    end
  },

  space = function()
    return "  " .. M.keys.left
  end
}

local curly_braces = {
  open = {
    key = "{",
    condition = function()
      return true
    end,
    action = function()
      return "{}" .. M.keys.left
    end
  },

  close = {
    key = "}",

    condition = function()
      return true
    end,

    action = function()
      local right = M.get_right_char()
      if right == "}" then
        return M.keys.right
      else
        return "}"
      end
    end
  },

  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,
  enter = function()
    return M.keys.enter .. M.keys.enter .. M.keys.up .. M.keys.indent
  end,
  space = function()
    return "  " .. M.keys.left
  end

}

function M.setup()
  -- Export module
  _G.Pairs = {
      ["'"] = single_quote,
      ["\""] = double_quote,
      ["("] = parenthesis,
      ["{"] = curly_braces,
  }

  -- Setup config

  -- Apply config
  M.apply_mappings()

end

function M.apply_mappings()

  for name, table in pairs(Pairs) do
    -- vim.api.nvim_set_keymap("i", table.open.key, "v:lua.Pairs." .. name .. ".open.action()", { expr = true, noremap = true } )
    local rhs = ("v:lua.PairsActions.open(\"\\%s\")"):format(table.open.key)
    vim.api.nvim_set_keymap("i", table.open.key, rhs, { expr = true, noremap = true } )

    if table.close.action then
      local rhs = ("v:lua.PairsActions.close(\"\\%s\")"):format(table.open.key)
      vim.api.nvim_set_keymap("i", table.close.key, rhs, { expr = true, noremap = true } )
      print(table.close.key .. " = " .. rhs)
    end
  end

  vim.api.nvim_set_keymap("i", "<bs>", "v:lua.PairsActions.backspace()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", "<cr>", "v:lua.PairsActions.enter()", { expr = true, noremap = true } )
  vim.api.nvim_set_keymap("i", " ", "v:lua.PairsActions.space()", { expr = true, noremap = true } )

end

local function get_neighbors()

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

function PairsActions.open( arg )

  -- return the pair table to open
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs[arg]

  -- configurable condition to open the pair
  -- different action can be triggered
  local condition = pair.open.condition 

  if condition then
    return pair.open:action(condition())
  else
    return arg
  end

end

function PairsActions.close( arg )

  -- return the pair table to close
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs[arg]

  -- configurable condition to close the pair
  -- different action can be triggered
  local condition = pair.close.condition 

  if condition then
    return pair.close:action(condition())
  else
    return arg
  end

end


function PairsActions.backspace()

  -- get char left and right of the cursor
  local neighbors = get_neighbors()
  print("neighbors = " .. neighbors)
  -- if the pair matches any pairs
  for _, pair in pairs(Pairs) do
    -- print(neighbors .. " == " .. pair.left .. pair.right)
    -- if pair.backspace and pair.backspace.condition then
    -- if pair.backspace.condition(line) then or just get the line inside the backspace.condition
    --    pair.backspace.action(which_action)
    if neighbors == pair.open.key .. pair.close.key and pair.backspace then
      return pair:backspace()
    end
  end
  return escape('<bs>')
end

function PairsActions.enter()

  -- get char left and right of the cursor
  local neighbors = get_neighbors()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs) do
    if neighbors == pair.open.key .. pair.close.key and pair.enter then
      return pair:enter()
    end
  end

  return escape('<cr>')
end

function PairsActions.space()

  -- get char open.key and close.key of the cursor
  local neighbors = get_neighbors()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs) do
    if neighbors == pair.open.key .. pair.close.key and pair.space then
      return pair:space()
    end
  end

  return escape(' ')
end

return M
