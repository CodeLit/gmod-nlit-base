DarkRP = DarkRP or {}
DarkRP.disabledDefaults = DarkRP.disabledDefaults or {}
DarkRP.disabledDefaults["modules"] = DarkRP.disabledDefaults["modules"] or {}

WhenGMLoaded('NCompatibilities GM',function()
    local ENT = FindMetaTable('Entity')

    if ENT.IsDoor then
        ENT.isDoor = ENT.isDoor or ENT.IsDoor

        function ENT:isKeysOwnable()
            if !IsValid(self) then return end
            if self.IsVehChair and self:IsVehChair() then
                return false
            end
            return tobool(self:IsVehicle() or self:IsDoor())
        end
    end

    local PLY = FindMetaTable('Player')

    function PLY:canKeysLock(ent)
        if !ent:isKeysOwnable() or 
            (SERVER and ent:IsDoor() and !ent:CheckDoorAccess(self)) or
            (ent:IsVehicle() and ent.CPPIGetOwner and ent:CPPIGetOwner() != self) then
            return false
        end

        return true
    end
end)