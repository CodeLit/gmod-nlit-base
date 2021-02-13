util.AddNetworkString(NCompat.netStr)

DarkRP.notify = DarkRP.notify or function(ply, ntype, seconds, text, bForce)
    -- Перенаправление на HELIX, если имеется
    if !bForce and ply.Notify then ply:Notify(text) return end
    local pkt = GNet.Packet(NCompat.netStr)
    pkt:WriteUInt(1,GNet.CalculateRequiredBits(100))
    pkt:WriteString(text)
    pkt:WriteUInt(ntype or 0,GNet.CalculateRequiredBits(10))
    pkt:WriteUInt(seconds or 4,GNet.CalculateRequiredBits(50))
    pkt:Send(ply)
end