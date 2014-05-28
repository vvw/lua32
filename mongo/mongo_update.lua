
require('std')

local MONGOPATH = './mongo/'
local FNAMECMD = 'dbshell'
local FNAMBAT = MONGOPATH .. 'cmd.bat'

function cmd_usedb(dbname)
  assert(dbname ~= nil)
local cmd = [[
use %s
db.dropDatabase()
use %s]]
return string.format(cmd, dbname, dbname)
end

function cmd_insert(collection, doc)
  assert(collection ~= nil and doc ~= nil)
local cmd = [[
var doc = %s
db.%s.insert(doc)]]
  return string.format( cmd, doc, collection )
end

function cmd_find(collection)
  assert(collection ~= nil)
local cmd = [[
db.%s.find()]]
  cmd = string.format(cmd, collection)
  return cmd
end

print (cmd_usedb('tt'))
print (cmd_insert('tt', '{}'))
print (cmd_find('tt'))

function writecmd()
local cmd = [==[
use tt
db.dropDatabase()
use tt
var doc = %s
db.tt.insert(doc)
db.tt.find()
//db.tt.find().count()
db.tt.find(%s)
]==]
  cmd = string.format(cmd, doc(), doc_find())
  local fname = MONGOPATH .. FNAMECMD
  dataWrite(fname, cmd)
  --print (cmd)
end

function writebat(fname_bat)
  local bat = [==[
@echo off
set NODEJS_HOME=D:\js32\nodejs
set NODE_PATH=%NODEJS_HOME%\node_modules
set path=%path%;%NODEJS_HOME%;C:\Program Files\MongoDB 2.6 Standard\bin
rem cmd.exe
@echo on
mongo<dbshell
pause
]==]
  dataWrite(fname_bat, bat)
end

local doc = [==[
{
 id: 1, 
 forecasts: [ { 
             forecast_id: 123, 
             name: "Forecast 1", 
             levels: [ 
                { level: "proven", 
                  configs: [
                            { 
                              config: "Custom 1",
                              variables: [{ x: 1, y:2, z:3}]
                            }, 
                            { 
                              config: "Custom 2",
                              variables: [{ x: 10, y:20, z:30}]
                            }, 
                    ]
                }, 
                { level: "likely", 
                  configs: [
                            { 
                              config: "Custom 1",
                              variables: [{ x: 1, y:2, z:3}]
                            }, 
                            { 
                              config: "Custom 2",
                              variables: [{ x: 10, y:20, z:30}]
                            }, 
                    ]
                }
            ]
        }, 
    ]
}
]==]


