--- Text is GUI module for text panels
---@module nlitText
module('nlitText', package.seeall)
local vgui = vgui
function Create(self, text)
    local l = vgui.Create('DLabel')
    l:SetText(text or '')
    l:SetFont('N_small')
    return l
end