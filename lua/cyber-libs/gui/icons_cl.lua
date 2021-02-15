local Icons = {}

local D = CW:Lib('draw')
local Panels = CW:Lib('panels')

---Returns a panel with icon
---@param icon string
---@return panel
function Icons:Create(icon)
	local pnl = Panels:Panel()
	pnl.Paint = function(p,w,h)
		local x,y = p:GetPos()
		D:Icon(self:GetPath(icon), x, y, w, h)
	end
	return pnl
end

---Adds path to icon. Includes materials/icons/
function Icons:GetPath(icon)
	return 'materials/icons/'..icon
end

return Icons