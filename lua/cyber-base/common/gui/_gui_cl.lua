CWGUI = CWGUI or {}

function CWGUI:Label(text)
	local l = vgui.Create('DLabel')
	l:SetText(text or '')
	l:SetFont('N_small')

	return l
end

function CWGUI:Menu()
	local menu = DermaMenu()
	menu:SetPos(input.GetCursorPos())

	timer.Simple(0, function()
		CWGUI:UpdateMenuPos(menu)
	end)

	menu:MakePopup()

	return menu
end

function CWGUI:UpdateMenuPos(menu)
	local x, y = input.GetCursorPos()
	local overScreen

	if x + menu:GetWide() > ScrW() then
		x = ScrW() - menu:GetWide()
		overScreen = true
	end

	if y + menu:GetTall() > ScrH() then
		y = ScrH() - menu:GetTall()
		overScreen = true
	end

	if overScreen then
		menu:SetPos(x, y)
	end
end