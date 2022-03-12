local default_actions = require 'pairz.default.actions'
local fallback        = require 'pairz.default.fallback'
local pairz           = require 'pairz.default.pairz'
local utils           = require 'pairz.utils'

local M = {}

function M.open(type)

  local pair = find_pair(type)

  if not pair then
    utils.feedkey(type, "n")
    return
  end

  local executed = pair:execute("open")
  if executed then return end

  default_actions.open.actions.fallback(pair)

end

function M.close(type)

  local pair = find_pair(type)
  if not pair then
    utils.feedkey(type, "n")
    return
  end

  local executed = pair:execute("close")
  if executed then return end

  utils.feedkey(pair.right, "n")
end

function find_pair(type)
  if pairz[get_current_filetype()] == nil then return pairz["global"][type] end
  if pairz[get_current_filetype()][type] == false then return nil end

  return pairz[get_current_filetype()][type]
end


function M.backspace()

  for _, filetype in pairs({get_current_filetype(), "global"}) do

    -- filetype not found
    if not pairz[filetype] then goto global end

    for _, pair in pairs(pairz[filetype]) do

      if pair then
        local executed = pair:execute("backspace")
        if executed then return end
      end

    end

    ::global::
  end

  fallback.backspace()
end

function M.enter()

  for _, ft in pairs({get_current_filetype(), "global"}) do

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

      local executed = pair:execute("enter")
      if executed then return end

      ::next::
    end

    ::to_global::
  end

  fallback.enter()
end

function M.space()

  for _, ft in pairs({get_current_filetype(), "global"}) do

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

function get_current_filetype()
  return vim.bo.filetype
end

return M
