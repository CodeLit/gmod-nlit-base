--- Global shared module. Allows run code on start, and reload it on save
-- @module nlitLoad
module('nlitLoad', package.seeall)
local isfunction = isfunction
local timer = timer
local hook = hook
--- Load code after entities was initialized. Global function.
-- Former deprecated name is DefinetlyLoad
-- @param hookName string unique name for future removal
-- @param loadTime number [optional] - delay for loading code
-- @param doCode function
-- @usage nlitLoad.EnsureLoad('MyHook',0,function() print('Hello') end)
function EnsureLoad(hookName, loadTime, doCode)
    if isfunction(loadTime) then
        doCode = loadTime
        loadTime = 0
    end

    local function Run()
        timer.Simple(loadTime, doCode)
    end

    doCode()
    hook.Add('InitPostEntity', hookName, Run)
end

--- Load code after gamemode was initialized. Global function.
-- @param hookName string unique name for future removal
-- @param loadTime number [optional] - delay for loading code
-- @param doCode function
-- @usage nlitLoad.WhenGMLoaded('MyHook',0,function() print('Hello') end)
function WhenGMLoaded(hookName, loadTime, doCode)
    if isfunction(loadTime) then
        doCode = loadTime
        loadTime = 0
    end

    local function DoIfGM()
        if GAMEMODE then doCode() end
    end

    local function Run()
        timer.Simple(loadTime, DoIfGM)
    end

    DoIfGM()
    if CLIENT then
        -- TODO: To optimize it, so that the timer was one, but the hooks called all
        timer.Create('NCommon GM Loading ' .. hookName, 0.05, 0, function()
            if GAMEMODE then
                timer.Remove('NCommon GM Loading ' .. hookName)
                Run()
            end
        end)
    else
        hook.Add('PostGamemodeLoaded', hookName, Run) -- DOESN'T WORK ON THE CLIENT
    end
end