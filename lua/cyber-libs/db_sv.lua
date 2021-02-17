---Databases module. Server only.
---@module DB
local DB = {}

local dbg_prefix = '[CWDB]'

local function IQ(str) -- in quotes
  str = string.Replace(str, '"', '')
  str = string.Replace(str, "'", '')
  return str and ("'" .. str .. "'") or str
end

--- Generates SQL string from table. Input must be in counted non-associative array.
---@param tbl table non-associative
---@return generated string
function DB:GenStr(tbl)
  local string
	for _,v in pairs(tbl) do
    v = IQ(string.Trim(v))
		string = (string and string..','..v or v)
	end
  return string
end

---Generates SQL keyvalues string from table. Input must be in associative array.
---@param tbl table associative
---@return generated string
function DB:GenKVStr(tbl)
  local string
	for k,v in pairs(tbl) do
    k = IQ(string.Trim(k))
    v = IQ(string.Trim(v))
    local s = k..'='..'v'
		string = (string and string..','..s or s)
	end
  return string
end

---Run Query
---@param query string
---@param qtype any [optional] 1 - gets row, 2 - gets value
---@return result
function DB:Q(query, qtype)
  local q
  if qtype == 1 then q = sql.QueryRow(query)
  elseif qtype == 2 then q = sql.QueryValue(query)
  else q = sql.Query(query) end

  if q == false then
    local info = debug.getinfo(2, 'S')
    local errText = dbg_prefix..' ' .. sql.LastError()
    if info then
      errText = errText .. ' [' .. info.source:sub(2) .. ' line ' .. info.linedefined .. ']'
    end
    PrintError(errText)
  end

  return q
end

--- Gets query Row
--- @see Q
function DB:QRow(query)
  return self:Q(query, 1)
end

--- Gets query Value
--- @see Q
function DB:QValue(query)
  return self:Q(query, 2)
end

--- Set table name for all queries in this file
function DB:SetTableName(tblName)
  tblName = string.Trim(tblName)
  if not isstring(tblName) then
    PrintError(dbg_prefix..' Table name must be a string! ' .. NFiles:curPath())
    return
  end
  if string.find(tblName, ' ') then
    PrintError(dbg_prefix..' Name must not contain spaces! ' .. NFiles:curPath())
    return
  end
  self.curTable = tblName
  return true
end

function DB:GetTableName()
  return self.curTable
end

function DB:TableExists()
  return sql.TableExists(self:GetTableName())
end

-- ИЗМЕНИТЬ ТАБЛИЦУ
-- пример steamid TEXT NOT NULL,nick TEXT,lastjoin DATETIME,total_sum INTEGER,is_endless_priv BOOLEAN,reprimands INTEGER
function DB:CreateTable(sqlStrColumns)
  local name = self:GetTableName()
  if not name then PrintError(dbg_prefix..' Creating table name is not set! ' .. NFiles:curPath()) return end
  return self:Q('CREATE TABLE IF NOT EXISTS ' .. name .. '(' .. string.Trim(sqlStrColumns) .. ')')
end

function DB:CreateUTable(uColumn, sqlStrColumns)
  return self:CreateTable(uColumn .. ' PRIMARY KEY UNIQUE, ' .. sqlStrColumns)
end

function DB:CreateDataTable(uColumn)
  return self:CreateUidTable(uColumn .. ' UNIQUE, data TEXT')
end

function DB:CreateUidTable(sqlStrColumns)
  return self:CreateTable('id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, ' .. sqlStrColumns)
end

function DB:RenameTable(newName)
  local q = self:Q('ALTER TABLE IF EXISTS ' .. self:GetTableName() .. ' RENAME TO ' .. newName)
  if q then self:SetTableName(newName) end
  return q
end

function DB:RemoveTable()
  return self:Q('DROP TABLE IF EXISTS ' .. self:GetTableName())
end

function DB:ClearTable()
  return self:Q('DELETE FROM ' .. self:GetTableName())
end

function DB:AddColumn(sqlStrColumn)
  return self:Q('ALTER TABLE ' .. self:GetTableName() .. ' ADD COLUMN ' .. sqlStrColumn)
end

-- function NDB:RemoveColumn(sqlStrColumn)
--   NDB:Q('PRAGMA foreign_keys=off;BEGIN TRANSACTION;')
--   NDB:Q([[CREATE TABLE IF NOT EXISTS n_temporary_table (
--         UserId INTEGER PRIMARY KEY,
--         FirstName TEXT NOT NULL,
--         LastName TEXT NOT NULL,
--         Email TEXT NOT NULL
--     );]])
--   NDB:Q('COMMIT;PRAGMA foreign_keys=on;')
-- end

---INSERTs data INTO TABLE with additioanl string
---@param addStr string additional string between INSERT and INTO
---@param arrKV table associative
---@return result
function DB:InsertAdditional(addStr,arrKV)
	local columns,values = {},{}
	for k,v in pairs(arrKV) do
    table.insert(columns, k)
    table.insert(values, v)
	end
  columns = self:GenStr(columns)
  values = self:GenStr(values)
	return self:Q('INSERT '..addStr..'INTO ' .. self:GetTableName() .. '(' .. columns .. ') VALUES (' .. values .. ')') == nil
end

---INSERTs data INTO TABLE
---@param arrKV table associative
---@return result
function DB:Insert(arrKV)
  return self:InsertAdditional('',arrKV)
end

---INSERTs data INTO TABLE and gets its row id
---@param arrKV table associative
---@return id
function DB:InsertGetId(arrKV)
	return self:Insert(arrKV) and self:GetLastInsertedRow() or nil
end

---INSERTs data INTO TABLE or replacing existed
---@param arrKV table associative
---@return result
function DB:InsertOrReplace(arrKV)
  return self:InsertAdditional('OR REPLACE ',arrKV)
end

---INSERTs or replace data INTO TABLE and gets its row id
---@param arrKV table associative
---@return id
function DB:InsertOrReplaceGetId(arrKV)
	return self:InsertOrReplace(arrKV) and self:GetLastInsertedRow() or nil
end

---INSERTs data INTO TABLE or ignores
---@param arrKV table associative
---@return result
function DB:InsertOrIgnore(arrKV)
	return self:InsertAdditional('OR IGNORE ',arrKV)
end

---INSERTs data or ignore INTO TABLE and gets its row id
---@param arrKV table associative
---@return id
function DB:InsertOrIgnoreGetId(arrKV)
	return self:InsertOrIgnore(arrKV) and self:GetLastInsertedRow() or nil
end

---Gets last row
---@return id
function DB:GetLastInsertedRow()
  return self:QValue('SELECT last_insert_rowid()')
end

---GETs FROM TABLE
---@param kv table
---@return table data
function DB:GetWhere(kv)
  return self:Q('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenKVStr(kv))
end

---GETs id
---@param kv table
---@return table data
function DB:GetIdWhere(kv)
  return self:QValue('SELECT id FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenKVStr(kv))
end

---GETs row
---@param kv table
---@return table data
function DB:GetRowWhere(kv)
  return self:QRow('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenKVStr(kv))
end

---GETs value of column
---@param column string
---@param kv table
---@return table data
function DB:GetValueWhere(column,kv)
  return self:QValue('SELECT '..column..' FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenKVStr(kv))
end

---GETs value of column data
---@param kv table
---@return table data
function DB:GetDataWhere(kv)
  return self:QRow('SELECT data FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenKVStr(kv))
end

---Is data row exists
---@param kv table
---@return boolean
function DB:ExistsWhere(kv)
  return self:GetRowWhere(kv) ~= nil
end

function DB:Get(addParams)
  addParams = addParams or ''
  addParams = ' ' .. addParams

  return self:Q('SELECT * FROM ' .. self:GetTableName() .. addParams)
end

function DB:SelectFromAll(sqlStr)
  return self:Q('SELECT ' .. sqlStr .. ' FROM ' .. self:GetTableName())
end

function DB:GetTableCode()
  return self:Q("SELECT sql FROM sqlite_master WHERE tbl_name = '" .. self:GetTableName() .. "' AND type = 'table'")[1].sql
end

-- SET IN TABLE
-- пример ('reprimands = 3, money = 300','steamid = STEAM_0:1:333333')
function DB:Set(sqlSetValues, sqlWhere)
  return self:Q('UPDATE ' .. self:GetTableName() .. ' SET ' .. sqlSetValues .. ' WHERE ' .. sqlWhere)
end

-- DELETE FROM TABLE
function DB:DeleteWhere(sqlStr)
  return self:Q('DELETE FROM ' .. self:GetTableName() .. ' WHERE ' .. sqlStr) == nil
end

function DB:RemoveWhere(sqlStr)
  return self:DeleteWhere(sqlStr)
end

-- PRINT TABLE
function DB:PrintTable()
  local tbl = self:Q('SELECT * FROM ' .. self:GetTableName())

  if tbl then
    PrintTable(tbl)
  else
    print('ERROR! Table has no rows!')
  end
end

function DB:PrintTableRow()
  print(self:QRow('SELECT * FROM ' .. self:GetTableName()))
end

function DB:PrintTableCode()
  print(self:GetTableCode())
end

function DB:PrintTableColumns()
  self:PrintTableCode()
end

function DB:PrintTableExists()
  print(self:TableExists())
end

function DB:PrintWhere(sqlWhere)
  PrintTable(self:Q('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. sqlWhere))
end

function DB:PrintRowWhere(sqlWhere)
  print(self:QRow('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. sqlWhere))
end

function DB:PrintAllTables()
  local tables = self:Q("SELECT name FROM sqlite_master WHERE type ='table' AND name NOT LIKE 'sqlite_%'")

  if tables and #tables > 0 then
    for _, v in pairs(tables) do
      print(v.name)
    end
  end
end

return DB
