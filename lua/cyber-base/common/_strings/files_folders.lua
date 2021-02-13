-- string.StripExtension(f) -- пригодится для убирания расширения файла

function CWStr:GetFileName(str)
	return str:match("^.+/(.+)%.")
end

function CWStr:GetFileNameExt(str)
	return str:match("^.+/(.+)$")
end

function CWStr:GetFileExt(str)
	return str:match("%.(.+)$")
end

function CWStr:GetFilePath(str)
	return str:match("^(.+)/") .. '/'
end