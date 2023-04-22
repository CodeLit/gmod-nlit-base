local Color = Color
local math = math
local CurTime = CurTime
local tobool = tobool
--- The module that contains colors. Client only.
-- @module Colors
-- @usage local colors = CWGUI.Colors
-- colors:White()
-- colors:Red(<trasparency from 0 to 255>)
-- colors:Yellow(100)
local Colors = {}

--- White
function Colors:White(a)
    return Color(255, 255, 255, a)
end

--- Light
function Colors:Light(a)
    return self:White(a)
end

--- Black
function Colors:Black(a)
    return Color(0, 0, 0, a)
end

--- Dark
function Colors:Dark(a)
    return self:Black(a)
end

--- Grey
-- @param a transparency
-- @param n amount of grey
function Colors:Grey(a, n)
    return n and Color(n, n, n, a) or Color(100, 100, 100, a)
end

--- Red
function Colors:Red(a)
    return Color(255, 0, 0, a)
end

--- DarkRed
function Colors:DarkRed(a)
    return Color(80, 0, 0, a)
end

--- Green
function Colors:Green(a)
    return Color(0, 255, 0, a)
end

--- DarkGreen
function Colors:DarkGreen(a)
    return Color(0, 80, 0, a)
end

--- DarkBlue
function Colors:DarkBlue(a)
    return Color(0, 0, 255, a)
end

--- Yellow
function Colors:Yellow(a)
    return Color(255, 255, 0, a)
end

--- DarkYellow
function Colors:DarkYellow(a)
    return Color(100, 100, 0, a)
end

--- Orange
function Colors:Orange(a)
    return Color(255, 128, 0, a)
end

--- Pink
function Colors:Pink(a)
    return Color(255, 0, 255, a)
end

--- Blue
function Colors:Blue(a)
    return Color(0, 255, 255, a)
end

--- Tint
function Colors:Tint(tint, a)
    return Color(tint, tint, tint, a)
end

--- Police color. Depends of current time.
function Colors:Police(a)
    local sin = (math.sin(CurTime() * 7) + 1) / 2 * 255

    return Color(255 - sin, 0, sin, a)
end

--- LightTheme color
function Colors:LightTheme()
    return Color(73, 20, 138, 240)
end

--- DarkTheme color
function Colors:DarkTheme()
    return self:Tint(50, 240)
end

--- LightThemeText color
function Colors:LightThemeText()
    return self:White(230)
end

--- DarkThemeText color
function Colors:DarkThemeText()
    return self:White(230)
end

---Is currently used LightTheme.
---@return boolean
function Colors:IsLightTheme(bReverse)
    local bool = tobool(CWCfg:Get(CWCfg.Name, 'Light theme'))

    return bReverse and not bool or bool
end

-- NHUD = NHUD or {}
-- function NHUD:Color()
-- 	return Color(255, 255, 0, 100)
-- end
-- HUD.Color = nil
--- Theme color
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

--- ThemeInside color
function Colors:ThemeInside(bReverse)
    local c = self:Theme()
    local addCol = 7
    addCol = self:IsLightTheme() and addCol or (addCol * -1)

    return Color(c.r - addCol, c.g - addCol, c.b - addCol, c.a)
end

--- ThemeText color
function Colors:ThemeText(bReverse)
    return self:IsLightTheme(bReverse) and self:LightThemeText() or self:DarkThemeText()
end

return Colors