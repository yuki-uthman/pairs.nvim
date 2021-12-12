
lua << EOF

local global = {
    tags = {
      left = "<",
      right = ">"
    }
  }

require 'pairs'.setup {
  pairs = {
    global = global
  }
}
