-- Позволяет запускать код на старте, а еще перезапускать его при сохранении
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

function WhenGMLoaded(hookName,loadingTime,doCode)

	if !isfunction(doCode) then
		doCode = loadingTime
		loadingTime = 0
	end

	local function DoIfGM()
		if GAMEMODE then
			doCode()
		end
	end

	local function Run()
		timer.Simple(loadingTime, DoIfGM)
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
