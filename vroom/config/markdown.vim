
lua << EOF

local core  = require 'pairs.core'

local star = core.new { left = "*", right = "*" }

require 'pairs'.setup {
  pairs = {
    markdown = {
      ["*"] = star
    }
  }
}
