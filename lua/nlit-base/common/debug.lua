local Color = Color
local print = print
local debug = debug
local istable = istable
local MsgC = MsgC
local type = type
local PrintTable = PrintTable
local printDumpPath = false
local color = Color(255, 255, 0)

--- np() is Debug function for printing. Vararg params
-- vararg parameters, can be a strings or tables, or anything
function np(...)
    if printDumpPath then
        print(debug.getinfo(2, 'S').source:sub(2))
    end

    if istable(...) then
        MsgC(color, '[' .. type(...) .. '] -----------------------------------------\n')
        PrintTable(...)
    else
        MsgC(color, '[' .. type(...) .. '] ')
        print(...)
    end
end

---Easilly Prints error message
---@param str string message
-- TODO: Добавить строку и файл, где находится ошибка
function PrintError(str)
    MsgC(Color(255, 0, 0), 'Error' .. '! ' .. str .. "!\n")
end