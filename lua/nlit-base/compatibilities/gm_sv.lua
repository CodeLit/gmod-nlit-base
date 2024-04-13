local FindMetaTable = FindMetaTable
local ENT = FindMetaTable('Entity')

function ENT:keysLock()
    if not self:isKeysOwnable() then return end
    self:Fire('Lock')
end

function ENT:keysUnLock()
    if not self:isKeysOwnable() then return end
    self:Fire('UnLock')
end