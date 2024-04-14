--- Creates GUI Editable panels
-- @usage local Editable = nlitLib:Load('editable')
local Editable = {}
local TDLib = TDLib
local tonumber = tonumber
local vgui = vgui
local surface = surface
local draw = draw
local l = nlitLib:Load('lang')
local strings = nlitString
local NC = NC
local function PrepareTextArea(pnl)
    pnl:ReadyTextbox()
    pnl:SetTextColor(NC:ThemeText())
end

--- Creates editable panel
-- @param text string Placeholder text
-- @param acceptFunc function OnEnterPressed function
function Editable:EditPanel(text, acceptFunc)
    local e = TDLib('DTextEntry')
    e:SetPlaceholderText(text or l('Введите текст') .. '...')
    e:SetPlaceholderColor(NC:ThemeText())
    PrepareTextArea(e)
    e.OnEnter = function() acceptFunc(e:GetValue()) end
    return e
end

--- Creates editable number panel
-- @see EditPanel
function Editable:NumPanel(text, acceptFunc)
    local e = TDLib('DNumberWang')
    e:SetPlaceholderText(text or l('Введите число') .. '...')
    e:SetPlaceholderColor(NC:ThemeText())
    e:SetText('')
    PrepareTextArea(e)
    local limit = 9999999999
    e:SetMinMax(limit * -1, limit)
    e.OnEnter = function() acceptFunc(tonumber(e:GetValue())) end
    e.AllowInput = function(pnl, input) return not strings:OnlyContainsNumbers(input) end
    return e
end

--- Creates editable slider panel
-- @see EditPanel
function Editable:NumSlider(text, min, max, decimal)
    local numslider = vgui.Create("DNumSlider")
    numslider:SetSize(100, 100)
    numslider:SetPos(10, 10)
    numslider:SetMin(min or 0)
    numslider:SetMax(max or 1)
    numslider:SetDecimals(decimal or 0)
    numslider.Paint = function(el, w, h)
        surface.SetDrawColor(NC:ThemeInside())
        numslider:DrawFilledRect()
        draw.DrawText(l(text) or "", 'N', w / 2, 0, NC:ThemeText(), 1)
    end

    numslider.PerformLayout = function(el) el:SizeToContents() end
    return numslider
end
--- @export
return Editable