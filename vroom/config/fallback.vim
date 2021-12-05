
lua << EOF

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

require 'pairs'.setup {

  fallback = {
    enter = function()

      return "<Enter>"
    end,

    backspace = function()

      return "<Backspace>"
    end,

    space = function()

      return "<Space>"
    end

  }

}
