NCfg.svTable = NCfg.svTable or {}

local CWStr = CW:Lib('string')

function NCfg:Get(addon,key)
    local tbl = self.svTable[addon]
    if !tbl then
        PrintError('Нет такого аддона ['..addon..']')
        return
    end
    if !tbl[key] then
        PrintError('Нет такого поля ['..key..'] у аддона ['..addon..']')
        return
    end
    local val = tbl[key].value
    if tbl[key].inputType == 'bool' then
        return tobool(val)
    end
    return val
end

GNet.OnPacketReceive(NCfg.NetStr, function(pkt)
    local netType = pkt:ReadUInt(GNet.CalculateRequiredBits(100))
    if netType == 1 then
        local addonName = pkt:ReadString()
        NCfg.svTable[addonName] = NCfg.svTable[addonName] or {}
        local data = CWStr:FromJson(pkt:ReadString())
        for k,v in pairs(data or {}) do
            NCfg.svTable[addonName][k] = v
        end
    end
end)