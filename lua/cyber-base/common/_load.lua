--- Global shared module. Allows run code on start, and reload it on save
-- / Позволяет запускать код на старте, перезапускать его при сохранении
-- @module LoadCode

---Load code after entities was initialized. Global function.
---@param hookName string unique name for future removal
---@param loadTime number [optional] - delay for loading code
---@param doCode function
function DefinetlyLoad(hookName,loadTime,doCode)

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

---Load code after gamemode was initialized. Global function.
---@param hookName string unique name for future removal
---@param loadTime number [optional] - delay for loading code
---@param doCode function
function WhenGMLoaded(hookName,loadTime,doCode)

	if isfunction(loadTime) then
		doCode = loadTime
		loadTime = 0
	end

	local function DoIfGM()
		if GAMEMODE then
			doCode()
		end
	end

	local function Run()
		timer.Simple(loadTime, DoIfGM)
	end

	DoIfGM()

	if CLIENT then

		-- TODO: Оптимизировать так, чтобы таймер был один, но хуки вызывались все
		timer.Create('NCommon GM Loading '..hookName, 0.05, 0, function()
			if GAMEMODE then
				timer.Remove('NCommon GM Loading '..hookName)
				Run()
			end
		end)
	else
		hook.Add('PostGamemodeLoaded',hookName,Run) -- НЕ РАБОТАЕТ НА КЛИЕНТЕ
	end
end
