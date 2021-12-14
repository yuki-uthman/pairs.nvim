local actions  = require 'pairs.default.actions'
local fallback = require 'pairs.default.fallback'
local keys     = require 'pairs.keys'
local pairz    = require 'pairs.default.pairs'
local utils    = require 'pairs.utils'

local M = {}

local function find_pair(type)
  local ft = vim.bo.filetype
  local pair

  if pairz[ft] == nil then
    pair = pairz["global"][type]
  elseif pairz[ft][type] == false then
    pair = nil
  else
    pair = pairz[ft][type]
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

  for _, ft in pairs({vim.bo.filetype, "global"}) do

    -- filetype not found
    if not pairz[ft] then
      goto to_global
    end

    for _, pair in pairs(pairz[ft]) do

      -- pair has been disabled
      if not pair then
        goto next
      end
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

    ::to_global::
  end

  fallback.backspace()
end

function M.enter()

  for _, ft in pairs({vim.bo.filetype, "global"}) do

    -- filetype not found
    if not pairz[ft] then
      goto to_global
    end

    -- if the pair matches any pairs
    for name, pair in pairs(pairz[ft]) do

      -- skip if enter is not implemented
      if not pair or not pair.enter then
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

    ::to_global::
  end

  fallback.enter()
end

function M.space()

  for _, ft in pairs({vim.bo.filetype, "global"}) do

    -- filetype not found
    if not pairz[ft] then
      goto to_global
    end

    -- if the pair matches any pairs
    for _, pair in pairs(pairz[ft]) do

      -- skip if space is not implemented
      if not pair or not pair.space then
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

    ::to_global::
  end

  fallback.space()
end

return M
