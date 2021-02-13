CWStr = CWStr or {}

-- In Quotes
function IQ(str)
	return str and ("'" .. str .. "'") or str
end

function CWStr:Get(str,pattern)
	for v in string.gmatch(str, pattern) do
		return v
	end
	return ''
end

function CWStr:Len(str)
	return utf8.len(str)
end
-- TO DO: НАПИСАТЬ ФУНКЦИЮ, ИСПОЛЬЗОВАВ СТАРЫЙ МАТ ФИЛЬТР
-- function NStr:Find(str)
-- 	return str:match("^.+/(.+)%.")
-- end
-- print(string.find('ssssПриветики !!!','[а-Я%d]+'))

function CWStr:ToSID(sid)
	sid = string.Replace(sid, 'STEAM_', '')
	sid = string.Replace(sid, ':', '')

	return sid
end

function CWStr:FromSID(sid)
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

function CWStr:HasRussianSymbols(text)
	for k, v in pairs(CWStr.UpperLowerKV) do
		if string.find(text, k) or string.find(text, v) then return true end
	end

	return false
end

function CWStr:HaveLower(text)
	local found, foundTable = false, {}

	for k, v in pairs(CWStr.UpperLowerKV) do
		if string.find(text, v) then
			found = true
			table.insert(foundTable, v)
		end
	end

	return found, foundTable
end

function CWStr:HaveUpper(text)
	local found, foundTable = false, {}

	for k, v in pairs(CWStr.UpperLowerKV) do
		if string.find(text, k) then
			found = true
			table.insert(foundTable, k)
		end
	end

	return found, foundTable
end

-- например, NStr:GetNumEnding(11,'минут','минута','минуты')
function CWStr:GetNumEnding(num, ifZero, ifOne, ifTwo)
	if not isnumber(num) then return end
	local lastNumDecimalsLeft = num % 100
	if lastNumDecimalsLeft >= 11 and lastNumDecimalsLeft <= 19 then return ifZero end
	local lastNumUnits = num % 10
	if table.HasValue({0, 5, 6, 7, 8, 9}, lastNumUnits) then return ifZero end
	if table.HasValue({1}, lastNumUnits) then return ifOne end
	if table.HasValue({2, 3, 4}, lastNumUnits) then return ifTwo end
end

function CWStr:RandomString(numOfChairs)
	math.randomseed(os.time())
	local s = ''

	for i = 1, numOfChairs do
		s = s .. string.char(math.random(65, 90))
	end

	return s
end

function CWStr:FormatToTwoCharsLang(lang)
	if #lang > 2 then lang = string.sub(lang,1,2) end
	return lang
end
