--- The module for working with strings
-- @module nlitStrings
-- @usage local strings = nlitStrings
-- @see nlit
module('nlitStrings', package.seeall)

local string = string
local utf8 = utf8
local table = table
local pairs = pairs
local isnumber = isnumber
local math = math
local os = os
local tobool = tobool
local util = util

local Strings = {}

local CWUtf8 = nlitLibs:Lib('utf8')


--- Puts text In Quotes for SQL code
-- Changing single quotes, prehaps double quoutes using by json
-- Закрывает текст в кавычки для SQL
-- Заменяем одинарные кавычки, ибо двойные использует json
-- @param str the string
-- @return string with quotes
function IQ(self, str)
    return str and ("'" .. str .. "'") or str
end

--- Takes substring from string using pattern
-- / Берёт из строки подстроку с помощью паттерна
function Get(self, str, pattern)
    for v in string.gmatch(str, pattern) do
        return v
    end

    return ''
end

--- Takes length of the string
-- / Взять длину строки
-- @param str Input string
function Len(self, str)
    return utf8.len(str)
end

-- TO DO: НАПИСАТЬ ФУНКЦИЮ, ИСПОЛЬЗОВАВ СТАРЫЙ МАТ ФИЛЬТР
-- function NStr:Find(str)
-- 	return str:match("^.+/(.+)%.")
-- end
-- print(string.find('ssssПриветики !!!','[а-Я%d]+'))
--- Steamid to Short ID
-- @param sid long SteamID
function ToSID(self, sid)
    sid = string.Replace(sid, 'STEAM_', '')
    sid = string.Replace(sid, ':', '')

    return sid
end

--- Short ID to Steamid
-- @param sid short SteamID
function FromSID(self, sid)
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
function HasRussianSymbols(self, text)
    for k, v in pairs(utf8_uc_lc) do
        if string.find(text, k) or string.find(text, v) then return true end
    end

    return false
end

--- Is str contains lowercase symbols
---@param text string
---@return boolean
---@return table found Table
function HaveLower(self, text)
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
function HaveUpper(self, text)
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
function GetNumEnding(self, num, ifZero, ifOne, ifTwo)
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
function RandomString(self, numOfChairs)
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
function FormatToTwoCharsLang(self, lang)
    if #lang > 2 then
        lang = string.sub(lang, 1, 2)
    end

    return lang
end

--- Is string Contains text
-- @param str string
-- @param text text
function Contains(self, str, text)
    return tobool(string.find(str, text))
end

--- Is string only Contains letters
-- @param text string
-- @return bool
function OnlyContainsLetters(self, text)
    for w in string.gmatch(text, "[%p%s%c%d]") do
        return false
    end

    return true
end

--- Is string only Contains letters and numbers
-- @param text string
-- @return bool
function OnlyContainsLettersAndNumbers(self, text)
    for w in string.gmatch(text, "[%p%s%c]") do
        return false
    end

    return true
end

--- Is string only Contains allowed symbols
-- @param text string
-- @return bool
function OnlyContainsAllowed(self, text)
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
function OnlyContainsNumbers(self, text)
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
function Lower(self, text)
    return CWUtf8.lower(text)
end

--- Makes string letters uppercase
-- @param text string
-- @return new string
function Upper(self, text)
    return CWUtf8.upper(text)
end

--- Makes string letters capitalized
-- TODO: Fix
-- @param text string
-- @return new string
-- function Capitalize(self, text)

--     if HasRussianSymbols(self, text) then

--         -- Lowering the whole text
--         text = ' ' .. CWUtf8.lower(text)

--         -- We're changing all russian first letters after space to uppercase
--         -- / Заменяем все русские первые буквы после пробела на заглавные
--         for k, v in pairs(utf8_lc_uc) do
--             text = string.Replace(text, ' ' .. k, ' ' .. v)
--         end
--     else
--         -- Lowering the whole text
--         text = ' ' .. string.lower(text)
--     end

--     np(text)

--     -- We're changing all english first letters to uppercase / Меняем все то же самое, только в инглише
--     local output = text:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end)

--     -- Removing first space, added by gsub / Обрезаем пробел вначале, добавленный нами
--     output = string.sub(output, 2)

--     return output
-- end

-- np(Capitalize(self, 'hello world'))
-- np(Capitalize(self,'привет мир'))

--- Makes string first letter capitalized
-- @param text string
-- @return new string
function CapitalizeFirst(self, text)
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
function RemovePunctuationMarks(self, text)
    return string.gsub(text, '%p', '')
end

---Removes rus symbols
---@param text string
---@return formatted text
function RemoveRussianSymbols(self, text)
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
function GetFileName(self, str)
    return str:match("^.+/(.+)%.")
end

---Gets file name and extention from string
---@param str string
---@return formatted text
function GetFileNameExt(self, str)
    return str:match("^.+/(.+)$")
end

---Gets file extention from string
---@param str string
---@return formatted text
function GetFileExt(self, str)
    return str:match("%.(.+)$")
end

---Gets file path from string
---@param str string
---@return formatted text
function GetFilePath(self, str)
    return str:match("^(.+)/") .. '/'
end

---Array to json
---@param arr table
---@return string text
function ToJson(self, arr)
    return util.TableToJSON(arr)
end

---Array from json
---@param str string
---@return table text
function FromJson(self, str)
    return util.JSONToTable(str)
end

local sqlWords = {'delete', 'drop', 'create', 'update', 'set', 'insert', 'select', 'table', 'exists', 'where', 'alter'}

---Removes SQL from string
---@param str string
---@return string formatted
function RemoveSQL(self, str)
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
function HasSQL(self, str)
    local strLow = string.lower(str)

    for _, bad in pairs(sqlWords) do
        if tobool(string.find(strLow, ' ' .. bad)) or tobool(string.find(strLow, bad .. ' ')) or tobool(string.find(strLow, ' ' .. bad .. ' ')) or tobool(string.find(strLow, ';')) then return true end
    end
end