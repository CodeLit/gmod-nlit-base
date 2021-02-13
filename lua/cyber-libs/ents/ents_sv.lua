local CWEnts = include('shared.lua')

function CWEnts:GetEntID(ent)
	return ent:GetCreationID()
end

function CWEnts:CreateInsteadOf(class,otherEnt)
	if !IsValid(otherEnt) then return end
	local cr = ents.Create(class)
	cr:SetPos(otherEnt:GetPos())
	cr:SetAngles(otherEnt:GetAngles())
	otherEnt:Remove()
	cr:Spawn()
	return cr
end

function CWEnts:CreateBeforePlayer(ply,class)
	local ent = ents.Create(class)
	ent:SetPos(util.QuickTrace(ply:EyePos(),ply:GetForward() * 70,ply).HitPos)
	ent:SetAngles(ply:LocalToWorldAngles(Angle(0,180,0)))
	ent:Spawn()
	return ent
end

function CWEnts:TakeDamage(ent,dmg)
	local owner = ent:GetNWEntity('Owner')

	if RPZones then
		local propZone = RPZones:GetEntZone(ent)

		if propZone and IsValid(owner) and owner:CID() == propZone:getOwnerCID() then
			return
		end
	end
	ent:SetHealth(ent:Health() - dmg)
	if ent.HealthToColor then
		self:UpdateHealthColor(ent)
	end
	if ent:Health() <= 0 then
		if ent.DoBeforeExplosion then
			ent:DoBeforeExplosion()
		end
		local effectdata = EffectData()
		effectdata:SetOrigin(ent:GetPos())
		util.Effect('Explosion',effectdata,true,true)
		ent:Remove()
		if ent.DoAfterExplosion then
			ent:DoAfterExplosion()
		end
	end
end

function CWEnts:MakeExplosionable(ent)
	function ent:OnTakeDamage(dinf)
		CWEnts:TakeDamage(ent,dinf:GetDamage())
	end
end

function CWEnts:MakePropDestructible(prop)
	local eMins,eMaxs = prop:GetModelBounds()
	local size = eMaxs-eMins
	commonSize = (size.x + size.y + size.z) / 5
	commonSize = commonSize * commonSize
	commonSize = commonSize - commonSize % 10
	prop:SetHealth(commonSize)
	prop:SetMaxHealth(commonSize)
	prop:SetVar('Unbreakable',true)
	prop.HealthToColor = true
	prop.Destructible = true
end

function CWEnts:UpdateHealthColor(ent)
	local healthToColor = ent:Health() / ent:GetMaxHealth() * 255
	ent:SetColor(Color(255,healthToColor,healthToColor))
end

function CWEnts:SetBaseHealth(ent)
	local health = 300
	ent:SetHealth(health)
	ent:SetMaxHealth(health)
end

function CWEnts:SetBasePhysics(ent)
	ent:PhysicsInit(SOLID_VPHYSICS)
	ent:SetMoveType(MOVETYPE_VPHYSICS)
	ent:SetSolid(SOLID_VPHYSICS)
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
end

function CWEnts:SetBaseThings(ent)
	CWEnts:SetBaseHealth(ent)
	CWEnts:SetBasePhysics(ent)
	CWEnts:MakeExplosionable(ent)

	ent:SetUseType(SIMPLE_USE)
end

function CWEnts:MakeCableConnector()
	local plug = ents.Create('prop_physics')
	plug:SetModel('models/props_lab/tpplug.mdl')
	plug:SetColor(Color(72, 72, 72))
	plug:SetModelScale(0.4)
	plug:Spawn()
	plug:SetNWBool('IsPlug',true)
	plug:CallOnRemove('Remove Connected Device', function()
		if IsValid(plug:GetNWEntity('PlugDevice')) then
			plug:GetNWEntity('PlugDevice'):Remove()
		end
	end)
	return plug
end

function CWEnts:CableConnectEnts(ent1,ent2,lVector1,lVector2,lenMul)
	return constraint.Rope(ent1,ent2,0,0,lVector1,lVector2,50*lenMul,100*lenMul,0,1.5,'cable/cable2',false)
end

function CWEnts:FixPos(ent)
	ent:SetPos(ent:LocalToWorld(Vector(0, 0, ent:GetModelRadius()+5)))
	ent:DropToFloor()
end

function CWEnts:DisablePhysics(ent)
	local entPhys = ent:GetPhysicsObject()
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ent:SetMoveType(MOVETYPE_NONE)
	entPhys:EnableMotion(false)
	ent:PhysicsDestroy()
end

function CWEnts:DisableMovement(ent)
	ent:SetMoveType(MOVETYPE_NONE)
end

function CWEnts:GetOwner(ent)
	return ent.PlyOwner
end

function CWEnts:SetOwner(ent,owner)
	ent.PlyOwner = owner
end

return CWEnts