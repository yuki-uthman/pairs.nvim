
lua << EOF

local global = {
    ["<"] = {
      left = "<",
      right = ">"
    }
  }

require 'pairs'.setup {
  pairs = {
    global = global
  }
}
