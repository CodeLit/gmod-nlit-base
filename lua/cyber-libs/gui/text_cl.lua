local vgui = vgui
local Text = {}

function Text:Create(text)
    local l = vgui.Create('DLabel')
    l:SetText(text or '')
    l:SetFont('N_small')

    return l
end

return Text