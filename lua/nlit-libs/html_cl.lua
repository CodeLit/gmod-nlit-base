local vgui = vgui
local HTML = {}
local Text = nlitLib:Lib('text')
local l = nlitLang
function HTML:MakeInPanel(panel)
    local html = vgui.Create('DHTML', panel)
    html:Dock(FILL)
    html:SetAllowLua(true)
    html:InvalidateLayout(true)
    local loading = html:Add(Text:Create(l('Загрузка...')))
    loading:SetFont('N_s')
    loading:SizeToContents()
    loading:SetPos(html:GetWide() / 2, html:GetTall() / 2)
    html.Think = function() loading:SetVisible(html:IsLoading()) end
    local ctrls = vgui.Create('DHTMLControls', panel)
    ctrls:Dock(TOP)
    ctrls:SetHTML(html)
    return html
end
return HTML