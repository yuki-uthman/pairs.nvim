local default   = require "pairs.default.actions"

local single = require 'pairs.default.pairs.global.single'
local double = require 'pairs.default.pairs.global.double'
local round  = require 'pairs.default.pairs.global.round'
local curly  = require 'pairs.default.pairs.global.curly'
local tilda  = require 'pairs.default.pairs.global.tilda'




local M = {
  ["'"]  = single,
  ["\""] = double,
  ["("]  = round,
  ["{"]  = curly,
  ["`"]  = tilda,
}



return M
