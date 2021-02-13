local sqlWords = {
	'delete', 'drop', 'create', 'update', 'set', 'insert', 'select',
	'table', 'exists', 'where', 'alter'
}

function CWStr:RemoveSQL(str)
	for _, bad in pairs(sqlWords) do
		str = string.Replace(str, bad .. ' ', '')
		str = string.Replace(str, ' ' .. bad .. ' ', '')
		str = string.Replace(str, ' ' .. bad, '')
		str = string.Replace(str, ';', '')
	end

	return str
end

function CWStr:HasSQL(str)
	local strLow = string.lower(str)

	for _, bad in pairs(sqlWords) do
		if tobool(string.find(strLow, ' ' .. bad)) or tobool(string.find(strLow, bad .. ' ')) or tobool(string.find(strLow, ' ' .. bad .. ' ')) or tobool(string.find(strLow, ';')) then return true end
	end
end