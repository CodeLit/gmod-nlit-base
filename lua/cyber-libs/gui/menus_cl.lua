local Menus = {}

function Menus:Menu()
	local menu = DermaMenu()
	menu:SetPos(input.GetCursorPos())

	timer.Simple(0, function()
		if self then
			self:UpdateMenuPos(menu)
		end
	end)

	menu:MakePopup()

	return menu
end

function Menus:UpdateMenuPos(menu)
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

return Menus