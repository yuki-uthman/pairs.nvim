
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


function M.get_line(offset)

  local row  = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, row + offset - 1, row + offset, false)[1]

  return line
end

function M.get_line_before_cursor()

  local offset = 0
  local cursor  = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_buf_get_lines(0, row + offset - 1, row + offset, false)[1]

  local before_cursor = string.sub(line, 1, col)

  return before_cursor
end

function M.get_line_after_cursor()

  local offset = 0
  local cursor  = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_buf_get_lines(0, row + offset - 1, row + offset, false)[1]

  local after_cursor = string.sub(line, col + 1, -1)

  return after_cursor
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode, true)
end

function M.escape(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

function M.trim(input)
  if not input then
    return false
  end
  return string.match(input, '^%s*(.-)%s*$')
end

function M.right_char_match(regex)
  local right  = M.get_right_char()
  return string.match(right, regex)
end

function M.left_char_match(regex)
  local left  = M.get_left_char()
  return string.match(left, regex)
end

function M.right_of_cursor_match(regex)
  local string = M.get_line_after_cursor()
  return string.match(string, regex)
end

function M.left_of_cursor_match(regex)
  local string = M.get_line_before_cursor()
  return string.match(string, regex)
end

function M.above_match(regex)

  local above = M.get_line(-1)
  if not above then
    return false
  end

  local match = string.match(above, regex)
  if not match then
    return false
  end

  return match
end

function M.below_match(regex)

  local below = M.get_line(1)
  if not below then
    return false
  end

  local match = string.match(above, regex)
  if not match then
    return false
  end

  return match
end

return M
