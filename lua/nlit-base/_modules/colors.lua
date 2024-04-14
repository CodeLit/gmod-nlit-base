--- The module that contains colors. Client only.
-- @module nlitColors
-- @usage local c = nlitColors
-- c:White()
-- c:Red(<trasparency from 0 to 255>)
-- c:Yellow(100)
-- @usage -- As global variable NC
-- NC:White()
-- NC:Black()
module('nlitColors', package.seeall)
local Color = Color
local math = math
local CurTime = CurTime
local tobool = tobool
--- White
-- @param a transparency
function White(self, a)
    return Color(255, 255, 255, a)
end

--- Light
-- @param a transparency
function Light(self, a)
    return White(self, a)
end

--- Black
-- @param a transparency
function Black(self, a)
    return Color(0, 0, 0, a)
end

--- Dark
-- @param a transparency
function Dark(self, a)
    return Black(self, a)
end

--- Grey
-- @param a transparency
-- @param n amount of grey
function Grey(self, a, n)
    return n and Color(n, n, n, a) or Color(100, 100, 100, a)
end

--- Red
-- @param a transparency
function Red(self, a)
    return Color(255, 0, 0, a)
end

--- DarkRed
-- @param a transparency
function DarkRed(self, a)
    return Color(80, 0, 0, a)
end

--- Green
-- @param a transparency
function Green(self, a)
    return Color(0, 255, 0, a)
end

--- DarkGreen
-- @param a transparency
function DarkGreen(self, a)
    return Color(0, 80, 0, a)
end

--- DarkBlue
-- @param a transparency
function DarkBlue(self, a)
    return Color(0, 0, 255, a)
end

--- Yellow
-- @param a transparency
function Yellow(self, a)
    return Color(255, 255, 0, a)
end

--- DarkYellow
-- @param a transparency
function DarkYellow(self, a)
    return Color(100, 100, 0, a)
end

--- Orange
-- @param a transparency
function Orange(self, a)
    return Color(255, 128, 0, a)
end

--- Pink
-- @param a transparency
function Pink(self, a)
    return Color(255, 0, 255, a)
end

--- Blue
-- @param a transparency
function Blue(self, a)
    return Color(0, 255, 255, a)
end

--- Tint
-- @param a transparency
-- @param tint color
function Tint(self, tint, a)
    return Color(tint, tint, tint, a)
end

--- Police color. Depends of current time.
-- @param a transparency
function Police(self, a)
    local sin = (math.sin(CurTime() * 7) + 1) / 2 * 255
    return Color(255 - sin, 0, sin, a)
end

--- LightTheme color
function LightTheme(self)
    return Color(73, 20, 138, 240)
end

--- DarkTheme color
function DarkTheme(self)
    return Tint(self, 50, 240)
end

--- LightThemeText color
function LightThemeText(self)
    return White(self, 230)
end

--- DarkThemeText color
function DarkThemeText(self)
    return White(self, 230)
end

---Is currently used LightTheme.
---@return boolean
function IsLightTheme(self, bReverse)
    local bool = tobool(nlitCfg:Get(nlitCfg.Name, 'Light theme'))
    return bReverse and not bool or bool
end

-- NHUD = NHUD or {}
-- function NHUD:Color()
-- 	return Color(255, 255, 0, 100)
-- end
-- HUD.Color = nil
--- Theme color
-- @param bReverse dynamic flag - true if you want to reverse theme 
function Theme(self, bReverse)
    local lt = IsLightTheme(bReverse)
    if NHUD and NHUD.Color then
        local hudc = NHUD:Color()
        local mul = 3
        -- return lt and Color(hudc.r*mul, hudc.g*mul, hudc.b*mul, hudc.a) or hudc
        return hudc
    end
    return lt and LightTheme(self) or DarkTheme(self)
end

--- ThemeInside color
-- @param bReverse dynamic flag - true if you want to reverse theme
function ThemeInside(self, bReverse)
    local c = Theme()
    local addCol = 7
    addCol = IsLightTheme(self) and addCol or (addCol * -1)
    return Color(c.r - addCol, c.g - addCol, c.b - addCol, c.a)
end

--- ThemeText color
-- @param bReverse dynamic flag - true if you want to reverse theme
function ThemeText(self, bReverse)
    return IsLightTheme(self, bReverse) and LightThemeText(self) or DarkThemeText(self)
end