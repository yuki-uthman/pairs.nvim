local default  = require 'pairs.default.actions'
local fallback = require 'pairs.default.fallback'
local utils    = require 'pairs.utils'
local keys     = require 'pairs.keys'

local M = {}

function M.open(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs.pairs[type]

  if pair.open then
    for number, condition in ipairs(pair.open.conditions) do
      local condition = condition(pair)
      if condition then
        return pair.open.actions[number](pair)
      end
    end
  else
    for number, condition in ipairs(default.open.conditions) do
      local condition = condition(pair)
      if condition then
        return default.open.actions[number](pair)
      end
    end
  end

  return default.open.actions.fallback(pair)

end

function M.close(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs.pairs[type]

  if pair.close then

    for _, condition in ipairs(pair.close.conditions) do
      local condition = condition(pair)
      if condition then
        return pair.close.actions[condition](pair)
      end
    end

  else
    for _, condition in ipairs(default.close.conditions) do
      local condition = condition(pair)
      if condition then
        return default.close.actions[condition](pair)
      end
    end
  end

  return pair.right
end

function M.backspace()

  local neighbours = utils.get_neighbours()

  for _, pair in pairs(Pairs.pairs) do

    -- if custom backspace is not implemented
    if not pair.backspace then

      -- check for default backspace condition
      if default.backspace.condition(pair) then
        return default.backspace.action(pair)
      end

      -- if no default backspace skip to the next pair
      goto next
    end

    for _, condition in ipairs(pair.backspace.conditions) do
      local condition = condition(pair)
      if condition then
        return pair.backspace.actions[condition](pair)
      end
    end

    ::next::
  end

  return fallback.backspace()

end

function M.enter()

  -- get char left and right of the cursor
  local neighbours = utils.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs.pairs) do

    -- skip if enter is not implemented
    if not pair.enter then
      goto next
    end

    for _, condition in ipairs(pair.enter.conditions) do
      local condition = condition(pair)
      if condition then
        return pair.enter.actions[condition](pair)
      end
    end

    ::next::
  end

  return fallback.enter()
end

function M.space()

  -- get char open.key and close.key of the cursor
  local neighbours = utils.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs.pairs) do

    -- skip if space is not implemented
    if not pair.space then
      goto next
    end

    for _, condition in ipairs(pair.space.conditions) do
      local condition = condition(pair)
      if condition then
        return pair.space.actions[condition](pair)
      end
    end

    ::next::
  end

  return fallback.space()
end

return M
