
require('std')
require('./mongo/json')

local MONGOPATH = './mongo/'
local FNAMECMD = 'dbshell'
local FNAMBAT = MONGOPATH .. 'cmd.bat'

function element_appName()
  local t_element = {
    element('AppEName', 'fgmsC0hHPA'),
    element('AppName', '医学高级职称考试宝典(内科学)'),
  }
  return elements(t_element)
end

-- 来源
function element_source()
  local t_element = {
    element('Source', '习题集'),
    element('Sortid', '1'),
  }
  local key   = "Source";
  local value = array(t_element)
  local t_array_elements = {
    element(key, value, 'array'),
  }
 local ele_src = elements(t_array_elements)
 return ele_src
end

function element_chapter(Chapter, Sortid)
  local t = {
    element("Chapter", Chapter),
    element("Sortid",  Sortid),
  }
  return elements(t)
end

function element_subject(Subject, Sortid)
  local t = {
    element("Subject", Subject),
    element("Sortid",  Sortid),
  }
  return elements(t)
end

function root_chapter()
  local t = {
    document ( element_chapter ("呼吸系统疾病(单项选择题1)", "1") ),
    document ( element_chapter ("呼吸系统疾病(单项选择题2)", "2") ),
  }
  return element ("Chapter", array(t), 'array' )
end

function root_sbject()
  local t = {
    document ( element_subject ("章节练习题1", "1") ),
    document ( element_subject ("章节练习题2", "2") ),
  }
  return element ("Subject", array(t), 'array' )
end

local t_root_elements = {
  element_appName(),
  element_source(),
}

function doc()
  local doc = root_document( elements(t_root_elements) ) 
  return doc
end

--print (doc())

function doc_find()
local fnd = [==[
{"Source.Sortid": 2}, 
{  
  _id: 0,
  "Source.Subject": 0,
  "Source.Subject.Chapter": 0,
  Source: { $elemMatch: {Sortid: 2} }
}
]==]

  return fnd
end

function writecmd()
local cmd = [==[
use tt
db.dropDatabase()
use tt
var doc = %s
db.tt.insert(doc)
db.tt.find()
//db.tt.find().count()
// db.dropDatabase()
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
--  
writebat(FNAMBAT)
writecmd()

--print (document(element('AppEName', 'fgmsC0hHPA')))


 

