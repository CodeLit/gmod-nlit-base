local FindMetaTable = FindMetaTable
local IsValid = IsValid
local tobool = tobool
DarkRP = DarkRP or {}
DarkRP.disabledDefaults = DarkRP.disabledDefaults or {}
DarkRP.disabledDefaults["modules"] = DarkRP.disabledDefaults["modules"] or {}
nlitLoad.WhenGMLoaded('nlit Compatibilities GM', function()
    local ENT = FindMetaTable('Entity')
    if ENT.IsDoor then
        ENT.isDoor = ENT.isDoor or ENT.IsDoor
        function ENT:isKeysOwnable()
            if not IsValid(self) then return end
            if self.IsVehChair and self:IsVehChair() then return false end
            return tobool(self:IsVehicle() or self:IsDoor())
        end
    end

    local PLY = FindMetaTable('Player')
    function PLY:canKeysLock(ent)
        if not ent:isKeysOwnable() or (SERVER and ent:IsDoor() and not ent:CheckDoorAccess(self)) or (ent:IsVehicle() and ent.CPPIGetOwner and ent:CPPIGetOwner() ~= self) then return false end
        return true
    end
end)