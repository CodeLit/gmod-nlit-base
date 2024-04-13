local Icons = {}
local D = nlitLib:Lib('draw')
local Panels = NGUI.Panels
---Returns a panel with icon
---@param icon string
---@return panel
function Icons:Create(icon)
	local pnl = Panels:Panel()
	pnl.Paint = function(p, w, h)
		local x, y = p:GetPos()
		D:Icon(self:GetPath(icon), x, y, w, h)
	end
	return pnl
end

---Adds path to icon. Includes materials/icons/
function Icons:GetPath(icon)
	return 'materials/icons/' .. icon
end
return Icons