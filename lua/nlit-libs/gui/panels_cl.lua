--- Panels is GUI module for panels
-- @module GUIPanels
-- @usage local Panels = NGUI.Panels
local Panels = {}
local vgui = vgui
local draw = draw
local surface = surface
local RunConsoleCommand = RunConsoleCommand
local input = input
local util = util
local ScrW = ScrW
local ScrH = ScrH
local Vector = Vector
local IsValid = IsValid
local string = string
local timer = timer
local NC = NC -- Ensure NC (your theme color handler) is globally accessible or passed appropriately
--- Create a simple panel
-- @param text Optional text to display on the panel
-- @param font Font used for text
-- @return panel The created panel
function Panels:Create(text, font)
    local p = vgui.Create('DPanel')
    p.text = text
    p.Paint = function(pnl)
        if pnl:GetPaintBackground() then
            draw.RoundedBox(0, 0, 0, pnl:GetWide(), pnl:GetTall(), pnl:GetBackgroundColor() or NC:ThemeInside())
            if not p.NoOutline then
                -- Draw the outline of the menu.
                local col = NC:Black()
                surface.SetDrawColor(col.r, col.g, col.b, col.a)
                surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall())
            end
        end

        if pnl.text and font then
            surface.SetFont(font or 'N')
            local w, h = surface.GetTextSize(pnl.text)
            local col = p.textColor or NC:Theme()
            surface.SetTextColor(col.r, col.g, col.b)
            surface.SetTextPos(pnl:GetWide() / 2 - w / 2, pnl:GetTall() / 2 - h / 2)
            surface.DrawText(pnl.text)
        end
    end

    function p:SetText(text)
        p.text = text
    end
    return p
end

--- Create a scrollable panel
-- @return panel A DScrollPanel instance docked to fill its parent
function Panels:DockScroll()
    local scr = vgui.Create('DScrollPanel')
    scr:Dock(FILL)
    return scr
end

--- Attaches panel to the C menu
-- @param pnl Panel to attach
function Panels:AttachToC(pnl)
    pnl:SetParent(g_ContextMenu)
    pnl:SetMouseInputEnabled(true)
    pnl.attachedToCMenu = true
end

--- Creates a panel for binding keys
-- @param command The command to bind to a key
-- @return panel A DBinder panel
function Panels:BinderPanel(command)
    local binder = vgui.Create('DBinder')
    binder:SetSize(200, 50)
    binder:SetPos(25, 35)
    function binder:OnChange(num)
        RunConsoleCommand('bind', input.GetKeyName(num), command)
    end
    return binder
end

--- Creates a panel to display a model's face
-- @param mdl Model path
-- @return panel A DModelPanel configured to focus on the model's face
function Panels:FacePanel(mdl)
    local pnl = vgui.Create('DModelPanel')
    pnl:SetModel(mdl)
    pnl:SetFOV(40)
    function pnl:LayoutEntity(ent)
        local x, y = input.GetCursorPos()
        local vec = util.AimVector(ent:EyeAngles(), pnl:GetFOV(), x, y, ScrW(), ScrH())
        vec.y = -vec.y
        vec.z = vec.z * 2 + 1
        ent:SetEyeTarget(vec * 100)
    end

    local ent = pnl.Entity
    function ent:GetPlayerColor()
        return NC:ThemeInside():ToVector()
    end

    local bone = ent:LookupBone('ValveBiped.Bip01_Head1')
    if bone then
        local eyepos = ent:GetBonePosition(bone)
        eyepos:Add(Vector(-5, 0, 4)) -- Move up slightly
        pnl:SetCamPos(eyepos + Vector(15, 0, 7)) -- Move cam in front of eyes
        pnl:SetLookAt(eyepos)
        ent:SetSequence(ent:LookupSequence('drive_pd'))
    end
    return pnl
end

--- Creates a panel to display a full character model
-- @param mdl Model path
-- @return panel A DModelPanel configured to display the character
function Panels:CharacterPanel(mdl)
    local pnl = vgui.Create('DModelPanel')
    pnl:SetModel(mdl)
    pnl:SetFOV(40)
    function pnl:LayoutEntity(ent)
        local x, y = input.GetCursorPos()
        local vec = util.AimVector(ent:EyeAngles(), pnl:GetFOV(), x, y, ScrW(), ScrH())
        vec.y = -vec.y
        vec.z = vec.z * 2 + 0.5
        ent:SetEyeTarget(vec * 100)
    end

    local ent = pnl.Entity
    function ent:GetPlayerColor()
        return NC:ThemeInside():ToVector()
    end

    local eyepos = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_R_Thigh'))
    eyepos:Add(Vector(-5, 0, 4)) -- Move up slightly
    pnl:SetCamPos(eyepos + Vector(85, -10, 10)) -- Move cam in front of eyes
    pnl:SetLookAt(eyepos + Vector(0, 0, -5))
    return pnl
end

--- Creates a panel to display an item model
-- @param mdl Model path
-- @return panel A DModelPanel configured to display the item
function Panels:ItemPanel(mdl)
    local pnl = vgui.Create('DModelPanel')
    pnl:SetModel(mdl)
    local ent = pnl.Entity
    if not IsValid(ent) then return pnl end
    local radius = ent:GetModelRadius() + 3
    pnl:SetCamPos(Vector(radius, radius, radius * 0.9))
    pnl:SetLookAt(ent:OBBCenter())
    if string.find(mdl, 'weapon') then pnl:SetFOV(50) end
    return pnl
end

-- Надпись с множеством линий
local DMultiline = {}
function DMultiline:GetContentSize()
    surface.SetFont(self:GetFont())
    return surface.GetTextSize(self:GetText())
end

function DMultiline:Init()
    self:SetPaintBackground(false)
    self:SetTextColor(NC:White())
    self:SetMultiline(true)
    timer.Simple(0, function() if IsValid(self) then self:SetEditable(false) end end)
end

vgui.Register('DMultiline', DMultiline, 'DTextEntry')
-- Multiline text panel
function Panels:Multiline(self, text)
    local m = vgui.Create('DMultiline')
    m:SetText(text or '')
    m:SetFont('N_small')
    return m
end
--- @export
return Panels