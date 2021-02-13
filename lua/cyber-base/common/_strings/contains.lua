function CWStr:Contains(str,text)
	return tobool(string.find(str, text))
end

function CWStr:OnlyContainsLetters(text)
	for w in string.gmatch(text, "[%p%s%c%d]") do
		return false
	end

	return true
end

function CWStr:OnlyContainsLettersAndNumbers(text)
	for w in string.gmatch(text, "[%p%s%c]") do
		return false
	end

	return true
end

function CWStr:OnlyContainsAllowed(text)
	for _,v in pairs({'_','-',' '}) do
		text = string.Replace(text, v, '')
	end

	for w in string.gmatch(text, "[%p%s%c]") do
		return false
	end

	return true
end

function CWStr:OnlyContainsNumbers(text)
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