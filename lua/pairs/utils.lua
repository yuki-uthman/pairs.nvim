
local M = {}

function M.get_neighbours(len)

  len = len or 1

  return M.get_left_char(len) .. M.get_right_char(len)
end

function M.get_right_char(len)

  len = len or 1

  local line = vim.api.nvim_get_current_line()
  local col  = vim.api.nvim_win_get_cursor(0)[2]

  local right = vim.fn.strpart(line, col, len)

  return right
end

function M.get_left_char(len)

  len = len or 1

  local line = vim.api.nvim_get_current_line()
  local col  = vim.api.nvim_win_get_cursor(0)[2]

  local left  = vim.fn.strpart(line, col - len, len)

  return left
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode, true)
end

function M.escape(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

return M
