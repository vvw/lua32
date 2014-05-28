
require('./mongo/json')

function arrElm()
  local t = {}
  t[#t+1] = value(1, 'int')
  t[#t+1] = value(2, 'int')
  t[#t+1] = value(3, 'int')
  return element ('array', array ( values(t) ), 'array')
end

function docElm()
  local t = {}
  t[#t+1] = element('a', 'b')
  t[#t+1] = element('c', 'd')
  t[#t+1] = element('e', 'f')
  return element ('object', document ( elements(t) ), 'doc');
end
 
local t = {}
t[#t+1] = arrElm()
t[#t+1] = element('boolean', 'true', 'boolean')
t[#t+1] = element('null', 'null', 'null')
t[#t+1] = element('number', '123', 'int')
t[#t+1] = docElm()
t[#t+1] = element('string', 'Hello, World!')

print ( document ( elements(t) ) )
 



