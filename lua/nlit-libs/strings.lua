local string = string
local utf8 = utf8
local table = table
local pairs = pairs
local isnumber = isnumber
local math = math
local os = os
local tobool = tobool
local util = util
--- The module for working with strings
-- @module Strings
local Strings = {}

local CWUtf8 = CW:Lib('utf8')

--- Puts text In Quotes for SQL code
-- Changing single quotes, prehaps double quoutes using by json
-- Закрывает текст в кавычки для SQL
-- Заменяем одинарные кавычки, ибо двойные использует json
-- @param str the string
-- @return string with quotes
function Strings:IQ(str)
    return str and ("'" .. str .. "'") or str
end

--- Takes substring from string using pattern
-- / Берёт из строки подстроку с помощью паттерна
function Strings:Get(str, pattern)
    for v in string.gmatch(str, pattern) do
        return v
    end

    return ''
end

--- Takes length of the string
-- / Взять длину строки
-- @param str Input string
function Strings:Len(str)
    return utf8.len(str)
end

-- TO DO: НАПИСАТЬ ФУНКЦИЮ, ИСПОЛЬЗОВАВ СТАРЫЙ МАТ ФИЛЬТР
-- function NStr:Find(str)
-- 	return str:match("^.+/(.+)%.")
-- end
-- print(string.find('ssssПриветики !!!','[а-Я%d]+'))
--- Steamid to Short ID
-- @param sid long SteamID
function Strings:ToSID(sid)
    sid = string.Replace(sid, 'STEAM_', '')
    sid = string.Replace(sid, ':', '')

    return sid
end

--- Short ID to Steamid
-- @param sid short SteamID
function Strings:FromSID(sid)
    local arr = string.ToTable(sid)
    table.insert(arr, 2, ':')
    table.insert(arr, 4, ':')
    sid = ''

    for _, v in pairs(arr) do
        sid = sid .. v
    end

    sid = 'STEAM_' .. sid

    return sid
end

--- Is str contains russian symbols
function Strings:HasRussianSymbols(text)
    for k, v in pairs(utf8_uc_lc) do
        if string.find(text, k) or string.find(text, v) then return true end
    end

    return false
end

--- Is str contains lowercase symbols
---@param text string
---@return boolean
---@return table found Table
function Strings:HaveLower(text)
    local found, foundTable = false, {}

    for k, v in pairs(utf8_uc_lc) do
        if string.find(text, v) then
            found = true
            table.insert(foundTable, v)
        end
    end

    return found, foundTable
end

--- Is str contains lowercase symbols
---@param text string
---@return boolean
---@return table found Table
function Strings:HaveUpper(text)
    local found, foundTable = false, {}

    for k, v in pairs(utf8_uc_lc) do
        if string.find(text, k) then
            found = true
            table.insert(foundTable, k)
        end
    end

    return found, foundTable
end

--- Возвращает красивые падежные окончания
--- @usage GetNumEnding(11,'минут','минута','минуты')
function Strings:GetNumEnding(num, ifZero, ifOne, ifTwo)
    if not isnumber(num) then return end
    local lastNumDecimalsLeft = num % 100
    if lastNumDecimalsLeft >= 11 and lastNumDecimalsLeft <= 19 then return ifZero end
    local lastNumUnits = num % 10

    if table.HasValue({0, 5, 6, 7, 8, 9}, lastNumUnits) then
        return ifZero
    end

    if table.HasValue({1}, lastNumUnits) then
        return ifOne
    end

    if table.HasValue({2, 3, 4}, lastNumUnits) then
        return ifTwo
    end
end

---Generate Random String
---@param numOfChairs number
---@return string
function Strings:RandomString(numOfChairs)
    math.randomseed(os.time())
    local s = ''

    for i = 1, numOfChairs do
        s = s .. string.char(math.random(65, 90))
    end

    return s
end

---Formats a language to 2 chars lang
---@param lang string
---@return string formatted lang
function Strings:FormatToTwoCharsLang(lang)
    if #lang > 2 then
        lang = string.sub(lang, 1, 2)
    end

    return lang
end

--- Is string Contains text
-- @param str string
-- @param text text
function Strings:Contains(str, text)
    return tobool(string.find(str, text))
end

--- Is string only Contains letters
-- @param text string
-- @return bool
function Strings:OnlyContainsLetters(text)
    for w in string.gmatch(text, "[%p%s%c%d]") do
        return false
    end

    return true
end

--- Is string only Contains letters and numbers
-- @param text string
-- @return bool
function Strings:OnlyContainsLettersAndNumbers(text)
    for w in string.gmatch(text, "[%p%s%c]") do
        return false
    end

    return true
end

--- Is string only Contains allowed symbols
-- @param text string
-- @return bool
function Strings:OnlyContainsAllowed(text)
    for _, v in pairs({'_', '-', ' '}) do
        text = string.Replace(text, v, '')
    end

    for w in string.gmatch(text, "[%p%s%c]") do
        return false
    end

    return true
end

--- Is string only Contains numbers
-- @param text string
-- @return bool
function Strings:OnlyContainsNumbers(text)
    local dotsNum = 0

    for _, v in pairs(string.ToTable(text)) do
        if v == '.' then
            dotsNum = dotsNum + 1
        end
    end

    if dotsNum > 1 then return false end
    text = string.Replace(text, '.', '')

    for w in string.gmatch(text, "[%D]") do
        return false
    end

    return true
end

--- Makes string letters lowercase
-- @param text string
-- @return new string
function Strings:Lower(text)
    return CWUtf8.lower(text)
end

--- Makes string letters uppercase
-- @param text string
-- @return new string
function Strings:Upper(text)
    return CWUtf8.upper(text)
end

--- Makes string letters capitalized
-- @param text string
-- @return new string
function Strings:Capitalize(text)
    text = ' ' .. Strings:Lower(text)

    -- Заменяем все русские первые буквы после пробела на заглавные
    for k, v in pairs(utf8_lc_uc) do
        text = string.Replace(text, ' ' .. k, ' ' .. v)
    end

    local output = text:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end) -- Меняем все то же самое, только в инглише
    output = string.sub(output, 2) -- Обрезаем пробел вначале, добавленный нами

    return output
end

--- Makes string first letter capitalized
-- @param text string
-- @return new string
function Strings:CapitalizeFirst(text)
    text = '?@#$' .. text

    -- Заменяем первую русскую букву на заглавную
    for k, v in pairs(Strings.LowerUpperKV) do
        text = string.Replace(text, '?@#$' .. k, '?@#$' .. v)
    end

    text = string.sub(text, 5)

    return text
end

---Removes punctuation marks
---@param text string
---@return formatted text
-- пробел оставляет
function Strings:RemovePunctuationMarks(text)
    return string.gsub(text, '%p', '')
end

---Removes rus symbols
---@param text string
---@return formatted text
function Strings:RemoveRussianSymbols(text)
    for k, v in pairs(utf8_uc_lc) do
        text = string.Replace(text, k, '')
        text = string.Replace(text, v, '')
    end

    return text
end

-- string.StripExtension(f) -- пригодится для убирания расшир��ния файла
---Gets file name from string
---@param str string
---@return formatted text
function Strings:GetFileName(str)
    return str:match("^.+/(.+)%.")
end

---Gets file name and extention from string
---@param str string
---@return formatted text
function Strings:GetFileNameExt(str)
    return str:match("^.+/(.+)$")
end

---Gets file extention from string
---@param str string
---@return formatted text
function Strings:GetFileExt(str)
    return str:match("%.(.+)$")
end

---Gets file path from string
---@param str string
---@return formatted text
function Strings:GetFilePath(str)
    return str:match("^(.+)/") .. '/'
end

---Array to json
---@param arr table
---@return string text
function Strings:ToJson(arr)
    return util.TableToJSON(arr)
end

---Array from json
---@param str string
---@return table text
function Strings:FromJson(str)
    return util.JSONToTable(str)
end

local sqlWords = {'delete', 'drop', 'create', 'update', 'set', 'insert', 'select', 'table', 'exists', 'where', 'alter'}

---Removes SQL from string
---@param str string
---@return string formatted
function Strings:RemoveSQL(str)
    for _, bad in pairs(sqlWords) do
        str = string.Replace(str, bad .. ' ', '')
        str = string.Replace(str, ' ' .. bad .. ' ', '')
        str = string.Replace(str, ' ' .. bad, '')
        str = string.Replace(str, ';', '')
    end

    return str
end

---Is String Has SQL code
---@param str string
---@return boolean
function Strings:HasSQL(str)
    local strLow = string.lower(str)

    for _, bad in pairs(sqlWords) do
        if tobool(string.find(strLow, ' ' .. bad)) or tobool(string.find(strLow, bad .. ' ')) or tobool(string.find(strLow, ' ' .. bad .. ' ')) or tobool(string.find(strLow, ';')) then return true end
    end
end

return Strings