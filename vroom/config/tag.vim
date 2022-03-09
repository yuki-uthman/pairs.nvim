
lua << EOF

local core  = require 'pairz.core'

local tag = core.new { left = "<", right = ">" }

require 'pairz'.setup {
  pairz = {
    global = {
      ["<"] = tag
    }
  }
}
