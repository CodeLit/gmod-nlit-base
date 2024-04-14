--- The libfiner is an importer module for nlit libraries. Global shared module.
-- @module nlitLib
-- @usage local libs = nlitLib
-- @see nlit
module('nlitLib', package.seeall)
local tobool = tobool
local string = string
local include = include
local pairs = pairs
local file = file
local nlit = nlit
local pathToLibs = 'nlit-libs'
--- Using of Nlit lib. Basic fucntion.
-- @param libName string
-- @return table lib
-- @usage local libs = nlitLib
-- local colors = libs.Colors
-- Button:SetBackgroundColor(colors:White())
-- local Strings = libs:Lib('strings')
-- ...
function Load(self, libName)
    local found = FindLibPathInFolder(self, pathToLibs, string.lower(libName))
    if not found then
        print('[Nlit\'s Framework][ERROR] Library [' .. libName .. '] is not found!')
        return
    end
    return include(found)
end

local function StringContains(str, text)
    return tobool(string.find(str, text))
end

function FindLuaLibInFiles(self, files, lib)
    for _, f in pairs(files) do
        if StringContains(f, '.lua') and StringContains(f, lib) then return f end
    end
end

function LookupForLib(self, folders, path, lib)
    for _, folder in pairs(folders) do
        local found = self:FindLibPathInFolder(path .. '/' .. folder, lib)
        if found then return found end
    end
end

function FindLibPathInFolder(self, path, lib)
    local files, folders = file.Find(path .. '/*', 'LUA')
    local found = self:FindLuaLibInFiles(files, lib)
    if found then return path .. '/' .. found end
    return self:LookupForLib(folders, path, lib)
end

nlit:AddAllInFolder(pathToLibs, true)