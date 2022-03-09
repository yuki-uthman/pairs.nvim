local actions = require "pairz.default.actions"

local M = {}

M.new = function(opts)
  opts = opts or {}
  local self = setmetatable(opts, { __index = actions })

  return self
end

return M
