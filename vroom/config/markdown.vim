
lua << EOF

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

require 'pairs'.setup {
  pairs = {
    markdown = {
      star = {
        left = "*",
        right = "*",
      }
    }


  }
}
