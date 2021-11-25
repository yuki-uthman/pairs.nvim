
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

  open = function()
    local right = M.get_right_char()
    local left = M.get_left_char()

    if right == "'" then
      return M.keys.right

    elseif string.find(left, "[%a\\]") then
      return "'"

    else
      return "''" .. M.keys.left

    end

  end,
  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,
}

local double_quote = {
  left = "\"",
  right = "\"",

  open = function()
    local right = M.get_right_char()
    local left = M.get_left_char()

    if right == "\"" then
      return M.keys.right

    elseif string.find(left, "[\\]") then
      return "\""

    else
    return "\"\"" .. M.keys.left

    end
  end,
  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,
}

local parenthesis = {
  left = "(",
  right = ")",
  open = function()
    return "()" .. M.keys.left
  end,
  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,
  enter = function()
    return M.keys.enter .. M.keys.indent
  end,
  space = function()
    return "  " .. M.keys.left
  end

}

local curly_braces = {
  left = "{",
  right = "}",
  open = function()
    return "{}" .. M.keys.left
  end,
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

local tag = {
  left = "<",
  right = ">",
  open = function()
    return "<>" .. M.keys.left
  end,
  backspace = function()
    return M.keys.delete .. M.keys.backspace
  end,
  enter = function()
    return M.keys.enter .. M.keys.above .. M.keys.tab
  end
}

function M.setup()
  -- Export module
  _G.Pairs = {
      single_quote = single_quote,
      double_quote = double_quote,
      curly_braces = curly_braces,
      tag = tag,
  }

  -- Setup config

  -- Apply config
  M.apply_mappings()

end

function M.apply_mappings()

  for pair, table in pairs(Pairs) do
    vim.api.nvim_set_keymap("i", table.left, "v:lua.Pairs." .. pair .. ".open()", { expr = true, noremap = true } )
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

function PairsActions.backspace()

  -- get char left and right of the cursor
  local neighbors = get_neighbors()
  print("neighbors = " .. neighbors)
  -- if the pair matches any pairs
  for _, pair in pairs(Pairs) do
    print(neighbors .. " == " .. pair.left .. pair.right)
    if neighbors == pair.left .. pair.right and pair.backspace then
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
    if neighbors == pair.left .. pair.right and pair.enter then
      return pair:enter()
    end
  end

  return escape('<cr>')
end

function PairsActions.space()

  -- get char left and right of the cursor
  local neighbors = get_neighbors()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs) do
    if neighbors == pair.left .. pair.right and pair.space then
      return pair:space()
    end
  end

  return escape(' ')
end



-- vim.api.nvim_set_keymap("i", single_quote.left, single_quote:open(), { noremap = true } )
-- vim.api.nvim_set_keymap("i", tag.left, "v:lua.tag.open()", { expr = true, noremap = true } )
-- vim.api.nvim_set_keymap("i", "<bs>", "v:lua.close_pair()", { expr = true, noremap = true } )
-- vim.api.nvim_set_keymap("i", "<cr>", "v:lua.cr()", { expr = true, noremap = true } )


-- vim.api.nvim_set_keymap("i", "'", "v:lua.PairsActions.open()", { expr = true, noremap = true } )
-- vim.api.nvim_set_keymap("n", "<leader>p", "v:lua.PairsActions.get_cursor_neigh(0,1)", { expr = true, noremap = true } )
-- vim.api.nvim_set_keymap("i", ")", "hello<bs>", { noremap = true } )

-- print("'" .. M.get_arrow_key("left"))
return M
