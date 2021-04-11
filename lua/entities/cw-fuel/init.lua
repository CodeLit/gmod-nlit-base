local include = include
local AddCSLuaFile = AddCSLuaFile
include('shared.lua')
AddCSLuaFile('cl_init.lua')

function ENT:Initialize()
    self:SetModel(self.Model)
    self.FuelAmount = 150
    CWEnts:SetBaseThings(self)
    self:SetHealth(50)
    CWEnts:FixPos(self)
end