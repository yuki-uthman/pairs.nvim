
lua << EOF

local core  = require 'pairs.core'

local tag = core.new { left = "<", right = ">" }

require 'pairs'.setup {
  pairs = {
    global = {
      ["<"] = tag
    }
  }
}
