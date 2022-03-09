
lua << EOF

local utils = require 'pairz.utils'
local keys  = require 'pairz.keys'

require 'pairz'.setup {

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
