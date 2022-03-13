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

  fallback.open(pair)

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

function M.execute(key)
  for _, filetype in pairs({get_current_filetype(), "global"}) do

    if filetypeEnabled(filetype) then
      for _, pair in pairs(pairz[filetype]) do

        if pair and pair[key] then
          local executed = pair:execute(key)
          if executed then return end
        end

      end
    end
  end

  fallback[key]()
end

function M.backspace()
  M.execute("backspace")
end

function M.enter()
  M.execute("enter")
end

function M.space()
  M.execute("space")
end

function get_current_filetype()
  return vim.bo.filetype
end

function filetypeEnabled(filetype)
  if pairz[filetype] then
    return true
  end
end

return M
