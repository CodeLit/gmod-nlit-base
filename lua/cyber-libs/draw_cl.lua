local Color = Color
local string = string
local pairs = pairs
local input = input
local IsValid = IsValid
local table = table
local SortedPairs = SortedPairs
local IsColor = IsColor
local PrintError = PrintError
local tostring = tostring
local mesh = mesh
local Vector = Vector
---Draw module. Clientside only. Works only with 2D rendering hooks.
---See wiki.facepunch.com/gmod/2d_Rendering_Hooks
---@module Draw
local Draw = {}
local draw, surface, render, Material, math = draw, surface, render, Material, math
local TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER = TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER

---Draws text
---@param text string
---@param font string
---@param x number
---@param y number
---@param color table
---@param align number
function Draw:Text(text, font, x, y, color, align)
    draw.DrawText(text, font, x + 1, y + 1, Color(0, 0, 0, color.a), align or TEXT_ALIGN_LEFT)
    draw.DrawText(text, font, x, y, color, align or TEXT_ALIGN_LEFT)
end

---Draws multiline text
---@param text string
---@param font string
---@param x number
---@param y number
---@param color table
---@param align number
function Draw:TextMultiLine(text, font, x, y, color, align)
    surface.SetFont(font)
    local _, h = surface.GetTextSize(text)
    draw.DrawText(text, font, x + 1, y + 1 - h / 2, Color(0, 0, 0, color.a), align or TEXT_ALIGN_LEFT)
    draw.DrawText(text, font, x, y - h / 2, color, align or TEXT_ALIGN_LEFT)
end

---Draws outlined text
---@param text string
---@param font string
---@param x number
---@param y number
---@param color table color
---@param align number
function Draw:OutlinedText(text, font, x, y, color, align)
    draw.SimpleTextOutlined(text, font, x, y, color, align or TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1.5, Color(0, 0, 0))
end

---Draws outlined multiline text
---@param text string
---@param font string
---@param x number
---@param y number
---@param color table color
---@param align number
function Draw:OutlinedMultiLineText(text, font, x, y, color, align)
    local expStr = string.Explode("\n", text)
    surface.SetFont(font)
    local _, h = surface.GetTextSize(text)
    local const = h * 0.4

    for i, el in pairs(expStr) do
        self:OutlinedText(el, font, x, (y - #expStr / 2 * const + const / 2) + const * (i - 1), color, align)
    end
end

---Draws centered outlined text
---@param text string
---@param font string
---@param x number
---@param y number
---@param color table color
function Draw:CenteredOutlinedText(text, font, x, y, color)
    self:OutlinedText(text, font, x, y, color, TEXT_ALIGN_CENTER)
end

---Draws centered outlined multiline text
---@param text string
---@param font string
---@param x number
---@param y number
---@param color table color
function Draw:CenteredOutlinedMultilineText(text, font, x, y, color)
    self:OutlinedMultiLineText(text, font, x, y, color, TEXT_ALIGN_CENTER)
end

---Draws centered text
---@param text string
---@param font string
---@param x number
---@param y number
---@param color table color
function Draw:CenteredText(text, font, x, y, color)
    self:Text(text, font, x, y, color, TEXT_ALIGN_CENTER)
end

---Draw line
---@param x number
---@param y number
---@param endX number
---@param endY number
---@param color table
function Draw:Line(x, y, endX, endY, color)
    surface.SetDrawColor(color)
    surface.DrawLine(x, y, endX, endY)
end

---Draws rectangle
---@param x number
---@param y number
---@param w number
---@param h number
---@param color table
function Draw:Rect(x, y, w, h, color)
    surface.SetDrawColor(color)
    surface.DrawRect(x, y, w, h)
end

---Draws outlined rectangle
---@param x number
---@param y number
---@param w number
---@param h number
---@param color table
---@param outlineColor table
function Draw:OutlinedRect(x, y, w, h, color, outlineColor)
    self:Rect(x, y, w, h, color)
    surface.SetDrawColor(outlineColor or CWC:Black())
    surface.DrawOutlinedRect(x, y, w, h)
end

--- Draws colored icon
---@param path string
---@param x number
---@param y number
---@param sizeX number
---@param sizeY number
---@param color table
function Draw:ColorfulIcon(path, x, y, sizeX, sizeY, color)
    surface.SetMaterial(Material(path))
    surface.SetDrawColor(color or CWC:White())
    surface.DrawTexturedRect(x, y, sizeX, sizeY)
end

---Draws icon
---@param path string
---@param x number
---@param y number
---@param sizeX number
---@param sizeY number
---@param trans number transition
function Draw:Icon(path, x, y, sizeX, sizeY, trans)
    self:ColorfulIcon(path, x, y, sizeX, sizeY, CWC:White(trans))
end

---Draws simple linear gradient
---@param x number
---@param y number
---@param w number
---@param h number
---@param startColor table
---@param endColor table
---@param bVertical boolean
function Draw:SimpleLinearGradient(x, y, w, h, startColor, endColor, bVertical)
    self:DistributedLinearGradient(x, y, w, h, {startColor, endColor}, bVertical)
end

---Draws gradient background
---@param panel panel
---@param tblColors table
---@param bVertical boolean
function Draw:GradientBackground(panel, tblColors, bVertical)
    panel.Paint = function(pnl, w, h)
        if not pnl:GetPaintBackground() then return end
        if (input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)) and pnl:IsDragging() then return end
        pnl:InvalidateParent(true)
        local parent = pnl:GetParent()
        local x, y = pnl:LocalToScreen(0, 0)

        while IsValid(parent:GetParent()) do
            if table.HasValue({'DTileLayout', 'DIconLayout'}, parent:GetTable().ThisClass) then
                parent = parent:GetParent():GetParent() -- Потому что DTileLayout обычно в Scroll'e, а скрол обычно не имеет своей позиции
                break
            end

            parent = parent:GetParent()
        end

        local _, py = parent:LocalToScreen(0, 0)
        local _, ph = parent:GetSize()

        if y < py then
            local upy = py - y
            y = y + upy + 1
            h = h - upy - 1
        end

        if y + h > py + ph then
            local downy = (y + h) - (py + ph)
            h = h - downy - 1
        end

        self:DistributedLinearGradient(x, y, w, h, tblColors, bVertical)
    end
end

---Draws outlined background
---@param panel panel
function Draw:OutlineBackground(panel)
    panel.PaintOver = function(pnl)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall())
    end
end

---Draws disturbed linear gradient / Рисует градиент с распределёнными равномерно цветами
---@param x number
---@param y number
---@param w number
---@param h number
---@param tblColors table
---@param bVertical boolean
function Draw:DistributedLinearGradient(x, y, w, h, tblColors, bVertical)
    local stops = {}

    for i, v in SortedPairs(tblColors) do
        if not IsColor(v) then
            PrintError('Неправильный цвет ' .. tostring(v) .. ' для градиента!')
            continue
        end

        local parts = #tblColors - 1
        local onePartOfOne = 1 / parts

        table.insert(stops, {
            offset = (i - 1) * onePartOfOne,
            color = v
        })
    end

    self:LinearGradient(x, y, w, h, stops, bVertical)
end

---Draws linear gradient. The stops argument is a table of GradientStop structures.
---@param x number
---@param y number
---@param w number
---@param h number
---@param stops table
---@param bVertical any
-- @usage draw.LinearGradient(0, 0, 100, 100, {
-- 	{offset = 0, color = Color(255, 0, 0)},
-- 	{offset = 0.5, color = Color(255, 255, 0)},
-- 	{offset = 1, color = Color(255, 0, 0)}
-- }, false)
--
-- == GradientStop structure ==
-- Field  |  Type  | Description
-- ------ | ------ | ---------------------------------------------------------------------------------------
-- offset | number | Where along the gradient should this stop occur, scaling from 0 (beginning) to 1 (end).
-- color  | table  | Color structure of what color this stop should be.
function Draw:LinearGradient(x, y, w, h, stops, bVertical)
    if #stops == 0 then
        return
    elseif #stops == 1 then
        surface.SetDrawColor(stops[1].color)
        surface.DrawRect(x, y, w, h)

        return
    end

    table.SortByMember(stops, 'offset', true)
    render.SetMaterial(Material('vgui/white'))
    mesh.Begin(MATERIAL_QUADS, #stops - 1)

    for i = 1, #stops - 1 do
        local offset1 = math.Clamp(stops[i].offset, 0, 1)
        local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
        if offset1 == offset2 then continue end
        local deltaX1, deltaY1, deltaX2, deltaY2
        local color1 = stops[i].color
        local color2 = stops[i + 1].color
        local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
        local r2, g2, b2, a2
        local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
        local r4, g4, b4, a4

        if bVertical then
            r2, g2, b2, a2 = r3, g3, b3, a3
            r4, g4, b4, a4 = r1, g1, b1, a1
            deltaX1 = offset1 * w
            deltaY1 = 0
            deltaX2 = offset2 * w
            deltaY2 = h
        else
            r2, g2, b2, a2 = r1, g1, b1, a1
            r4, g4, b4, a4 = r3, g3, b3, a3
            deltaX1 = 0
            deltaY1 = offset1 * h
            deltaX2 = w
            deltaY2 = offset2 * h
        end

        mesh.Color(r1, g1, b1, a1)
        mesh.Position(Vector(x + deltaX1, y + deltaY1))
        mesh.AdvanceVertex()
        mesh.Color(r2, g2, b2, a2)
        mesh.Position(Vector(x + deltaX2, y + deltaY1))
        mesh.AdvanceVertex()
        mesh.Color(r3, g3, b3, a3)
        mesh.Position(Vector(x + deltaX2, y + deltaY2))
        mesh.AdvanceVertex()
        mesh.Color(r4, g4, b4, a4)
        mesh.Position(Vector(x + deltaX1, y + deltaY2))
        mesh.AdvanceVertex()
    end

    mesh.End()
end

return Draw