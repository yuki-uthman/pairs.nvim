local pairz = require 'pairs.default.pairs'

local default  = require 'pairs.default.actions'
local fallback = require 'pairs.default.fallback'
local utils    = require 'pairs.utils'
local keys     = require 'pairs.keys'

local M = {}

function M.open(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = pairz[type]

  if pair.open then
    for number, condition in ipairs(pair.open.conditions) do
      local condition = condition(pair)
      if condition then
        pair.open.actions[number](pair)
        return
      end
    end
  else
    for number, condition in ipairs(default.open.conditions) do
      local condition = condition(pair)
      if condition then
        default.open.actions[number](pair)
        return
      end
    end
  end

  default.open.actions.fallback(pair)
end

function M.close(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = pairz[type]

  if pair.close then
    for number, condition in ipairs(pair.close.conditions) do
      local condition = condition(pair)
      if condition then
        pair.close.actions[number](pair)
        return
      end
    end
  else
    for number, condition in ipairs(default.close.conditions) do
      local condition = condition(pair)
      if condition then
        default.close.actions[number](pair)
        return
      end
    end
  end

  utils.feedkey(pair.right, "n")
end

function M.backspace()

  local neighbours = utils.get_neighbours()

  for _, pair in pairs(pairz) do

    -- if custom backspace is not implemented
    if not pair.backspace then

      -- check for default backspace conditions
      -- ie. if it is an empty pair
      for number, condition in ipairs(default.backspace.conditions) do
        local condition = condition(pair)
        if condition then
          default.backspace.actions[number](pair)
          return
        end
      end

      -- if no it is not an empty pair skip to the next pair
      goto next
    end

    for number, condition in ipairs(pair.backspace.conditions) do
      local condition = condition(pair)
      if condition then
        pair.backspace.actions[number](pair)
        return
      end
    end

    ::next::
  end

  fallback.backspace()
end

function M.enter()

  -- get char left and right of the cursor
  local neighbours = utils.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(pairz) do

    -- skip if enter is not implemented
    if not pair.enter then
      goto next
    end

    for number, condition in ipairs(pair.enter.conditions) do
      local condition = condition(pair)
      if condition then
        pair.enter.actions[number](pair)
        return
      end
    end

    ::next::
  end

  fallback.enter()
end

function M.space()

  -- get char open.key and close.key of the cursor
  local neighbours = utils.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(pairz) do

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
