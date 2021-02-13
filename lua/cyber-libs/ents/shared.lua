local CWEnts = {}

function CWEnts:Hide(ent)
    -- :SetNoDraw(true) -- блять, аккуратно, это убирает нетворкинг для клиентов
	ent:SetMaterial('Models/effects/vol_light001')
	ent:SetColor(Color(0,0,0,0))
end

function CWEnts:Show(ent)
    -- :SetNoDraw(false) -- блять, аккуратно, это добавляет нетворкинг для клиентов
	ent:SetMaterial('')
	ent:SetColor(Color(0,0,0,0))
end

function CWEnts:SetVisibility(ent,bool)
	if bool then
		self:Show(ent)
	else
		self:Hide(ent)
	end
end

function CWEnts:IsStuckingPly(ent,intAddSpace)
	intAddSpace = intAddSpace or 0
	local addVector = Vector(intAddSpace,intAddSpace,intAddSpace)
	local eMins, eMaxs = ent:GetModelBounds()
	eMins = ent:LocalToWorld(eMins-addVector)
	eMaxs = ent:LocalToWorld(eMaxs+addVector)
	for _, v in pairs(ents.FindInBox(eMins, eMaxs)) do
		if v:IsPlayer() then
			return true
		end
	end
	return false
end

return CWEnts