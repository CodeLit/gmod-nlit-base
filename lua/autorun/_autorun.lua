local AddCSLuaFile = AddCSLuaFile
local file = file
local pairs = pairs
local string = string
local include = include
local print = print
---Main global module of cyberwolf's addons
---@module CW
CW = {}
AddCSLuaFile()
local DebugCL = false
local DebugSV = false

---AutoExecuter and files adder. Adds folder files on server or client, depends of file extention. Example: file_cl.lua will be added to client, and file_sv.lua will be added to server, file.lua will be added to both. file_dis.lua will disable adding.
---@param folderpath string
---@param bDontinclude boolean Dont include files in folders
---@usage CW:AddAllInFolder('my-folder-in-lua-directory')
---
--- -- true for add to client scripts, but not execute the code
--- CW:AddAllInFolder('my-code/subfolder',true)
function CW:AddAllInFolder(folderpath, bDontinclude)
    local files, directories = file.Find(folderpath .. '/*', 'LUA')

    for _, filename in pairs(files) do
        if not string.find(filename, '.lua') or string.find(filename, '_dis.lua') then continue end
        local path = folderpath .. '/' .. filename

        if string.find(filename, '_cl.lua') or filename == 'cl.lua' then
            if SERVER then
                AddCSLuaFile(path)
            elseif CLIENT then
                if not bDontinclude then
                    include(path)
                end

                if DebugCL then
                    print('Added CL file [' .. path .. ']')
                end
            end
        elseif SERVER and string.find(filename, '_sv.lua') or filename == 'sv.lua' then
            if not bDontinclude then
                include(path)
            end

            if DebugSV then
                print('Added SV file [' .. path .. ']')
            end
        else
            AddCSLuaFile(path)

            if not bDontinclude then
                include(path)
            end

            if DebugCL or DebugSV then
                print('Added SH file [' .. path .. ']')
            end
        end
    end

    for _, foldername in pairs(directories) do
        if not string.EndsWith(foldername, "_dis") then
            self:AddAllInFolder(folderpath .. '/' .. foldername)
        end
    end
end

CW:AddAllInFolder('cyber-base')