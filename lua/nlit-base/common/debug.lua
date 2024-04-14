local Color = Color
local print = print
local debug = debug
local istable = istable
local MsgC = MsgC
local type = type
local PrintTable = PrintTable
local printDumpPath = false
local color = Color(0, 255, 38)
local color2 = Color(255, 145, 0)
--- np() is Debug function for printing. Vararg params
-- vararg parameters, can be a strings or tables, or anything
function np(...)
    if printDumpPath then print(debug.getinfo(2, 'S').source:sub(2)) end
    local t = string.upper(type(...))
    if istable(...) then
        if table.IsEmpty(...) then
            t = 'EMPTY TABLE'
            MsgC(color2, '[' .. t .. ']\n')
        else
            MsgC(color2, '[' .. t .. ']', color, ' >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n')
            PrintTable(...)
        end
    else
        MsgC(color, '[' .. t .. '] ')
        print(...)
    end
end

--- Easilly Prints error message
-- @param str string message
-- TODO: Добавить строку и файл, где находится ошибка
function PrintError(str)
    MsgC(Color(255, 0, 0), 'Error' .. '! ' .. str .. "!\n")
end