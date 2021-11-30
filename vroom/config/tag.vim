
lua << EOF

local custom_pair = {
    tags = {
      left = "<",
      right = ">"
    }
  }

require 'pairs'.setup {
  pairs = custom_pair
}
