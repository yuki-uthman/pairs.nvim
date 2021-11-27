local helper = require 'pairs.helper'
local keys    = require 'pairs.keys'

M = {}

function M.open(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs.pairs[type]

  return pair.open.action(pair)

end

function M.close(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs.pairs[type]

  return pair.close.action(pair)

end


function M.backspace()

  local neighbours = helper.get_neighbours()

  for _, pair in pairs(Pairs.pairs) do

    -- skip if backspace is not implemented
    if not pair.backspace then
      goto next
    end

    if pair.backspace.condition and pair.backspace.condition() then
      return pair.backspace.action(pair)
    end

    ::next::
  end

  return keys.backspace
end

function M.enter()

  -- get char left and right of the cursor
  local neighbours = helper.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs.pairs) do

    -- skip if enter is not implemented
    if not pair.enter then
      goto next
    end

    if pair.enter.condition and pair.enter.condition() then
      return pair.enter.action(pair)
    end

    ::next::
  end

  return keys.enter
end

function M.space()

  -- get char open.key and close.key of the cursor
  local neighbours = helper.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs.pairs) do

    -- skip if space is not implemented
    if not pair.space then
      goto next
    end

    if pair.space.condition and pair.space.condition() then
      return pair.space.action(pair)
    end

    ::next::
  end

  return keys.space
end

return M
