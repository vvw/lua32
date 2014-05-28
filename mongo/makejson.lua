
require('std')
require('./luasq/sq')

---[[
local dbname = "./luasq/db/Maindb.db01"
local isExist = sqIsDbExsit(dbname)
print (isExist)
local c_db, c_rc = sqOpenWrite(dbname)
assert(c_rc == SQOK)
assert(c_db ~= nil)
local tnames = sqTableNames(c_db)
local atest_sql = sqColumnNames(c_db, 'ATest')
--printkv(tnames)
local sq = [==[update AppInfo set AgentVersion = 'aaaabbbcccc']==]
sqExec(c_db, sq)
--print ( sqIsTableExist(c_db, 'AppInfo') )
--]]

print('hi')




