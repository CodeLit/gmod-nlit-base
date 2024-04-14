--- @module nlitIcons
-- @usage local Icons = nlitIcons
module('nlitIcons', package.seeall)
local D = nlitLib:Load('draw')
local Panels = nlitPanels
--- Returns a panel with icon
-- @param icon string
-- @return panel
function Create(self, icon)
	local pnl = Panels:Panel()
	pnl.Paint = function(p, w, h)
		local x, y = p:GetPos()
		D:Icon(self:GetPath(icon), x, y, w, h)
	end
	return pnl
end

--- Adds path to icon. Includes materials/icons/
function GetPath(self, icon)
	return 'materials/icons/' .. icon
end