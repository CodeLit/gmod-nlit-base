local ENT = FindMetaTable('Entity')

function ENT:keysLock()
    if !self:isKeysOwnable() then return end
    self:Fire('Lock')
end

function ENT:keysUnLock()
    if !self:isKeysOwnable() then return end
    self:Fire('UnLock')
end