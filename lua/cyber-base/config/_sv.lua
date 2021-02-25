---Addons Configurator global module
---@module CWCfg
---@usage CWCfg:AddAddon('My Addon')
---CWCfg:Set('My Addon','Print Hello',true,'bool',{category='Basic'})
CWCfg.ConnectedAddons = CWCfg.ConnectedAddons or {}

local DB = CW:Lib('db')
local CWStr = CW:Lib('strings')

util.AddNetworkString(CWCfg.NetStr)

DB:SetTableName('CWConfig')

DB:CreateDataTable('addon')

---Is addon connected. Shared function
---@param addonName string
---@return bool
function CWCfg:IsAddonConnected(addonName)
    return tobool(self.ConnectedAddons[addonName])
end

---Adds addon to configurator. Server function
---@param addonName string
function CWCfg:AddAddon(addonName)
    DB:InsertOrIgnore({addon=addonName})
    if !self:IsAddonConnected(addonName) then
        self.ConnectedAddons[addonName] = {}
    end
end

---Sends addon data to the client. Server function
---@param addonName string
---@param ply player client
function CWCfg:SendAddon(addonName,ply)
    if !self:IsAddonConnected(addonName) then return end
    local data = DB:GetDataWhere({addon=addonName})
    -- Убираем для клиента лишние конфиги из базы данных
    data = CWStr:FromJson(data)
    for k,_ in pairs(data or {}) do
        local addonTbl = self.ConnectedAddons[addonName]
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

---Adds configurable input field to addon, according to Inputs:Fields function.
---Server function.
---Addon must be once added to configurer with AddAddon function.
---@param addonName string name of the addon
---@param key string configurable option name
---@param value string default value
---@param inputType string type of input, see Inputs:Create
---@param inpData table additional data, like {category='Custom Category'}
---@see AddAddon
---@see Inputs:Fields
function CWCfg:Set(addonName,key,value,inputType,inpData)
    local oldData = DB:GetDataWhere({addon=addonName})
    if oldData=='NULL' then oldData = {}
    else oldData = CWStr:FromJson(oldData) end
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
    DB:InsertOrReplace({
        addon=addonName,
        data=CWStr:ToJson(oldData)
    })
    self.ConnectedAddons[addonName][key] = oldData[key]
    self:SendAddon(addonName)
end

---Returns data of the addon's field. Shared function
---@param addonName string
---@param key string filed name
function CWCfg:Get(addonName,key)
    local oldData = CWStr:FromJson(DB:GetDataWhere({addon=addonName}))
    local val = oldData[key].value
    if oldData[key].inputType == 'bool' then
        return tobool(val)
    end
    return val
end

---Removes field of the addon from database. Server function
---@param addonName string
---@param key string filed name
function CWCfg:Remove(addonName,key)
    local oldData = CWStr:FromJson(DB:GetDataWhere({addon=addonName}))
    oldData[key] = nil
    DB:InsertOrReplace({
        addon=addonName,
        data=CWStr:ToJson(oldData)
    })
end

---Removes addon from database. Server function
---@param addonName string
function CWCfg:RemoveAddon(addonName)
    DB:DeleteWhere({addon=addonName})
end

GNet.OnPacketReceive(CWCfg.NetStr, function(pkt)
    local netCmd = pkt:ReadUInt(GNet.CalculateRequiredBits(100))
    if netCmd == 1 and CWCfg.CheckAccess(pkt.ply) then -- set cfg data
        local selectedAddon = pkt:ReadString()
        local data = pkt:ReadString()
        data = CWStr:FromJson(data)
        for key,value in pairs(data) do
            CWCfg:Set(selectedAddon,key,value,_,{force=true})
        end
    end
end)

hook.Add('PlayerInitialSpawn', 'CWCfg Start Sending', function(ply)
    for _,v in pairs(DB:Get()) do
        CWCfg:SendAddon(v.addon,ply)
    end
end)