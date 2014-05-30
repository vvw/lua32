
require 'std'
require './util/dir'

function filter(keyword, fns)
  local t = {}
  for _, v in ipairs(fns) do
    local dt = data(v)
    if ( string.match(dt, keyword) ~= nil) then
      t[#t+1] = v
    end
  end
  return t
end

local fns = fnames('*.lua', [[E:\luahaskells\luajit32\luasq\]])
local keyword = 'c_db'
local ns = filter(keyword, fns)
printkv(ns)
