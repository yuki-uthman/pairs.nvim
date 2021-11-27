
local function escape(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

M = {
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

return M
