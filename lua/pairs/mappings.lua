local actions  = require 'pairs.default.actions'
local fallback = require 'pairs.default.fallback'
local keys     = require 'pairs.keys'
local pairz    = require 'pairs.default.pairs'
local utils    = require 'pairs.utils'

local M = {}

local function find_pair(type)
  local ft = vim.bo.filetype
  local pair
  if pairz[ft] and pairz[ft][type] then
    pair = pairz[ft][type]
  elseif pairz["global"][type] then
    pair = pairz["global"][type]
  else
    pair = nil
  end

  return pair
end


function M.open(type)

  local pair = find_pair(type)
  if not pair then
    utils.feedkey(type, "n")
    return
  end

  if pair.open then
    for number, condition in ipairs(pair.open.conditions) do
      local condition = condition(pair)
      if condition then
        pair.open.actions[number](pair)
        return
      end
    end
  else
    for number, condition in ipairs(actions.open.conditions) do
      local condition = condition(pair)
      if condition then
        actions.open.actions[number](pair)
        return
      end
    end
  end

  actions.open.actions.fallback(pair)
end

function M.close(type)

  local pair = find_pair(type)
  if not pair then
    utils.feedkey(type, "n")
    return
  end

  if pair.close then
    for number, condition in ipairs(pair.close.conditions) do
      local condition = condition(pair)
      if condition then
        pair.close.actions[number](pair)
        return
      end
    end
  else
    for number, condition in ipairs(actions.close.conditions) do
      local condition = condition(pair)
      if condition then
        actions.close.actions[number](pair)
        return
      end
    end
  end

  utils.feedkey(pair.right, "n")
end

function M.backspace()

  local neighbours = utils.get_neighbours()

  for _, pair in pairs(global) do

    -- if custom backspace is not implemented
    if not pair.backspace then

      -- check for default backspace conditions
      -- ie. if it is an empty pair
      for number, condition in ipairs(actions.backspace.conditions) do
        local condition = condition(pair)
        if condition then
          actions.backspace.actions[number](pair)
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
  for _, pair in pairs(global) do

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
  for _, pair in pairs(global) do

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
