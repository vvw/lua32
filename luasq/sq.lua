
local SQLITE_DLL    = "./luasq/libs/sqlite-201405071546.dll"
local SQLITE_HEADER = "./luasq/include/sqlite3.h"

require "std"
local bit = require "bit"
local ffi = require "ffi"
local lq = ffi.load(SQLITE_DLL)
ffi.cdef( data(SQLITE_HEADER) )
local new_db_ptr = ffi.typeof("sqlite3*[1]")
local new_stmt_ptr = ffi.typeof("sqlite3_stmt*[1]")  -- sqlite3_stmt **ppStmt  -- new_stmt_ptr()[0] = sqlite3_stmt*
local new_exec_ptr = ffi.typeof("int (*)(void*,int,char**,char**)")
local new_blob_ptr = ffi.typeof("sqlite3_blob*[1]")
local new_bytearr = ffi.typeof("uint8_t[?]")
local sqlite3_transient = ffi.cast("void*",-1)

local ResultCodes = {
    [lq.SQLITE_OK]          = "SQLITE_OK           0   /* Successful result */",
    [lq.SQLITE_ERROR]       = "SQLITE_ERROR        1   /* SQL error or missing database */",
    [lq.SQLITE_INTERNAL]    = "SQLITE_INTERNAL     2   /* Internal logic error in SQLite */",
    [lq.SQLITE_PERM]        = "SQLITE_PERM         3   /* Access permission denied */",
    [lq.SQLITE_ABORT]       = "SQLITE_ABORT        4   /* Callback routine requested an abort */",
    [lq.SQLITE_BUSY]        = "SQLITE_BUSY         5   /* The database file is locked */",
    [lq.SQLITE_LOCKED]      = "SQLITE_LOCKED       6   /* A table in the database is locked */",
    [lq.SQLITE_NOMEM]       = "SQLITE_NOMEM        7   /* A malloc() failed */",
    [lq.SQLITE_READONLY]    = "SQLITE_READONLY     8   /* Attempt to write a readonly database */",
    [lq.SQLITE_INTERRUPT]   = "SQLITE_INTERRUPT    9   /* Operation terminated by sqlite3_interrupt()*/",
    [lq.SQLITE_IOERR]       = "SQLITE_IOERR       10   /* Some kind of disk I/O error occurred */",
    [lq.SQLITE_CORRUPT]     = "SQLITE_CORRUPT     11   /* The database disk image is malformed */",
    [lq.SQLITE_NOTFOUND]    = "SQLITE_NOTFOUND    12   /* Unknown opcode in sqlite3_file_control() */",
    [lq.SQLITE_FULL]        = "SQLITE_FULL        13   /* Insertion failed because database is full */",
    [lq.SQLITE_CANTOPEN]    = "SQLITE_CANTOPEN    14   /* Unable to open the database file */",
    [lq.SQLITE_PROTOCOL]    = "SQLITE_PROTOCOL    15   /* Database lock protocol error */",
    [lq.SQLITE_EMPTY]       = "SQLITE_EMPTY       16   /* Database is empty */",
    [lq.SQLITE_SCHEMA]      = "SQLITE_SCHEMA      17   /* The database schema changed */",
    [lq.SQLITE_TOOBIG]      = "SQLITE_TOOBIG      18   /* String or BLOB exceeds size limit */",
    [lq.SQLITE_CONSTRAINT]  = "SQLITE_CONSTRAINT  19   /* Abort due to constraint violation */",
    [lq.SQLITE_MISMATCH]    = "SQLITE_MISMATCH    20   /* Data type mismatch */",
    [lq.SQLITE_MISUSE]      = "SQLITE_MISUSE      21   /* Library used incorrectly */",
    [lq.SQLITE_NOLFS]       = "SQLITE_NOLFS       22   /* Uses OS features not supported on host */",
    [lq.SQLITE_AUTH]        = "SQLITE_AUTH        23   /* Authorization denied */",
    [lq.SQLITE_FORMAT]      = "SQLITE_FORMAT      24   /* Auxiliary database format error */",
    [lq.SQLITE_RANGE]       = "SQLITE_RANGE       25   /* 2nd parameter to sqlite3_bind out of range */",
    [lq.SQLITE_NOTADB]      = "SQLITE_NOTADB      26   /* File opened that is not a database file */",
    [lq.SQLITE_NOTICE]      = "SQLITE_NOTICE      27   /* Notifications from sqlite3_log() */",
    [lq.SQLITE_WARNING]     = "SQLITE_WARNING     28   /* Warnings from sqlite3_log() */",
    [lq.SQLITE_ROW]         = "SQLITE_ROW         100  /* sqlite3_step() has another row ready */",
    [lq.SQLITE_DONE]        = "SQLITE_DONE        101  /* sqlite3_step() has finished executing */",
}

local SQOK   = lq.SQLITE_OK
local SQROW  = lq.SQLITE_ROW
local SQDONE = lq.SQLITE_DONE

function check_stmt(stmtpp)
  assert(stmtpp    ~= nil) -- sqlite3_stmt **
  assert(stmtpp[0] ~= nil) -- sqlite3_stmt *
end

function check_stmt_icol(stmtpp, iCol)
  check_stmt(stmtpp)
  assert (iCol ~= nil and iCol >= 0)
end

function SQMG(c_db)
  local cd  = lq.sqlite3_errcode(c_db)
  assert(ResultCodes[cd] ~= nil)
  local msg = ResultCodes[cd]
  return msg
end

function sqFinalize(stmtpp)
  lq.sqlite3_finalize(stmtpp[0])
end

local mode = {
    ["read"]    = lq.SQLITE_OPEN_READONLY,
    ["write"]   = bit.bor(lq.SQLITE_OPEN_READWRITE),
    ["create"]  = bit.bor(lq.SQLITE_OPEN_READWRITE, lq.SQLITE_OPEN_CREATE),
}
function sqOpen_(dbname, mode)
  local c_db = new_db_ptr()  -- sqlite3 **
  local  c_rc = lq.sqlite3_open_v2(dbname, c_db, mode, nil);
  assert(c_db[0] ~= nil)     -- sqlite3 *
  return c_db[0], c_rc
end

function sqOpenRead(dbname)
  local c_db, c_rc = sqOpen_(dbname, mode.read)
  if( c_rc ~= SQOK ) then DBERR("Can't open database: %s", dbname) end
  DBLOG("open db readonly: %s", dbname)
  return c_db, c_rc
end

function sqOpenWrite(dbname)
  local c_db, c_rc = sqOpen_(dbname, mode.write)
  if( c_rc ~= SQOK ) then DBERR("Can't open database: %s", dbname) end
  DBLOG("open db readWrite: %s", dbname)
  return c_db, c_rc
end

function sqOpenCreate(dbname)
  local c_db, c_rc = sqOpen_(dbname, mode.create)
  if( c_rc ~= SQOK ) then DBERR("Can't open database: %s", dbname) end
  DBLOG("open db readWrite_create: %s", dbname)
  return c_db, c_rc
end

function sqIsDbExsit(dbname)
  local c_db, rc = sqOpen_(dbname, mode.read)
  if( rc == SQOK ) then
    lq.sqlite3_close(c_db);
    return true
  end
  return false
end

function sqPrepare_( c_db,    -- Database handle
                     sq,      -- SQL statement, UTF-8 encoded
                     stmtptr  -- sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
         )
  assert(c_db ~= nil and sq ~= nil and stmtptr ~= nil)
  local rc = lq.sqlite3_prepare_v2(c_db, sq, -1, stmtptr, nil);
  if (rc ~= SQOK) then
    DBERR("Error in sqPrepare():  %s", SQMG(c_db))
  end
  return rc
end

function sqPrepare(c_db, sq)
  local stmtpp = new_stmt_ptr()
  local rc = sqPrepare_(c_db, sq, stmtpp)
  check_stmt(stmtpp)
  assert(rc == SQOK)
  return stmtpp
end

function sqStep(c_db, stmtpp)
  assert(c_db ~= nil)
  check_stmt(stmtpp)
  local rc = lq.sqlite3_step(stmtpp[0])
  check_step(rc, stmtpp)
  --[[
  if (rc ~= SQROW and
     rc ~= SQDONE and 
     rc ~= SQOK) 
  then  
     DBERR("Error: %s in sqStep()", SQMG(c_db))
  end--]]
  return rc
end

function check_step(rc, stmtpp)
  assert (rc ~= nil and stmtpp ~= nil)
    if (rc ~= SQROW and
     rc ~= SQDONE and 
     rc ~= SQOK) 
  then
     sqFinalize(stmtpp);
     DBERR("Error: %s in sqStep()", SQMG(c_db))
     os.exit()
  end
end

function sqExec(c_db, sq)
  local stmtpp = sqPrepare(c_db, sq)  -- sqlite3_stmt **
  check_stmt(stmtpp)
  rc = sqStep(c_db, stmtpp)
  check_step(rc, stmtpp)
  --if (rc ~= SQDONE) then DBERR("Error in sqExec():  %s", SQMG(c_db)); sqFinalize(stmtpp) end
  sqFinalize(stmtpp)
  return rc
end

function sqColumnCount(stmtpp)
  return lq.sqlite3_column_count(stmtpp[0]);
end

local vlaue_types_ = {
  ['int']  = '',
  ['text'] = '',
}
local column_vlaue_function = {
  ['int']  = lq.sqlite3_column_int,
  ['text'] = lq.sqlite3_column_text,
}
function sqColumnValue(stmtpp, iCol, typ)
  check_stmt_icol(stmtpp, iCol)
  assert(vlaue_types_[typ] ~= nil)
  local v = (column_vlaue_function[typ])(stmtpp[0], iCol)
  return v
end

function sqColumnBytes(stmtpp, iCol)
  check_stmt_icol(stmtpp, iCol)
  return lq.sqlite3_column_bytes(stmtpp[0], iCol)
end

function sqValue(stmtpp, iCol, typ)
  local v = sqColumnValue(stmtpp, iCol, typ)
  local nbytes = sqColumnBytes(stmtpp, iCol)
  return v, nbytes
end

function help_prepare_and_step(c_db, sq)
  local stmtpp = sqPrepare(c_db, sq)
  check_stmt(stmtpp)
  local rc = sqStep(c_db, stmtpp)
  return rc, stmtpp
end

function isHasRow(rc)
  if (rc == SQROW) then return true end
  return false
end

function isHasCol(stmtpp)
  local ncol  = sqColumnCount(stmtpp)
  return ( ncol > 0 )
end

function isHasValue(stmtpp, iCol, typ)
  local n, nbytes = sqValue(stmtpp, iCol, typ)
  return ( nbytes > 0 )
end

function sqIsTableExist(c_db, tbname)
  local sq = string.format([==[SELECT COUNT(*) FROM sqlite_master where type='table' and name='%s']==], tbname);
  local rc, stmtpp = help_prepare_and_step(c_db, sq)
  if ( isHasRow(rc) ) then
    assert ( isHasCol(stmtpp) == true)
    local is_has = isHasValue(stmtpp, 0, 'int')
    if (is_has == true) then 
      sqFinalize(stmtpp)
      return true
    end
  end
  sqFinalize(stmtpp)
  return false
end

function sqTableNames(c_db)
  local t = {}
  local sq = [==[select name from sqlite_master where type='table' order by name;]==]
  local rc, stmtpp = help_prepare_and_step(c_db, sq)
  check_step(rc, stmtpp)
  while ( isHasRow(rc) and isHasCol(stmtpp) ) do
    local ncol  = sqColumnCount(stmtpp)
    assert (ncol == 1)
    local tname, nbytes = sqValue(stmtpp, 0, 'text')
    if (nbytes <= 0 or tname == nil) then
      break
    end
    t[#t+1] = lstring(tname)-- tname
    local rc = sqStep(c_db, stmtpp)
    check_step(rc, stmtpp)
  end
  sqFinalize(stmtpp)
  return t
end

-- To do: fix this funtion  -- it just return create statement now
function sqColumnNames(c_db, tname)
  local t = {}
  local sq = string.format([==[select sql from sqlite_master where type='table' and name='%s' order by name;]==], tname)
  local rc, stmtpp = help_prepare_and_step(c_db, sq)
  check_step(rc, stmtpp)
  while ( isHasRow(rc) and isHasCol(stmtpp) ) do
    local ncol  = sqColumnCount(stmtpp)
    assert (ncol == 1)
    local tname, nbytes = sqValue(stmtpp, 0, 'text')
    if (nbytes <= 0 or tname == nil) then
      break
    end
    t[#t+1] = lstring(tname)-- tname
    local rc = sqStep(c_db, stmtpp)
    check_step(rc, stmtpp)
  end
  sqFinalize(stmtpp)
  return t
end

function foo()
  --[[
  		data  = (char*)sqlite3_column_blob(pStmt, 2);
			nbyte = sqlite3_column_bytes(pStmt, 2);
			if (nbyte != 0) {
				if (media_type == 1) {
					sprintf(img_name, "c:\\img\\%s.jpg", label);
				}
				if (media_type == 2) {
					sprintf(img_name, "c:\\img\\%s.mp4", label);
				}
				dataWrite(img_name, data, nbyte);
  --]]
end

local dbname = "./luasq/db/Maindb.db01"
local isExist = sqIsDbExsit(dbname)
print (isExist)
local c_db, c_rc = sqOpenWrite(dbname)
assert(c_rc == SQOK)
assert(c_db ~= nil)
local tnames = sqTableNames(c_db)
local atest_sql = sqColumnNames(c_db, 'ATest')
printkv(atest_sql)
local sq = [==[update AppInfo set AgentVersion = 'aaaabbbcccc']==]
sqExec(c_db, sq)
print ( sqIsTableExist(c_db, 'AppInfo') )



