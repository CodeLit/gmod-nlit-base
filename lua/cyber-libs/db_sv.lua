local CWDB = {}

local dbg_prefix = '[CWDB]'

-- ГЛАВНОЕ
function CWDB:Q(query, qtype)
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

function CWDB:QRow(query)
  return CWDB:Q(query, 1)
end

function CWDB:QValue(query)
  return CWDB:Q(query, 2)
end

function CWDB:SetTableName(tblName)
  tblName = string.Trim(tblName)

  if not isstring(tblName) then
    PrintError(dbg_prefix..' Table name must be a string! ' .. NFiles:curPath())

    return
  end

  if string.find(tblName, ' ') then
    PrintError(dbg_prefix..' Name must not contain spaces! ' .. NFiles:curPath())

    return
  end

  CWDB.curTable = tblName

  return true
end

function CWDB:GetTableName()
  return self.curTable
end

function CWDB:TableExists()
  return sql.TableExists(CWDB:GetTableName())
end

-- ИЗМЕНИТЬ ТАБЛИЦУ
-- пример steamid TEXT NOT NULL,nick TEXT,lastjoin DATETIME,total_sum INTEGER,is_endless_priv BOOLEAN,reprimands INTEGER
function CWDB:CreateTable(sqlStrColumns)
  local name = CWDB:GetTableName()
  if not name then PrintError(dbg_prefix..' Creating table name is not set! ' .. NFiles:curPath()) return end
  return self:Q('CREATE TABLE IF NOT EXISTS ' .. name .. '(' .. string.Trim(sqlStrColumns) .. ')')
end

function CWDB:CreateUTable(uColumn, sqlStrColumns)
  return self:CreateTable(uColumn .. ' PRIMARY KEY UNIQUE, ' .. sqlStrColumns)
end

function CWDB:CreateDataTable(uColumn)
  return self:CreateUidTable(uColumn .. ' UNIQUE, data TEXT')
end

function CWDB:CreateUidTable(sqlStrColumns)
  return self:CreateTable('id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, ' .. sqlStrColumns)
end

function CWDB:RenameTable(newName)
  local q = CWDB:Q('ALTER TABLE IF EXISTS ' .. CWDB:GetTableName() .. ' RENAME TO ' .. newName)
  if q then CWDB:SetTableName(newName) end
  return q
end

function CWDB:RemoveTable()
  return CWDB:Q('DROP TABLE IF EXISTS ' .. CWDB:GetTableName())
end

function CWDB:ClearTable()
  return CWDB:Q('DELETE FROM ' .. CWDB:GetTableName())
end

function CWDB:AddColumn(sqlStrColumn)
  return CWDB:Q('ALTER TABLE ' .. CWDB:GetTableName() .. ' ADD COLUMN ' .. sqlStrColumn)
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

-- INSERT INTO TABLE
function CWDB:InsertAdditional(addStr,arrKV)
	local columns,values
	for k,v in pairs(arrKV) do
		columns = (columns and columns..','..k or k)
		values = (values and values..','..v or v)
	end
	return CWDB:Q('INSERT '..addStr..'INTO ' .. CWDB:GetTableName() .. '(' .. columns .. ') VALUES (' .. values .. ')') == nil
end

function CWDB:Insert(arrKV)
  return CWDB:InsertAdditional('',arrKV)
end

function CWDB:InsertGetId(arrKV)
	return CWDB:Insert(arrKV) and CWDB:GetLastInsertedRow() or nil
end

function CWDB:InsertOrReplace(arrKV)
  return CWDB:InsertAdditional('OR REPLACE ',arrKV)
end

function CWDB:InsertOrReplaceGetId(arrKV)
	return CWDB:InsertOrReplace(arrKV) and CWDB:GetLastInsertedRow() or nil
end

function CWDB:InsertOrIgnore(arrKV)
	return CWDB:InsertAdditional('OR IGNORE ',arrKV)
end

function CWDB:InsertOrIgnoreGetId(arrKV)
	return CWDB:InsertOrIgnore(arrKV) and CWDB:GetLastInsertedRow() or nil
end

function CWDB:GetLastInsertedRow()
  return CWDB:QValue('SELECT last_insert_rowid()')
end

-- GET FROM TABLE
function CWDB:GetWhere(sqlStr)
  return CWDB:Q('SELECT * FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlStr)
end

function CWDB:GetIdWhere(sqlStr)
  return CWDB:QValue('SELECT id FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlStr)
end

function CWDB:GetRowWhere(sqlStr)
  return CWDB:QRow('SELECT * FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlStr)
end

function CWDB:GetValueWhere(column,sqlStr)
  return CWDB:QValue('SELECT '..column..' FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlStr)
end

function CWDB:GetDataWhere(sqlStr)
  return CWDB:QRow('SELECT data FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlStr)
end

function CWDB:ExistsWhere(sqlStr)
  return CWDB:GetRowWhere(sqlStr) ~= nil
end

function CWDB:Get(addParams)
  addParams = addParams or ''
  addParams = ' ' .. addParams

  return CWDB:Q('SELECT * FROM ' .. CWDB:GetTableName() .. addParams)
end

function CWDB:SelectFromAll(sqlStr)
  return CWDB:Q('SELECT ' .. sqlStr .. ' FROM ' .. CWDB:GetTableName())
end

function CWDB:GetTableCode()
  return CWDB:Q("SELECT sql FROM sqlite_master WHERE tbl_name = '" .. CWDB:GetTableName() .. "' AND type = 'table'")[1].sql
end

-- SET IN TABLE
-- пример ('reprimands = 3, money = 300','steamid = STEAM_0:1:333333')
function CWDB:Set(sqlSetValues, sqlWhere)
  return CWDB:Q('UPDATE ' .. CWDB:GetTableName() .. ' SET ' .. sqlSetValues .. ' WHERE ' .. sqlWhere)
end

-- DELETE FROM TABLE
function CWDB:DeleteWhere(sqlStr)
  return CWDB:Q('DELETE FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlStr) == nil
end

function CWDB:RemoveWhere(sqlStr)
  return CWDB:DeleteWhere(sqlStr)
end

-- PRINT TABLE
function CWDB:PrintTable()
  local tbl = CWDB:Q('SELECT * FROM ' .. CWDB:GetTableName())

  if tbl then
    PrintTable(tbl)
  else
    print('ERROR! Table has no rows!')
  end
end

function CWDB:PrintTableRow()
  print(CWDB:QRow('SELECT * FROM ' .. CWDB:GetTableName()))
end

function CWDB:PrintTableCode()
  print(CWDB:GetTableCode())
end

function CWDB:PrintTableColumns()
  CWDB:PrintTableCode()
end

function CWDB:PrintTableExists()
  print(CWDB:TableExists())
end

function CWDB:PrintWhere(sqlWhere)
  PrintTable(CWDB:Q('SELECT * FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlWhere))
end

function CWDB:PrintRowWhere(sqlWhere)
  print(CWDB:QRow('SELECT * FROM ' .. CWDB:GetTableName() .. ' WHERE ' .. sqlWhere))
end

function CWDB:PrintAllTables()
  local tables = CWDB:Q("SELECT name FROM sqlite_master WHERE type ='table' AND name NOT LIKE 'sqlite_%'")

  if tables and #tables > 0 then
    for _, v in pairs(tables) do
      print(v.name)
    end
  end
end

return CWDB
