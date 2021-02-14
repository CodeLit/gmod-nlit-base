--- The module that contains colors.
-- @module Colors
-- @usage local colors = CW:UseLib('colors')
-- colors:White()
-- colors:Red(<trasparency from 0 to 255>)
-- colors:Yellow(100)
local Colors = {}

--- White
function Colors:White(a) return Color(255,255,255,a) end

--- Light
function Colors:Light(a) return self:White(a) end

--- Black
function Colors:Black(a) return Color(0,0,0,a) end

--- Dark
function Colors:Dark(a) return self:Black(a) end

--- Grey
-- @param a transparency
-- @param n amount of grey
function Colors:Grey(a,n) return n and Color(n,n,n,a) or Color(100,100,100,a) end

--- Red
function Colors:Red(a) return Color(255,0,0,a) end

function Colors:DarkRed(a) return Color(80,0,0,a) end
function Colors:Green(a) return Color(0,255,0,a) end
function Colors:DarkGreen(a) return Color(0,80,0,a) end
function Colors:DarkBlue(a) return Color(0,0,255,a) end
function Colors:Yellow(a) return Color(255,255,0,a) end
function Colors:DarkYellow(a) return Color(100,100,0,a) end
function Colors:Orange(a) return Color(255,128,0,a) end
function Colors:Pink(a) return Color(255,0,255,a) end
function Colors:Blue(a) return Color(0,255,255,a) end

function Colors:Tint(tint,a) return Color(tint,tint,tint,a) end

function Colors:Police(a)
	local sin = (math.sin(CurTime()*7)+1)/2*255
	return Color(255-sin,0,sin,a)
end

function Colors:LightTheme()
	return Color(73, 20, 138, 240)
end

function Colors:DarkTheme()
	return self:Tint(50,240)
end

function Colors:LightThemeText()
	return self:White(230)
end

function Colors:DarkThemeText()
	return self:White(230)
end

function Colors:IsLightTheme(bReverse)
	local bool = tobool(NCfg:Get(NCfg.Name,'Light theme'))
	return bReverse and !bool or bool
end

-- NHUD = NHUD or {}

-- function NHUD:Color()
-- 	return Color(255, 255, 0, 100)
-- end

-- HUD.Color = nil

function Colors:Theme(bReverse)
	local lt = self:IsLightTheme(bReverse)
	if NHUD and NHUD.Color then
		local hudc = NHUD:Color()
		local mul = 3
		-- return lt and Color(hudc.r*mul, hudc.g*mul, hudc.b*mul, hudc.a) or hudc
		return hudc
	end
	return lt and self:LightTheme() or self:DarkTheme()
end

function Colors:ThemeInside(bReverse)
	local c = self:Theme()
	local addCol = 7
	addCol = self:IsLightTheme() and addCol or (addCol*-1)
	return Color(c.r-addCol, c.g-addCol, c.b-addCol, c.a)
end

function Colors:ThemeText(bReverse)
	return self:IsLightTheme(bReverse) and self:LightThemeText() or self:DarkThemeText()
end

return Colors