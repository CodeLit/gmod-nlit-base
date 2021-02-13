function CWGUI:IconPath(path)
	return 'materials/icons/'..path
end

function CWGUI:Icon(path)

	local D = CW:UseLib('draw')

	local icon = self:Panel()

	icon.Paint = function(pnl,w,h)
		local x,y = pnl:GetPos()
		D:Icon(CWGUI:IconPath(path), x, y, w, h)
	end

	return icon
end
