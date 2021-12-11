local keys  = require 'pairs.keys'
local utils = require 'pairs.utils'

local M = {}

M.enter = function()
  utils.feedkey("<CR>", "n")
end

M.backspace = function()
  utils.feedkey("<BS>", "n")
end

M.space = function()
  return keys.space
end

return M
