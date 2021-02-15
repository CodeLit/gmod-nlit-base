---Vectors module
---@module Vectors
local Vectors = {}

---Gets Center Between Points
---@param vec1 vector 1
---@param vec2 vector 2
---@return vector center between
function Vectors:GetCenterBetweenPoints(vec1,vec2)
	local v1,v2,v3,v4,v5,v6 = vec1.x,vec1.y,vec1.z,vec2.x,vec2.y,vec2.z
	local diffX = math.max(v1,v4)-math.min(v1,v4)
	local diffY = math.max(v2,v5)-math.min(v2,v5)
	local diffZ = math.max(v3,v6)-math.min(v3,v6)
	diffX = diffX/2 diffY = diffY/2 diffZ = diffZ/2
	return Vector(math.min(v1,v4)+diffX,math.min(v2,v5)+diffY,math.min(v3,v6)+diffZ)
end

return Vectors
