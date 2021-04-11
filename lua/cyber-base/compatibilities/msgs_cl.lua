local LocalPlayer = LocalPlayer
local notification = notification
local GNet = GNet
local DarkRP = DarkRP

DarkRP.notify = DarkRP.notify or function(ply, ntype, seconds, text, bForce)
    -- Перенаправление на HELIX, если имеется
    if not bForce and ply.Notify then
        ply:Notify(text)

        return
    end

    if ply == LocalPlayer() then
        notification.AddLegacy(text, ntype or 0, seconds or 4)
    end
end

GNet.OnPacketReceive(CW.Compat.netStr, function(pkt)
    local netCmd = pkt:ReadUInt(GNet.CalculateRequiredBits(100))

    -- Notify
    if netCmd == 1 then
        local text = pkt:ReadString()
        local ntype = pkt:ReadUInt(GNet.CalculateRequiredBits(10))
        local seconds = pkt:ReadUInt(GNet.CalculateRequiredBits(50))
        DarkRP.notify(LocalPlayer(), ntype, seconds, text, true)
    end
end)
-- DarkRP.notify(LocalPlayer(),1, 5,'ssss',true)