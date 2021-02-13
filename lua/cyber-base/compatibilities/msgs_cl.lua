DarkRP.notify = DarkRP.notify or function(ply, ntype, seconds, text, bForce)
	-- Перенаправление на HELIX, если имеется
	if !bForce and ply.Notify then ply:Notify(text) return end
	if ply == LocalPlayer() then
		notification.AddLegacy(text, ntype or 0, seconds or 4)
	end
end

GNet.OnPacketReceive(NCompat.netStr, function(pkt)
	local netCmd = pkt:ReadUInt(GNet.CalculateRequiredBits(100))
	
	if netCmd == 1 then -- Notify
		local text = pkt:ReadString()
		local ntype = pkt:ReadUInt(GNet.CalculateRequiredBits(10))
		local seconds = pkt:ReadUInt(GNet.CalculateRequiredBits(50))
		DarkRP.notify(LocalPlayer(),ntype, seconds,text,true)
	end
end)

-- DarkRP.notify(LocalPlayer(),1, 5,'ssss',true)