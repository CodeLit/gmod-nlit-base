--- Menus is GUI module for menu panels
-- @usage local Menus = nlitLib:Load('menus')
local Menus = {}
local DermaMenu = DermaMenu
local input = input
local timer = timer
local ScrW = ScrW
local ScrH = ScrH
--- Creates a new menu panel at the cursor position
-- @return menu Newly created DermaMenu panel
function Menus:Menu()
    local menu = DermaMenu()
    menu:SetPos(input.GetCursorPos())
    timer.Simple(0, function() if self then self:UpdateMenuPos(menu) end end)
    menu:MakePopup()
    return menu
end

--- Updates the position of a menu to ensure it doesn't go off the screen
-- @param menu The menu whose position should be adjusted
function Menus:UpdateMenuPos(menu)
    local x, y = input.GetCursorPos()
    local overScreen = false
    if x + menu:GetWide() > ScrW() then
        x = ScrW() - menu:GetWide()
        overScreen = true
    end

    if y + menu:GetTall() > ScrH() then
        y = ScrH() - menu:GetTall()
        overScreen = true
    end

    if overScreen then menu:SetPos(x, y) end
end
--- @export
return Menus