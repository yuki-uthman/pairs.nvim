local keys  = require 'pairs.keys'
local utils = require 'pairs.utils'

local M = {}

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode, true)
end

M.enter = function()

  feedkey("<CR>", "n")
  feedkey("<Plug>DiscretionaryEnd" , "")

  return ""
end



return M
