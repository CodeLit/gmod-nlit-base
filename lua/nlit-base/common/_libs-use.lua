--- The libfiner is an importer module for nlit libraries. Global shared module.
-- @module nlitLibs
-- @usage local libs = nlitLibs
-- @see nlit
module('nlitLibs', package.seeall)

local tobool = tobool
local string = string
local PrintError = PrintError
local include = include
local pairs = pairs
local file = file

local LibFinder = {}

local function IsStringContains(str, text)
    return tobool(string.find(str, text))
end

local pathToLibs = 'nlit-libs'

--- Using of Nlit lib. Basic fucntion.
-- @param libName string
-- @return table lib
-- @usage local libs = nlitLibs
-- local colors = libs.Colors
-- Button:SetBackgroundColor(colors:White())
-- local Strings = libs:Lib('strings')
-- ...
function Lib(libName)
    local found = LibFinder:FindLibPathInFolder(pathToLibs, string.lower(libName))

    if not found then
        PrintError('[Nlit\'s Framework] Library [' .. libName .. '] is not found!')

        return
    end

    return include(found)
end

function FindLuaLibInFiles(files, lib)
    for _, f in pairs(files) do
        if IsStringContains(f, '.lua') and IsStringContains(f, lib) then return f end
    end
end

function LookupForLib(folders, path, lib)
    for _, folder in pairs(folders) do
        local found = self:FindLibPathInFolder(path .. '/' .. folder, lib)
        if found then return found end
    end
end

function FindLibPathInFolder(path, lib)
    local files, folders = file.Find(path .. '/*', 'LUA')
    local found = self:FindLuaLibInFiles(files, lib)
    if found then return path .. '/' .. found end

    return self:LookupForLib(folders, path, lib)
end

AddAllInFolder(pathToLibs, true)

