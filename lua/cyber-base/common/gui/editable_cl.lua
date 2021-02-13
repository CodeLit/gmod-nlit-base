local function PrepareTextArea(pnl)
    pnl:ReadyTextbox()
    pnl:SetTextColor(CWC:ThemeText())
end

function CWGUI:EditPanel(text, acceptFunc)
    local e = TDLib('DTextEntry')
    e:SetPlaceholderText(text or l('Введите текст')..'...')
    e:SetPlaceholderColor(CWC:ThemeText())
    PrepareTextArea(e)

    e.OnEnter = function()
        acceptFunc(e:GetValue())
    end

    return e
end

function CWGUI:NumPanel(text, acceptFunc)
    local e = TDLib('DNumberWang')
    e:SetPlaceholderText(text or l('Введите число')..'...')
    e:SetPlaceholderColor(CWC:ThemeText())
    e:SetText('')
    PrepareTextArea(e)
    local limit = 9999999999
    e:SetMinMax(limit * -1, limit)

    e.OnEnter = function()
        acceptFunc(tonumber(e:GetValue()))
    end

    e.AllowInput = function(pnl, input) return not CWStr:OnlyContainsNumbers(input) end

    return e
end

function CWGUI:NumSlider(text, min, max, decimal)
    local numslider = vgui.Create("DNumSlider")
    numslider:SetSize(100, 100)
    numslider:SetPos(10, 10)
    numslider:SetMin(min or 0)
    numslider:SetMax(max or 1)
    numslider:SetDecimals(decimal or 0)

    numslider.Paint = function(self, w, h)
        surface.SetDrawColor(CWC:ThemeInside())
        numslider:DrawFilledRect()
        draw.DrawText(l(text) or "", 'N', w / 2, 0, CWC:ThemeText(), 1)
    end

    numslider.PerformLayout = function(self)
        self:SizeToContents()
    end

    return numslider
end