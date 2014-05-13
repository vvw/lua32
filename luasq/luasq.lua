
--[[


--]]

local SQLITE_DLL    = "./luasq/libs/sqlite-amalgamation-3080402.dll"
local SQLITE_HEADER = "./luasq/include/sqlite3.h"

require "std"
local bit = require "bit"
local ffi = require "ffi"
local lq = ffi.load(SQLITE_DLL)
ffi.cdef( data(SQLITE_HEADER) )

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
    --[lq.SQLITE_NOTICE]      = "SQLITE_NOTICE      27   /* Notifications from sqlite3_log() */",
    --[lq.SQLITE_WARNING]     = "SQLITE_WARNING     28   /* Warnings from sqlite3_log() */",
    [lq.SQLITE_ROW]         = "SQLITE_ROW         100  /* sqlite3_step() has another row ready */",
    [lq.SQLITE_DONE]        = "SQLITE_DONE        101  /* sqlite3_step() has finished executing */",
}

local SQOK = lq.SQLITE_OK

function SQMG(c_db)
  return lq.sqlite3_errmsg(c_db)
end

local mode = {
    ["read"]    = lq.SQLITE_OPEN_READONLY,
    ["create"]  = bit.bor(lq.SQLITE_OPEN_READWRITE, lq.SQLITE_OPEN_CREATE),
}
function sqOpen_(dbname, mode)
  local c_db = ffi.typeof("sqlite3*[1]")()  -- sqlite3 *db; c_db = &db;
  local c_rc = lq.sqlite3_open_v2(dbname, c_db, mode, nil);
  return c_db, c_rc
end

function sqOpenRead(dbname)
  local c_db, c_rc = sqOpen_(dbname, mode.read)
  if( c_rc ~= SQOK ) then DBERR("Can't open database: %s", dbname) end
  DBLOG("open db: %s", dbname)
  return c_db, c_rc
end

function sqOpenCreate(dbname)
  local c_db, c_rc = sqOpen_(dbname, mode.create)
  if( c_rc ~= SQOK ) then DBERR("Can't open database: %s", dbname) end
  DBLOG("open db: %s", dbname)
  return c_db, c_rc
end

--[[
bool sqIsDbExsit(char *dbname) {
	sqlite3 *db; int rc;
	//DBLOG("dbname = %s", dbname);
	db = sqOpen_(dbname, SQLITE_OPEN_READONLY, &rc);
	if (rc == SQOK) {
		sqlite3_close(db);
		return true;
	}
	return false;
}
--]]

function sqIsDbExsit(dbname)
  local c_db, c_rc = sqOpen_(dbname, mode.read)
  if( c_rc == SQOK ) then
    lq.sqlite3_close(c_db);
    return false
  end
  return false
end

function get_img(db)
      local sq = "SELECT label, media_type, media_content FROM t_question;"
      local stmt = db:prepare(sq)
      local is_have_rows = stmt:step()
      assert(is_have_rows == true)
      while (is_have_rows == true) do
        local ncol = stmt:columns()  -- 有多少列
        local v = stmt:get_value(0)
        --print (v)
        is_have_rows = stmt:step()
      end
      stmt:finalize()
end

local dbname = "./luasq/db/question"
print (lq.SQLITE_OPEN_READONLY)
print (bit.bor(lq.SQLITE_OPEN_READWRITE, lq.SQLITE_OPEN_CREATE))
local c_db, c_rc = sqOpenRead(dbname)
assert(c_rc == SQOK)
assert(c_db ~= nil)

--sqlite3_open_v2(dbname, &db, lq.SQLITE_OPEN_READONLY, NULL);
--sqlite3_open_v2(dbname, &db, mode, NULL);

--print (lq.version())
--local db = lq.open(fname, "read")
--assert(db ~= nil)
--print (db:isopen())
--get_img(db)
--db:close()
--print (db:isopen())

print ("hi!!")