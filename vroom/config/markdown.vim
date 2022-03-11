
lua << EOF

local core  = require 'pairz.core'

local star = core:new { left = "*", right = "*" }

require 'pairz'.setup {
  pairz = {
    markdown = {
      ["*"] = star
    }
  }
}
