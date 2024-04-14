--- Creates GUI Buttons
-- @module nlitButtons
-- @usage local Buttons = nlitLib:Load('buttons')
local Buttons = {}
local TDLib = TDLib
local Color = Color
local list = list
local vgui = vgui
local IsValid = IsValid
local GetConVar = GetConVar
local math = math
local hook = hook
local table = table
local RunConsoleCommand = RunConsoleCommand
local D = nlitLib:Load('draw')
local Icons = nlitIcons
local l = nlitLang.l
--- Creates a button
---@param text string Button text
---@param clickFunc function OnClick function
--- @usage Create('Accept',function(btn)
--      -- OnClick function
--		btn:SetColor(NC:Red())
-- end)
function Create(self, text, clickFunc)
    local b = TDLib('DButton')
    b:SetText(l(text) or '')
    b:SetFont('N_small')
    b:SetColor(NC:ThemeText())
    b:ClearPaint()
    b:Background(NC:Theme())
    b:CircleHover(NC:White(NC:IsLightTheme() and 30 or 20), 7, 130)
    b:Gradient(NC:ThemeInside(true), TOP)
    local bh = NC:ThemeText()
    bh.a = 90
    b:BarHover(bh)
    function b:SetBackgroundColor(color)
        b:Background(color)
    end

    b:On('Paint', function(pnl, w, h)
        if pnl.RightIcon then
            local iconSizeMul = 0.8
            local iconSize = h * iconSizeMul
            local iconMargin = h * (1 - iconSizeMul)
            D:Icon(Icons:GetPath(pnl.RightIcon), w - iconSize - iconMargin / 2, iconMargin / 2, iconSize, iconSize)
        end
    end)

    b.DoClick = clickFunc
    return b
end

--- Accept button green colored
--- @see Create
function Accept(self, text, clickFunc)
    local b = self:Create(text or 'Подтвердить', clickFunc)
    b:SetTextColor(NC:White())
    b:Background(Color(0, 190, 0, 220))
    return b
end

--- Decline button red colored
--- @see Create
function Decline(self, text, clickFunc)
    local b = self:Create(text or 'Отменить', clickFunc)
    b:SetTextColor(NC:White())
    b:Background(Color(190, 0, 0, 220))
    return b
end

---Adds button to C button menu
---@param title string
---@param icon string
---@param iconSize number
---@param func function
function AddToCMenu(self, title, icon, iconSize, func)
    list.Set('DesktopWindows', 'NContext Button ' .. title, {
        title = title,
        icon = icon,
        width = iconSize,
        height = iconSize,
        onewindow = true,
        init = function(ico, window)
            window:SetIcon(icon)
            nlitFrames:AddBehavior(window)
            func(window)
        end,
    })
end

---Specific HUD Settings button
function HudSettings(self)
    local button = vgui.Create('DImageButton')
    button:SetSize(16, 16)
    button:SetImage('icon16/wrench.png')
    button.elements = button.elements or {} -- чтобы можно было удалить с помощью цикла
    button.DoClick = function(pnl)
        if IsValid(button.panel) then
            button.panel:Remove()
            return
        end

        local btnPanel = Panel()
        btnPanel:SetSize(200, 200)
        local mixer = btnPanel:Add('DColorMixer')
        mixer:SetPalette(false)
        mixer:SetWangs(false)
        mixer:SetConVarA('nhudbg_a')
        mixer:SetConVarR('nhudbg_r')
        mixer:SetConVarG('nhudbg_g')
        mixer:SetConVarB('nhudbg_b')
        mixer:Dock(FILL)
        local sizer = btnPanel:Add('DNumSlider')
        sizer.Scratch:Hide()
        sizer.TextArea:Hide()
        sizer:SetText(l('Шрифт'))
        sizer:Dock(TOP)
        sizer:SetConVar('nhud_size')
        sizer:SetMin(30)
        sizer:SetMax(60)
        sizer:SetDecimals(0)
        sizer:DockPadding(7, 0, 0, 0)
        sizer:SetValue(GetConVar('nhud_size'):GetInt())
        sizer.OnValueChanged = function(pnl, val)
            val = math.Round(val)
            if sizer.oldVal ~= val then
                sizer.oldVal = val
                hook.Add('PlayerButtonUp', 'NHUD Sizer', function(ply, key)
                    if not table.HasValue({MOUSE_LEFT, MOUSE_RIGHT}, key) then return end
                    NHUD:FontsUpdate()
                    hook.Remove('PlayerButtonUp', 'NHUD Sizer')
                end)
            end

            RunConsoleCommand('nhudbg_helix_color', 0)
            btnPanel:UpdatePos()
        end

        button.panel = btnPanel
        function btnPanel:UpdatePos()
            local posX, posY = button:GetPos()
            if pnl.attachedToCMenu then posY = posY - btnPanel:GetTall() - 3 end
            btnPanel:SetPos(posX, posY)
        end

        btnPanel:UpdatePos()
        if pnl.attachedToCMenu and IsValid(button.panel) then button.panel:SetParent(g_ContextMenu) end
    end
    return button
end