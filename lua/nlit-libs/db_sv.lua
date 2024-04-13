local pairs = pairs
local string = string
local isstring = isstring
local PrintError = PrintError
local sql = sql
local debug = debug
local table = table
local PrintTable = PrintTable
local print = print
---Databases module. Server only.
---@module DB
local DB = {}
local NStr = nlitString
local dbg_prefix = '[CWDB]'
local CWUtf8 = nlitLib:Lib('utf8')
---Generates SQL string from table. Input must be in counted non-associative array.
---@param tbl table non-associative
---@return generated string
function DB:GenStr(tbl)
    local s
    for _, v in pairs(tbl) do
        v = NStr:IQ(string.Trim(v))
        s = s and s .. ',' .. v or v
    end
    return s or ''
end

---Generates SQL keyvalues string from table. Input must be in associative array.
---@param tbl table associative
---@return generated string
function DB:GenKVStr(tbl)
    if isstring(tbl) then
        PrintError(tbl .. ' is string!')
        ErrorNoHaltWithStack()
        return tbl
    end

    local str
    for k, v in pairs(tbl) do
        k = string.Trim(k)
        v = NStr:IQ(string.Trim(v))
        local s = k .. '=' .. v
        str = str and str .. ',' .. s or s
    end
    return str or ''
end

---Generates SQL smart string from common string.
---Example: "hello = world" => "`hello`='world'"
---Example 2: "hello >= world" => "`hello`>='world'"
---Example 3: "привет == world" => "`привет`=='world'"
---@param str String
---@return str Smart SQL String
function DB:GenSmartStr(str)
    -- Explode by words
    local arr = {}
    for word in CWUtf8.gmatch(str, '[%wА-я%s:_-]+') do
        word = string.Trim(word)
        table.insert(arr, word)
    end

    arr[1] = '`' .. arr[1] .. '`'
    arr[2] = "'" .. arr[2] .. "'"
    -- Symbol between to middle of array
    local connector = CWUtf8.match(str, '[^%wА-я%s:_-]')
    table.insert(arr, 2, connector)
    local output = ''
    for _, v in pairs(arr) do
        output = output .. v
    end
    return output
end

---Generates SQL smart string from table or string
---Example 1: {'el1=el2','el3 >= el4'} => "'el1'='el2' AND 'el3'>='el4'"
---Example 2: {el1='el2',el3 ='el4'} => "'el1'='el2' AND 'el3'='el4'"
---Example 3: "el1 = el2 OR el3<=el4" => "'el1'='el2' OR 'el3'<='el4'"
---@param tbl table associative
---@return generated Smart SQL string
---@see GenSmartStr
function DB:GenSmartStrFromArr(tbl)
    local str
    if isstring(tbl) then
        str = self:GenSmartStr(tbl)
    elseif tbl[1] then
        for _, v in pairs(tbl) do
            v = self:GenSmartStr(v)
            str = str and str .. ' AND ' .. v or v
        end
    else
        for k, v in pairs(tbl) do
            local s = k .. '=' .. v
            s = self:GenSmartStr(s)
            str = str and str .. ' AND ' .. s or s
        end
    end
    return str or ''
end

---Run Query
---@param query string
---@param qtype any [optional] 1 - gets row, 2 - gets value
---@return result
function DB:Q(query, qtype)
    local q
    if qtype == 1 then
        q = sql.QueryRow(query)
    elseif qtype == 2 then
        q = sql.QueryValue(query)
    else
        q = sql.Query(query)
    end

    if q == false then
        local errText = dbg_prefix .. ' in query: [' .. query .. '], ' .. sql.LastError()
        PrintError(errText)
        ErrorNoHaltWithStack()
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
        PrintError(dbg_prefix .. ' Table name must be a string! ' .. NFiles:curPath())
        return
    end

    if string.find(tblName, ' ') then
        PrintError(dbg_prefix .. ' Name must not contain spaces! ' .. NFiles:curPath())
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
    if not name then
        PrintError(dbg_prefix .. ' Creating table name is not set! ' .. NFiles:curPath())
        return
    end
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
function DB:InsertAdditional(addStr, arrKV)
    local columns, values = {}, {}
    for k, v in pairs(arrKV) do
        table.insert(columns, k)
        table.insert(values, v)
    end

    columns = self:GenStr(columns)
    values = self:GenStr(values)
    return self:Q('INSERT ' .. addStr .. 'INTO ' .. self:GetTableName() .. '(' .. columns .. ') VALUES (' .. values .. ')') == nil
end

---INSERTs data INTO TABLE
---@param arrKV table associative
---@return result
function DB:Insert(arrKV)
    return self:InsertAdditional('', arrKV)
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
    return self:InsertAdditional('OR REPLACE ', arrKV)
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
    return self:InsertAdditional('OR IGNORE ', arrKV)
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
    return self:Q('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(kv))
end

---GETs id
---@param kv table
---@return table data
function DB:GetIdWhere(kv)
    return self:QValue('SELECT id FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(kv))
end

---GETs row
---@param kv table
---@return table data
function DB:GetRowWhere(kv)
    return self:QRow('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(kv))
end

---GETs value of column
---@param column string
---@param kv table
---@return table data
function DB:GetValueWhere(column, kv)
    return self:QValue('SELECT ' .. column .. ' FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(kv))
end

---GETs value of column data
---@param kv table
---@return table data
function DB:GetDataWhere(whereSqlStr)
    return self:QRow('SELECT data FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(whereSqlStr)).data
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
    return self:Q('UPDATE ' .. self:GetTableName() .. ' SET ' .. sqlSetValues .. ' WHERE ' .. self:GenSmartStrFromArr(sqlWhere))
end

-- DELETE FROM TABLE
function DB:DeleteWhere(sqlWhere)
    return self:Q('DELETE FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(sqlWhere)) == nil
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
    PrintTable(self:Q('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(sqlWhere)))
end

function DB:PrintRowWhere(sqlWhere)
    print(self:QRow('SELECT * FROM ' .. self:GetTableName() .. ' WHERE ' .. self:GenSmartStrFromArr(sqlWhere)))
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