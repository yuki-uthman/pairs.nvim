local actions  = require 'pairz.default.actions'
local fallback = require 'pairz.default.fallback'
local pairz    = require 'pairz.default.pairz'
local utils    = require 'pairz.utils'

local M = {}

local function find_pair(type)
  local filetype = vim.bo.filetype

  if pairz[filetype] == nil then return pairz["global"][type] end
  if pairz[filetype][type] == false then return nil end

  return pairz[filetype][type]
end

function open_action_for(pair)
  for number, condition in ipairs(pair.open.conditions) do
    if condition(pair) then
      return pair.open.actions[number]
    end
  end
end


function M.open(type)

  local pair = find_pair(type)

  if not pair then
    utils.feedkey(type, "n")
    return
  end

  local action = open_action_for(pair)
  if action then
    action(pair)
  else
    actions.open.actions.fallback(pair)
  end

end

function M.close(type)

  local pair = find_pair(type)
  if not pair then
    utils.feedkey(type, "n")
    return
  end

  for number, condition in ipairs(pair.close.conditions) do
    if condition(pair) then
      pair.close.actions[number](pair)
      return
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
          if condition(pair) then
            actions.backspace.actions[number](pair)
            return
          end
        end

        -- if no it is not an empty pair skip to the next pair
        goto next
      end

      for number, condition in ipairs(pair.backspace.conditions) do
        if condition(pair) then
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

    -- if the pair matches any pairz
    for name, pair in pairs(pairz[ft]) do

      -- skip if enter is not implemented
      if not pair or not pair.enter then
        goto next
      end

      for number, condition in ipairs(pair.enter.conditions) do
        if condition(pair) then
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

    -- if the pair matches any pairz
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
