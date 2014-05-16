
local types = {
  ['string'] = [["%s"]],
  ['int']    = [["%d"]],
  ['double'] = [["%.2f"]],  -- reserve two digit
  ['array']  = [[%s]],
}
local function check_type(tpy)
  assert( tpy ~= nil )
  assert (types[tpy] ~= nil)
end

local function help_fmt(value, tpy)
  check_type(tpy)
  return string.format(types[tpy], value)
end

function element(key, value, typ)
  local ty
  if (typ == nil) then ty = 'string' else ty = typ  end  -- set default value
  local ele = string.format([==["%s":%s,]==], key, help_fmt(value, ty))
  return ele
end

function elements(t_eles)
  return table.concat(t_eles, "\n ")
end

function document(eles)
  local doc = [==[{
  %s
},]==]
  doc = string.format( doc, eles )
  return doc
end

function array(t_element)
  local ay = [==[
[
  %s
]]==]
  ay = string.format(ay, elements(t_element))
  return ay
end

function arrays(t_arrys)
  return table.concat(t_arrys, "\n ")
end

function root_document(eles)
  local doc = [==[{
  %s
}]==]
  doc = string.format( doc, eles )
  return doc
end

