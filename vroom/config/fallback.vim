
lua << EOF

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

require 'pairs'.setup {

  fallback = {
    enter = function()
      utils.feedkey("-Enter-", "n")
    end,

    backspace = function()
      utils.feedkey("-Backspace-", "n")
    end,

    space = function()
      utils.feedkey("-Space-", "n")
    end

  }

}
