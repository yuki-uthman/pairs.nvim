# pairs.nvim


## Next

### implementation
* change the condition to return the string to pass to actions
* change the actions to condition = function
* add utils function right_is_(regex)

### curly braces {}
* leave space after backspace
* insert another space on the other end even when there is key = value
  {|key = value} -> { key = value }
* delete space from the other end even when there is key = value
  { |key = value } -> {key = value}

### space
* deal with the return key when the user adds their own action
  either convert the space to cmd or return ""
