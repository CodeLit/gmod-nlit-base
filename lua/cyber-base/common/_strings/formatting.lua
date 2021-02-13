function CWStr:Lower(text)
	text = string.lower(text)
	local haveUpper, foundTbl = CWStr:HaveUpper(text)

	if haveUpper then
		for _, upperLetter in pairs(foundTbl) do
			text = string.Replace(text, upperLetter, CWStr.UpperLowerKV[upperLetter])
		end
	end

	return text
end

function CWStr:Upper(text)
	text = string.upper(text)
	local haveLower, foundTbl = CWStr:HaveLower(text)

	if haveLower then
		for _, lowerLetter in pairs(foundTbl) do
			text = string.Replace(text, lowerLetter, CWStr.LowerUpperKV[lowerLetter])
		end
	end

	return text
end

function CWStr:Capitalize(text)
	text = ' ' .. CWStr:Lower(text)

	-- Заменяем все русские первые буквы после пробела на заглавные
	for k, v in pairs(CWStr.LowerUpperKV) do
		text = string.Replace(text, ' ' .. k, ' ' .. v)
	end

	local output = text:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end) -- Меняем все то же самое, только в инглише
	output = string.sub(output, 2) -- Обрезаем пробел вначале, добавленный нами

	return output
end

function CWStr:CapitalizeFirst(text)
	text = '?@#$' .. text

	-- Заменяем первую русскую букву на заглавную
	for k, v in pairs(CWStr.LowerUpperKV) do
		text = string.Replace(text, '?@#$' .. k, '?@#$' .. v)
	end

	text = string.sub(text, 5)

	return text
end

function CWStr:RemovePunctuationMarks(text) -- пробел оставляет
	return string.gsub(text,'%p','')
end

function CWStr:RemoveRussianSymbols(text)
	for k, v in pairs(CWStr.UpperLowerKV) do
		text = string.Replace(text,k,'')
		text = string.Replace(text,v,'')
	end
	return text
end