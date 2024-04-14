--- Text is GUI module for text panels
-- @usage local Text = nlitLib:Load('text')
local Text = {}
local vgui = vgui
--- Creates a text label
-- @param text The text to display on the label
-- @return l The created DLabel instance
function Text:Create(text)
    local l = vgui.Create('DLabel')
    l:SetText(text or '')
    l:SetFont('N_small')
    return l
end
--- @export
return Text