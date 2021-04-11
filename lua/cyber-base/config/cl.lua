local PrintError = PrintError
local tobool = tobool
local GNet = GNet
local pairs = pairs
CWCfg.svTable = CWCfg.svTable or {}
local CWStr = CW:Lib('string')

function CWCfg:Get(addon, key)
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

GNet.OnPacketReceive(CWCfg.NetStr, function(pkt)
    local netType = pkt:ReadUInt(GNet.CalculateRequiredBits(100))

    if netType == 1 then
        local addonName = pkt:ReadString()
        CWCfg.svTable[addonName] = CWCfg.svTable[addonName] or {}
        local data = CWStr:FromJson(pkt:ReadString())

        for k, v in pairs(data or {}) do
            CWCfg.svTable[addonName][k] = v
        end
    end
end)