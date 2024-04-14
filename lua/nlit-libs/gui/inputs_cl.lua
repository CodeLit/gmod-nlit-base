--- This module provides functions to create various input panels within a GUI.
-- @module GUIInputs
-- @usage local Inputs = NGUI.Inputs
local Inputs = {}
local IsValid = IsValid
local vgui = vgui
local tonumber = tonumber
local LocalPlayer = LocalPlayer
local isfunction = isfunction
local isstring = isstring
local tobool = tobool
local surface = surface
local pairs = pairs
local Panels = nlitLib:Load('panels')
local Editable = nlitLib:Load('editable')
local l = nlitLib:Load('lang')
local Lists = nlitLib:Load('lists')
local NC = NC -- Make sure NC is defined or imported if needed
--- Creates an input panel
-- @param title string Title or label for the input
-- @param acceptFunc function Function to call when input is accepted
-- @param typeOfInput string Type of the input (bool/table/num/text)
-- @param inputParent panel or frame Parent panel or frame to attach input panel
-- @param inputValue any Default value for the input
-- @return input panel Newly created input panel
function Inputs:Create(title, acceptFunc, typeOfInput, inputParent, inputValue)
    title = l(title)
    local mainP = Panels:Create()
    if IsValid(inputParent) then mainP:SetSize(inputParent:GetWide(), 25) end
    if typeOfInput ~= 'bool' then
        local p1 = mainP:Add(Panels:Create())
        p1:SetBackgroundColor(NC:Theme())
        p1:Dock(TOP)
        p1:DockPadding(2, 2, 2, 2)
        local desc = vgui.Create('DLabel', p1)
        desc:Dock(FILL)
        desc:SetText(title or '')
        desc:SetContentAlignment(5)
        desc:SetFont('N_small')
        desc:SetColor(NC:ThemeText())
        mainP.titlePanel = desc
    end

    local p2 = mainP:Add(Panels:Create())
    p2:SetPaintBackground(false)
    p2:Dock(FILL)
    mainP.subPanel = p2
    local editable
    if typeOfInput == 'table' then
        editable = p2:Add(NGUI.Lists:EditableTable(inputValue))
        function mainP:GetInputValue()
            return editable.tbl or {}
        end
    elseif typeOfInput == 'bool' then
        editable = p2:Add(self:Bool(title, inputValue))
        editable:DockPadding(10, 0, 0, 0)
        mainP.titlePanel = editable.box
        function mainP:GetInputValue()
            return editable.box:GetChecked() and 1 or 0
        end
    elseif typeOfInput == 'num' then
        editable = p2:Add(Editable:NumPanel(_, acceptFunc))
        function mainP:GetInputValue()
            return tonumber(editable:GetValue())
        end

        if inputValue then editable:SetValue(inputValue) end
    else
        editable = p2:Add(Editable:EditPanel('Введите текст...', function(val)
            if typeOfInput == 'allowed' and not strings:OnlyContainsAllowed(val) then
                LocalPlayer():Notify('Введены недопустимые символы!')
                return
            end

            if IsValid(inputParent) then if inputParent:GetName() == 'DFrame' then inputParent:Close() end end
            if isfunction(acceptFunc) then acceptFunc(val) end
        end))

        if isstring(inputValue) then editable:SetValue(inputValue) end
        function mainP:GetInputValue()
            return editable:GetValue()
        end
    end

    editable:Dock(FILL)
    mainP.editPanel = editable
    mainP.editPanel.typeOfInput = typeOfInput
    return mainP
end

--- Boolean input field creator
-- @param title string The label for the checkbox
-- @param defaultValue boolean Default state of the checkbox (checked or not)
-- @return panel Returns a panel containing a checkbox
function Inputs:Bool(title, defaultValue)
    local pnl = Panels:Create()
    pnl:Dock(FILL)
    pnl:SetBackgroundColor(NC:Theme())
    local box = pnl:Add('DCheckBoxLabel')
    box:SetPos(10, 15)
    box.font = 'N_small'
    box:SetFont(box.font)
    box:SetText(title)
    box:SetTextColor(NC:ThemeText())
    box:SetValue(tobool(defaultValue))
    box:SizeToContents()
    function box:GetFont()
        return box.font
    end

    pnl.box = box
    return pnl
end

--- Resizes input panel based on text length and type of input
-- @param inp panel The input panel to resize
function Inputs:Resize(inp)
    local titleP = inp.titlePanel
    local editP = inp.editPanel
    local w, h = 200, 20
    if IsValid(titleP) then
        surface.SetFont(titleP:GetFont())
        w, h = surface.GetTextSize(titleP:GetText())
    end

    if editP.typeOfInput == 'bool' then w = w + 20 end
    inp:SetSize(w + 30, (editP.typeOfInput == 'table' and 250 or 30) + h)
end

--- Creates a panel with many inputs grouped by categories
-- @param tblFields table Key-values of input definitions
-- @param acceptFunc function Callback function for when inputs are accepted
-- @return panel Panel containing categorized inputs
function Inputs:Fields(tblFields, acceptFunc)
    -- TODO: Сделать работоспособной acceptFunc
    local cats = {}
    local mainPanel = Panels:DockScroll()
    local tile = mainPanel:Add(Lists:Tile())
    tile:Dock(TOP)
    mainPanel.inputs = {}
    local function GetInputPanel(cat_name)
        if not cat_name then
            return tile
        elseif IsValid(cats[cat_name]) then
            return cats[cat_name]
        else
            local cat = tile:Add('DCollapsibleCategory')
            cat:SetLabel(l(cat_name))
            cat:Dock(TOP)
            cat:DockMargin(0, 5, 0, 10)
            local tile = Lists:Tile()
            tile:Dock(FILL)
            cat:SetContents(tile)
            cats[cat_name] = tile
            return tile
        end
    end

    -- Распихиваем инпуты по панелькам
    for option, data in pairs(tblFields) do
        local inpP = GetInputPanel(data.category)
        local inp = inpP:Add(self:Create(option, _, data.inputType, _, data.value))
        self:Resize(inp)
        if data.inputType == 'num' then
            if data.min then inp.editPanel:SetMin(data.min) end
            if data.max then inp.editPanel:SetMax(data.max) end
        end

        inp.option = option
        mainPanel.inputs[option] = inp
    end
    return mainPanel
end
--- @export
return Inputs