--[[--
dir /b /s /a:-D %cd%\*.lua
     # /b       simple output
     # /s       recurrent iterate
     # /a:-D    just files, no directory
     # /a:D     just directory, no files
     # %cd%     current directory
     # *.lua    just xx.lua files
--]]--

require 'std'

-- return all files name of current dir and it's subdir 
-- arguments
--     example: '*.lua'
function fnames(filespattern, dir)
  local t = {}
  local cmd = [==[
    dir /b /s /a:-D ]==]
  local dr = dir or [[%cd%\]]
  cmd = cmd .. dr .. filespattern
  local f = io.popen(cmd) 
  for line in f:lines() do t[#t+1] = line end
  return t
end

local function test()
  local t = fnames('*.lua')
  printkv(t)
end

--test()


