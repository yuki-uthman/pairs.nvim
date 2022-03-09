
lua << EOF

local utils = require 'pairz.utils'
local keys  = require 'pairz.keys'

require 'pairz'.setup {
  pairz = {
    global = {
      ["("] = false,
    },

    markdown = {
      ["{"] = false,
    }
  }
}
