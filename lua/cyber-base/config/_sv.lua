NCfg.ConnectedAddons = NCfg.ConnectedAddons or {}

local NDB = CW:UseLib('db')

util.AddNetworkString(NCfg.NetStr)

NDB:SetTableName('ENLConfig')

NDB:CreateDataTable('addon')

function NCfg:IsAddonConnected(addonName)
    return tobool(NCfg.ConnectedAddons[addonName])
end

function NCfg:AddAddon(addonName)
    NDB:InsertOrIgnore({addon=IQ(addonName)})
    if !self:IsAddonConnected(addonName) then
        NCfg.ConnectedAddons[addonName] = {}
    end
end

function NCfg:SendAddon(addonName,ply)
    if !self:IsAddonConnected(addonName) then return end
    local data = NDB:GetDataWhere('addon='..IQ(addonName)).data

    -- Убираем для клиента лишние конфиги из базы данных
    data = CWStr:FromJson(data)
    for k,_ in pairs(data) do
        local addonTbl = NCfg.ConnectedAddons[addonName]
        if addonTbl and !addonTbl[k] then
            data[k] = nil
        end
    end
    data = CWStr:ToJson(data)

    local pkt = GNet.Packet(self.NetStr)
    pkt:WriteUInt(1,GNet.CalculateRequiredBits(100))
    pkt:WriteString(addonName)
    pkt:WriteString(data)
    pkt:Send(ply)
end

function NCfg:Set(addonName,key,value,inputType,inpData)
    local oldData = NDB:GetDataWhere('addon='..IQ(addonName)).data
    if oldData=='NULL' then oldData = {} else oldData = CWStr:FromJson(oldData) end
    oldData[key] = oldData[key] or {}
    oldData[key].default = value
    inpData = inpData or {}
    if inpData.force then
        inpData.force = nil
        oldData[key].value = value
    else
        oldData[key].value = oldData[key].value or value
    end
    for k,v in pairs(inpData) do
        oldData[key][k] = v
    end
    oldData[key].inputType = oldData[key].inputType or inputType
    NDB:InsertOrReplace({
        addon=IQ(addonName),
        data=IQ(CWStr:ToJson(oldData))
    })
    NCfg.ConnectedAddons[addonName][key] = oldData[key]
    NCfg:SendAddon(addonName)
end

function NCfg:Get(addonName,key)
    local oldData = CWStr:FromJson(NDB:GetDataWhere('addon='..IQ(addonName)).data)
    local val = oldData[key].value
    if oldData[key].inputType == 'bool' then
        return tobool(val)
    end
    return val
end

function NCfg:Remove(addonName,key)
    local oldData = CWStr:FromJson(NDB:GetDataWhere('addon='..IQ(addonName)))
    oldData[key] = nil
    NDB:InsertOrReplace({
        addon=IQ(addonName),
        data=CWStr:ToJson(oldData)
    })
end

function NCfg:RemoveAddon(addonName)
    NDB:DeleteWhere('addon='..IQ(addonName))
end

GNet.OnPacketReceive(NCfg.NetStr, function(pkt)
    local netCmd = pkt:ReadUInt(GNet.CalculateRequiredBits(100))
    if netCmd == 1 and NCfg.CheckAccess(pkt.ply) then -- set cfg data
        local selectedAddon = pkt:ReadString()
        local data = pkt:ReadString()
        data = CWStr:FromJson(data)
        for key,value in pairs(data) do
            NCfg:Set(selectedAddon,key,value,_,{force=true})
        end
    end
end)

hook.Add('PlayerInitialSpawn', 'NE Cfg Start Send', function(ply)
    for _,v in pairs(NDB:Get()) do
        NCfg:SendAddon(v.addon,ply)
    end
end)