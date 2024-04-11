local draw = draw
local vgui = vgui
local table = table
local ipairs = ipairs
local IsValid = IsValid
local timer = timer
local pairs = pairs
local LocalPlayer = LocalPlayer


---Creates GUI Frames
---@module Frames
---@usage local Frames = CWGUI.Frames
local Frames = {}
local Buttons = CWGUI.Buttons
local Inputs = CWGUI.Inputs
local ScrW, ScrH = ScrW, ScrH

---Returns a newly created frame
---@param title string
---@return frame
---@usage Frames:Create('MyLovelyFrame')
function Frames:Create(title)
    local fr = self:Unfocused(title)
    fr:MakePopup()

    return fr
end

---Adds frame behavior to frame (standartizes a frame)
---@param fr framePanel
---@param title string
function Frames:AddBehavior(fr, title)
    fr:SetDraggable(true)
    fr:SetSizable(false)
    fr:SetTitle(title or '')
    fr:SetBackgroundBlur(true)
    fr:SetPaintShadow(true)
    self:Resize(fr)
    fr.btnMinim:SetVisible(false)
    fr.btnMaxim:SetVisible(false)
    fr.btnClose:SetVisible(false)

    local close = fr:Add(Buttons:Decline('X', function()
        fr:Close()
    end))

    close:SetSize(35, 25)
    close:SetPos(fr:GetWide() - close:GetWide(), 0)
    close:SetFont('N')

    fr.lblTitle.UpdateColours = function(label)
        label:SetTextStyleColor(CWC:ThemeText())
    end

    fr.lblTitle:SetFont('N')

    fr.Paint = function(pnl)
        -- Draw the menu background color.
        draw.RoundedBox(6, 0, 0, pnl:GetWide(), pnl:GetTall(), fr.NBackgroundColor or CWC:ThemeInside())
    end
end

---Resizes a frame
---@param fr frame
function Frames:Resize(fr)
    fr:SetSize(ScrW() * 0.7, ScrH() * 0.8)
    fr:Center()
end

CW.OpenedFrames = CW.OpenedFrames or {}

---Creates an unfocused frame
---@param title string
---@return frame
---@see Create
function Frames:Unfocused(title)
    local fr = vgui.Create('DFrame')
    table.insert(CW.OpenedFrames, fr)

    for index, value in ipairs(CW.OpenedFrames) do
        if not IsValid(value) then
            table.remove(CW.OpenedFrames, index)
        end
    end

    self:AddBehavior(fr, title)

    return fr
end

---Creates a frame with inputs
---@param title string
---@param acceptFunc function
---@param typeOfInput string
---@return frame
---@see Inputs:Create
function Frames:Input(title, acceptFunc, typeOfInput)
    local fr = self:Create()
    fr:SetIcon('icon16/pencil.png')
    fr:SetSize(ScrW() / 4, 85)
    fr:Center()
    local inp = fr:Add(Inputs:Create(title, acceptFunc, typeOfInput, fr))
    inp:Dock(FILL)
    fr.mainPanel = inp

    timer.Simple(0, function()
        inp.editPanel:RequestFocus()
    end)

    local c = inp.subPanel:Add(Buttons:Accept())
    c:Dock(RIGHT)
    c:SetWide(fr:GetWide() / 4)

    c.DoClick = function()
        inp.editPanel.OnEnter()
    end

    for _, v in pairs(inp.subPanel:GetChildren()) do
        v:DockMargin(2, 0, 2, 0)
    end

    return fr
end

---Creates a binder frame
function Frames:Binder(title, command)
    local fr = self:Create(title)
    fr:SetSize(250, 100)
    fr:Center()
    local color = CWC:ThemeInside()
    color.a = 255
    fr.NBackgroundColor = color
    local binder = fr:Add(Buttons:BinderPanel(command))

    return fr, binder
end

--- Specific type of frame named rules editor
---/ окно для редактирования каких-либо правил (для зоны, для админки и т.п.)
function Frames:Rules(title, checkBoxes, acceptFunc)
    local fr = self:Create()
    fr:SetIcon('icon16/pencil.png')
    fr:SetSize(400, 400)
    fr:SetTitle(title)
    fr:Center()
    local scroll = fr:Add('DScrollPanel')
    scroll:Dock(FILL)
    local chArray = {}

    for k, v in pairs(checkBoxes) do
        local p = scroll:Add('DPanel')
        p:SetPaintBackground(true)
        p:SetBackgroundColor(CWC:Grey(100))
        p:Dock(TOP)
        p:DockMargin(0, 2, 0, 2)
        local ch = p:Add('DCheckBoxLabel')
        ch:SetValue(v.checked)
        ch:Dock(FILL)
        ch:SetText(v.name)
        ch:SetFont('N')
        ch:SetTextColor(CWC:White())
        ch:DockMargin(5, 0, 0, 5)
        ch.Button:Dock(LEFT)
        ch.Button:DockMargin(0, 4, 0, 0)
        ch.rule = k
        table.insert(chArray, ch)
    end

    local p1 = vgui.Create('DPanel', fr)
    p1:SetPaintBackground(false)
    p1:Dock(BOTTOM)
    local c = p1:Add(Buttons:Accept())
    c:Dock(RIGHT)
    c:SetWide(150)

    c.DoClick = function()
        local checkedStr = ''

        for _, v in pairs(chArray) do
            if v:GetChecked() then
                checkedStr = checkedStr .. v.rule
            end
        end

        fr:Close()
        acceptFunc(checkedStr)
    end

    for _, v in pairs(p1:GetChildren()) do
        v:DockMargin(2, 0, 2, 0)
    end

    return fr
end

---Accept Dialogue frame
---@param text string
---@param textYes string
---@param textNo string
---@param acceptFunc function
---@return frame
function Frames:AcceptDialogue(text, textYes, textNo, acceptFunc)
    local fr = self:Create()
    fr:SetIcon('icon16/help.png')
    fr:SetWide(530)
    local txt = vgui.Create('DMultiline', fr)
    txt:SetText(text)
    txt:SetContentAlignment(5)
    txt:DockPadding(2, 2, 2, 2)
    txt:Dock(FILL)
    txt:SetTextColor(CWC:ThemeText())
    txt:SetFont('N_small')

    if LocalPlayer():GetLang() == 'ru' then
        fr:SetTall(#text / 1.5)
    else
        fr:SetTall(#text * 1.5)
    end

    fr:Center()
    local p2 = vgui.Create('DPanel', fr)
    p2:SetPaintBackground(false)
    p2:Dock(BOTTOM)
    local d = p2:Add(Buttons:Decline(textNo))
    d:Dock(LEFT)
    d:SetWide(fr:GetWide() / 4)

    d.DoClick = function()
        fr:Close()
    end

    local c = p2:Add(Buttons:Accept(textYes))
    c:Dock(RIGHT)
    c:SetWide(fr:GetWide() / 4)

    c.DoClick = function()
        fr:Close()
        acceptFunc()
    end

    for _, v in pairs(p2:GetChildren()) do
        v:DockMargin(2, 0, 2, 0)
    end

    fr:SetTall(fr:GetTall() + 50)

    return fr
end

---Frame with list
---@param title any
---@return table
function Frames:List(title)
    local fr = self:Create(title)
    local scroll = fr:Add('DScrollPanel')
    scroll:Dock(FILL)
    fr.list = scroll:Add(CWGUI.Lists:List())
    fr.list:Dock(TOP)

    return fr
end

---Frame with many fields
---@param text any
---@param tblFields any
---@param acceptFunc any
---@return string|table
---@return any
function Frames:ManyFields(text, tblFields, acceptFunc)
    local fr = self:Create(text)
    local tile = fr:Add(CWGUI.Inputs:Fields(tblFields, acceptFunc))

    return fr, tile.inputs
end

return Frames