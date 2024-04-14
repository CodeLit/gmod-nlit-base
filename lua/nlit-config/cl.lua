local PrintError = PrintError
local tobool = tobool
local GNet = GNet
local pairs = pairs
nlitCfg.svTable = nlitCfg.svTable or {}
local strings = nlitString
function nlitCfg:Get(addon, key)
    local tbl = self.svTable[addon]
    if not tbl then
        PrintError('Нет такого аддона [' .. addon .. ']')
        return
    end

    if not tbl[key] then
        PrintError('Нет такого поля [' .. key .. '] у аддона [' .. addon .. ']')
        return
    end

    local val = tbl[key].value
    if tbl[key].inputType == 'bool' then return tobool(val) end
    return val
end

GNet.OnPacketReceive(nlitCfg.NetStr, function(pkt)
    local netType = pkt:ReadUInt(GNet.CalculateRequiredBits(100))
    if netType == 1 then
        local addonName = pkt:ReadString()
        nlitCfg.svTable[addonName] = nlitCfg.svTable[addonName] or {}
        local data = strings:FromJson(pkt:ReadString())
        for k, v in pairs(data or {}) do
            nlitCfg.svTable[addonName][k] = v
        end
    end
end)