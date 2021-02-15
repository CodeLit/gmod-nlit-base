--- Globals for easy debugging
-- @module Debug
local printDumpPath = false
local color = Color(255,255,0)

--- Debug function for printing. Vararg params
function cwp(...) -- nicePrint, или CWPrint
	if printDumpPath then print(debug.getinfo(2,'S').source:sub(2)) end
	if istable(...) then
		MsgC(color,'['..type(...)..'] -----------------------------------------\n')
		PrintTable(...)
	else
		MsgC(color,'['..type(...)..'] ')
		print(...)
	end
end

-- TODO: Добавить строку и файл, где находится ошибка
function PrintError(str) MsgC(Color(255,0,0),'Ошибка! '..str.."!\n") end