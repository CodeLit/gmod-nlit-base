--- This module provides functions to create and manage GUI frames.
-- @module GUIFrames
-- @usage local Frames = NGUI.Frames
local Frames = {}
local draw = draw
local vgui = vgui
local table = table
local ipairs = ipairs
local IsValid = IsValid
local timer = timer
local pairs = pairs
local LocalPlayer = LocalPlayer
local Buttons = nlitLib:Load('buttons')
local Inputs = nlitLib:Load('inputs')
local ScrW, ScrH = ScrW, ScrH
local NC = NC
--- Returns a newly created frame with the specified title.
-- @param title string The title of the frame.
-- @return frame Newly created frame.
function Frames:Create(title)
    local fr = self:Unfocused(title)
    fr:MakePopup()
    return fr
end

--- Adds standard behaviors to a frame like draggable, no resize, and custom close button.
-- @param fr framePanel The frame to which the behavior will be added.
-- @param title string The title of the frame.
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
    local close = fr:Add(Buttons:Decline('X', function() fr:Close() end))
    close:SetSize(35, 25)
    close:SetPos(fr:GetWide() - close:GetWide(), 0)
    close:SetFont('N')
    fr.lblTitle.UpdateColours = function(label) label:SetTextStyleColor(NC:ThemeText()) end
    fr.lblTitle:SetFont('N')
    fr.Paint = function(pnl) draw.RoundedBox(6, 0, 0, pnl:GetWide(), pnl:GetTall(), fr.NBackgroundColor or NC:ThemeInside()) end
end

--- Resizes the frame to a standard size based on screen dimensions.
-- @param fr frame The frame to resize.
function Frames:Resize(fr)
    fr:SetSize(ScrW() * 0.7, ScrH() * 0.8)
    fr:Center()
end

Frames.OpenedFrames = Frames.OpenedFrames or {}
--- Creates an unfocused frame, usually for background use.
-- @param title string The title of the frame.
-- @return frame The newly created unfocused frame.
function Frames:Unfocused(title)
    local fr = vgui.Create('DFrame')
    table.insert(self.OpenedFrames, fr)
    for index, value in ipairs(self.OpenedFrames) do
        if not IsValid(value) then table.remove(self.OpenedFrames, index) end
    end

    self:AddBehavior(fr, title)
    return fr
end

--- Creates a frame dedicated to input fields.
-- @param title string The title for the input field.
-- @param acceptFunc function The function to call on input accept.
-- @param typeOfInput string Specifies the type of input.
-- @return frame The frame containing the input.
function Frames:Input(title, acceptFunc, typeOfInput)
    local fr = self:Create()
    fr:SetIcon('icon16/pencil.png')
    fr:SetSize(ScrW() / 4, 85)
    fr:Center()
    local inp = fr:Add(Inputs:Create(title, acceptFunc, typeOfInput, fr))
    inp:Dock(FILL)
    fr.mainPanel = inp
    timer.Simple(0, function() inp.editPanel:RequestFocus() end)
    local c = inp.subPanel:Add(Buttons:Accept())
    c:Dock(RIGHT)
    c:SetWide(fr:GetWide() / 4)
    c.DoClick = function()
        inp.editPanel.OnEnter()
        fr:Close()
    end

    for _, v in pairs(inp.subPanel:GetChildren()) do
        v:DockMargin(2, 0, 2, 0)
    end
    return fr
end

--- Creates a frame specifically for binding commands or actions.
-- @param title string The title of the frame.
-- @param command string The command to bind.
-- @return frame, binder The frame and the binder panel.
function Frames:Binder(title, command)
    local fr = self:Create(title)
    fr:SetSize(250, 100)
    fr:Center()
    local color = NC:ThemeInside()
    color.a = 255
    fr.NBackgroundColor = color
    local binder = fr:Add(Buttons:BinderPanel(command))
    return fr, binder
end

--- Creates a rules editor frame with checkboxes for various options.
-- @param title string The title of the rules editor.
-- @param checkBoxes table A table of checkboxes to include.
-- @param acceptFunc function The function to call when changes are accepted.
-- @return frame The rules editor frame.
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
        p:SetBackgroundColor(NC:Grey(100))
        p:Dock(TOP)
        p:DockMargin(0, 2, 0, 2)
        local ch = p:Add('DCheckBoxLabel')
        ch:SetValue(v.checked)
        ch:Dock(FILL)
        ch:SetText(v.name)
        ch:SetFont('N')
        ch:SetTextColor(NC:White())
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
            if v:GetChecked() then checkedStr = checkedStr .. v.rule end
        end

        fr:Close()
        acceptFunc(checkedStr)
    end

    for _, v in pairs(p1:GetChildren()) do
        v:DockMargin(2, 0, 2, 0)
    end
    return fr
end

--- Creates a dialogue frame with accept and decline options.
-- @param text string The text to display in the dialogue.
-- @param textYes string The text for the accept button.
-- @param textNo string The text for the decline button.
-- @param acceptFunc function The function to execute on accept.
-- @return frame The dialogue frame.
function Frames:AcceptDialogue(text, textYes, textNo, acceptFunc)
    local fr = self:Create()
    fr:SetIcon('icon16/help.png')
    fr:SetWide(530)
    local txt = vgui.Create('DMultiline', fr)
    txt:SetText(text)
    txt:SetContentAlignment(5)
    txt:DockPadding(2, 2, 2, 2)
    txt:Dock(FILL)
    txt:SetTextColor(NC:ThemeText())
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
    d.DoClick = function() fr:Close() end
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

--- Creates a frame containing a list derived from a specified source.
-- @param title any The title of the list frame.
-- @return frame The frame containing the list.
function Frames:List(title)
    local fr = self:Create(title)
    local scroll = fr:Add('DScrollPanel')
    scroll:Dock(FILL)
    fr.list = scroll:Add(NGUI.Lists:List())
    fr.list:Dock(TOP)
    return fr
end

--- Creates a frame with multiple input fields.
-- @param text any The title or main text for the frame.
-- @param tblFields any The table of fields for inputs.
-- @param acceptFunc any The function to call when inputs are accepted.
-- @return frame, inputs The frame and the collection of inputs.
function Frames:ManyFields(text, tblFields, acceptFunc)
    local fr = self:Create(text)
    local tile = fr:Add(Inputs:Fields(tblFields, acceptFunc))
    return fr, tile.inputs
end
--- @export
return Frames