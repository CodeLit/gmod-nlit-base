local FindMetaTable = FindMetaTable
local IsValid = IsValid
local tobool = tobool
local hook = hook
local timer = timer
local pairs = pairs
local PLY = FindMetaTable('Player')
local strings = nlitStrings
local Lang = nlitLang
function PLY:StID()
    if not IsValid(self) then return end
    return strings:ToSID(self:SteamID())
end

function PLY:CID()
    if not IsValid(self) then return end
    local char = self:GetCharacter()
    if not char then return end
    return char:GetID()
end

function PLY:IsModerator()
    return self:GetRights('Модератор')
end

function PLY:IsDeveloper()
    return self:GetRights('Разработчик')
end

function PLY:IsVehicleDriver()
    if not self:InVehicle() then return false end
    local veh = self:GetVehicle()
    if not IsValid(veh) then return false end
    return not veh.VC_ExtraSeat
end

function PLY:IsShootsFromCarWindow()
    return tobool(self:InVehicle() and not self:IsVehicleDriver() and self:GetNWBool('ShootsFromCarWindow'))
end

hook.Add('KeyPress', 'VC Compatible Shoot From Window', function(ply, key)
    if key == IN_JUMP then
        timer.Simple(.15, function()
            if not IsValid(ply) then return end
            ply:SetNWBool('ShootsFromCarWindow', ply.VC_EnteredDriveByMode)
        end)
    end
end)

function PLY:GetOrderPrice()
    return self:GetInfoNum('nl_order_price', 5000)
end

function PLY:NUse(ent)
    -- 	return NAbils.Killer:OpenRequestMenu()
    -- if IsValid(ent) then
    -- 	if ent:IsPlayer() then
    -- 		if ent:IsKiller() then
    -- 			if ent:HasOrder() then
    -- 				LocalPlayer():Notify('Этот гражданин уже имеет заказ!')
    -- 			else
    -- 				return NAbils.Killer:OpenRequestMenu()
    -- 			end
    -- 		end
    -- 	end
    -- end
end

function PLY:GetClaimedZone()
    for _, v in pairs(RPZones:getList()) do
        if v:getOwnerCID() == self:CID() then return v end
    end
end

---Gets player 2-char lang code
---@return string code
function PLY:GetLang()
    return Lang:Format(self:GetInfo('cw_lang'))
end
-- np(N:GetOwner():IsShootsFromCarWindow())
-- -- ИСКАТЬ В ХУКАХ НУЖНЫЙ ВЫЗОВ ХУКА
--
-- OriginalCall = OriginalCall or hook.Call
--
-- hook.Call = function(eventName,gamemodeTable,args)
-- 	if !table.HasValue({'DrawShield','ShouldPlayerDrowned','DrawOverlay','PreDrawHalos','ShouldBarDraw','PostDrawInventory','ShouldHideBars','ShouldDrawCrosshair','ShouldPopulateEntityInfo','HUDShouldDraw','VC_CD_canRenderInfo','HUDDrawTargetID','HUDDrawPickupHistory','DrawDeathNotice','AdjustBlurAmount','VC_RM_canRenderInfo','VC_CD_CanRenderInfo','CanDrawAmmoHUD'},eventName) then
-- 		np(eventName)
-- 	end
-- 	OriginalCall(eventName,gamemodeTable,args)
-- end