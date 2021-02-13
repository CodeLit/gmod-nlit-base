AddCSLuaFile()

local DebugCL = false
local DebugSV = false

CW = CW or {}

-- AutoExecute
function CW:AddAllInFolder(folderpath,bDontinclude)
	local files, directories = file.Find(folderpath..'/*','LUA')
	for _,filename in pairs(files) do
		if !string.find(filename,'.lua') or string.find(filename,'_dis.lua') then continue end
		local path = folderpath..'/'..filename
		if string.find(filename,'_cl.lua') or filename == 'cl.lua' then
			if SERVER then
				AddCSLuaFile(path)
			elseif CLIENT then
				if !bDontinclude then
					include(path)
				end
				if DebugCL then
					print('Added CL file ['..path..']')
				end
			end
		elseif SERVER and string.find(filename,'_sv.lua') or filename == 'sv.lua' then
			if !bDontinclude then
				include(path)
			end
			if DebugSV then
				print('Added SV file ['..path..']')
			end
		else
			AddCSLuaFile(path)
			if !bDontinclude then
				include(path)
			end
			if DebugCL or DebugSV then
				print('Added SH file ['..path..']')
			end
		end
	end
	for _,foldername in pairs(directories) do
		if !string.EndsWith(foldername, "_dis") then
			self:AddAllInFolder(folderpath..'/'..foldername)
		end
	end
end

CW:AddAllInFolder('cyber-base')