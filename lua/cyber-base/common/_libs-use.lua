---The basic function for finding CW libs
---@module CWLibs
local LibFinder = {}

local function IsStringContains(str,text)
	return tobool(string.find(str, text))
end

local pathToLibs = 'cyber-libs'

---Use CW lib. Basic fucntion.
---@param libName string
---@return table lib
function CW:Lib(libName)

	local found = LibFinder:FindLibPathInFolder(pathToLibs,libName)

	if not found then
		-- PrintError('Не найдена библиотека [' .. path .. '] в файле ' .. NFiles:curPath()() .. '!')
		PrintError('Не найдена библиотека [' .. libName .. ']!')

		return
	end

	return include(found)
end

function LibFinder:FindLuaLibInFiles(files,lib)
	for _,f in pairs(files) do
		if IsStringContains(f,'.lua') and IsStringContains(f,lib) then
			return f
		end
	end
end

function LibFinder:LookupForLib(folders,path,lib)
	for _,folder in pairs(folders) do
		local found = self:FindLibPathInFolder(path..'/'..folder,lib)
		if found then return found end
	end
end

function LibFinder:FindLibPathInFolder(path,lib)
	local files,folders = file.Find(path..'/*', 'LUA')
	local found = self:FindLuaLibInFiles(files,lib)
	if found then
		return path..'/'..found
	end
	return self:LookupForLib(folders,path,lib)
end

CW:AddAllInFolder(pathToLibs,true)