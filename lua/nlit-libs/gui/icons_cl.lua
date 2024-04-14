--- This module provides functions to create and manage icons within GUI panels.
-- @usage local Icons = nlitLib:Load('icons')
local Icons = {}
local D = nlitLib:Load('draw')
local Panels = nlitLib:Load('panels')
--- Returns a panel with an icon displayed.
-- @param icon string The filename of the icon to display.
-- @return panel The panel with the icon painted on it.
function Icons:Create(icon)
	local pnl = Panels:Panel()
	pnl.Paint = function(p, w, h)
		local x, y = p:GetPos()
		D:Icon(self:GetPath(icon), x, y, w, h)
	end
	return pnl
end

--- Constructs the full path to an icon file.
-- This function assumes all icons are stored in the 'materials/icons/' directory.
-- @param icon string The filename of the icon.
-- @return string The full path to the icon.
function Icons:GetPath(icon)
	return 'materials/icons/' .. icon
end
--- @export
return Icons