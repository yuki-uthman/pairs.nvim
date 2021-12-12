local global   = require 'pairs.default.pairs.global'
local fallback = require 'pairs.default.fallback'

local M = {
  pairs    = {
    global = global
  },
  fallback = fallback
}

return M
