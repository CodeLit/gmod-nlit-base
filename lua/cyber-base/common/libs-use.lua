local pathToLibs = 'cyber-libs'

CW:AddAllInFolder(pathToLibs,true)

local finders = {}

function finders:FindLuaLibInFiles(files,lib)
	for _,f in pairs(files) do
		if CWStr:Contains(f,'.lua') and CWStr:Contains(f,lib) then
			return f
		end
	end
end

function finders:LookupForLib(folders,path,lib)
	for _,folder in pairs(folders) do
		local found = finders:FindLibPathInFolder(path..'/'..folder,lib)
		if found then return found end
	end
end

function finders:FindLibPathInFolder(path,lib)
	local files,folders = file.Find(path..'/*', 'LUA')
	local found = finders:FindLuaLibInFiles(files,lib)
	if found then
		return path..'/'..found
	end
	return finders:LookupForLib(folders,path,lib)
end

function CW:UseLib(libName)

	local found = finders:FindLibPathInFolder(pathToLibs,libName)

	if not found then
		-- PrintError('Не найдена библиотека [' .. path .. '] в файле ' .. NFiles:curPath()() .. '!')
		PrintError('Не найдена библиотека [' .. libName .. ']!')

		return
	end

	return include(found)
end