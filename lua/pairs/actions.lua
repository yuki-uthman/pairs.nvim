local default  = require 'pairs.default.actions'
local fallback = require 'pairs.default.fallback'
local helper   = require 'pairs.helper'
local keys     = require 'pairs.keys'

M = {}

function M.open(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs.pairs[type]

  if pair.open and pair.open.action then
    return pair.open.action(pair)
  else
    return default.open(pair)
  end

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

    -- if custom backspace is not implemented
    -- check for fallback backspace condition
    if not pair.backspace then
      if default.backspace.condition(pair) then
        return default.backspace.action(pair)
      end
      goto next
    end

    if pair.backspace.condition and pair.backspace.condition() then
      return pair.backspace.action(pair)
    end

    ::next::
  end

  if fallback.backspace then
    return fallback.backspace()
  else
    return keys.backspace
  end

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

  if fallback.enter then
    return fallback.enter()
  else
    return keys.enter
  end
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

  if fallback.space then
    return fallback.space()
  else
    return keys.space
  end
end

return M
