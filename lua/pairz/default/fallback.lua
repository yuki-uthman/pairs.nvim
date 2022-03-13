local keys           = require 'pairz.keys'
local utils          = require 'pairz.utils'
local custom_actions = require 'pairz.custom.actions'

local M = {}

M.open = custom_actions.open_pair

M.enter = function()
  utils.feedkey("<CR>", "n")
end

M.backspace = function()
  utils.feedkey("<BS>", "n")
end

M.space = function()
  utils.feedkey("<Space>", "n")
  -- return keys.space
end

return M
