CWC = CWC or {}

function CWC:White(a) return Color(255,255,255,a) end
function CWC:Light(a) return self:White(a) end
function CWC:Black(a) return Color(0,0,0,a) end
function CWC:Dark(a) return self:Black(a) end
function CWC:Grey(a,n) return n and Color(n,n,n,a) or Color(100,100,100,a) end
function CWC:Red(a) return Color(255,0,0,a) end
function CWC:DarkRed(a) return Color(80,0,0,a) end
function CWC:Green(a) return Color(0,255,0,a) end
function CWC:DarkGreen(a) return Color(0,80,0,a) end
function CWC:DarkBlue(a) return Color(0,0,255,a) end
function CWC:Yellow(a) return Color(255,255,0,a) end
function CWC:DarkYellow(a) return Color(100,100,0,a) end
function CWC:Orange(a) return Color(255,128,0,a) end
function CWC:Pink(a) return Color(255,0,255,a) end
function CWC:Blue(a) return Color(0,255,255,a) end

function CWC:Tint(tint,a) return Color(tint,tint,tint,a) end

function CWC:Police(a)
	local sin = (math.sin(CurTime()*7)+1)/2*255
	return Color(255-sin,0,sin,a)
end

function CWC:LightTheme()
	return Color(73, 20, 138, 240)
end

function CWC:DarkTheme()
	return self:Tint(50,240)
end

function CWC:LightThemeText()
	return self:White(230)
end

function CWC:DarkThemeText()
	return self:White(230)
end

function CWC:IsLightTheme(bReverse)
	local bool = tobool(NCfg:Get(NCfg.Name,'Light theme'))
	return bReverse and !bool or bool
end

-- NHUD = NHUD or {}

-- function NHUD:Color()
-- 	return Color(255, 255, 0, 100)
-- end

-- HUD.Color = nil

function CWC:Theme(bReverse)
	local lt = self:IsLightTheme(bReverse)
	if NHUD and NHUD.Color then
		local hudc = NHUD:Color()
		local mul = 3
		-- return lt and Color(hudc.r*mul, hudc.g*mul, hudc.b*mul, hudc.a) or hudc
		return hudc
	end
	return lt and self:LightTheme() or self:DarkTheme()
end

function CWC:ThemeInside(bReverse)
	local c = self:Theme()
	local addCol = 7
	addCol = self:IsLightTheme() and addCol or (addCol*-1)
	return Color(c.r-addCol, c.g-addCol, c.b-addCol, c.a)
end

function CWC:ThemeText(bReverse)
	return self:IsLightTheme(bReverse) and self:LightThemeText() or self:DarkThemeText()
end