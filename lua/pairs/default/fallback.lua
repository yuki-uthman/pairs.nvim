local keys  = require 'pairs.keys'
local utils = require 'pairs.utils'

local M = {}

M.enter = function()
  return keys.enter
end

M.backspace = function()
  return keys.backspace
end

M.space = function()
  return keys.space
end

return M
