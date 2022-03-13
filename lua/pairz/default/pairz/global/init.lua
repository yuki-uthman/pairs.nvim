local single = require 'pairz.default.pairz.global.single'
local double = require 'pairz.default.pairz.global.double'
local round  = require 'pairz.default.pairz.global.round'
local curly  = require 'pairz.default.pairz.global.curly'
local tilda  = require 'pairz.default.pairz.global.tilda'




local M = {
  ["'"]  = single,
  ["\""] = double,
  ["("]  = round,
  ["{"]  = curly,
  ["`"]  = tilda,
}



return M
