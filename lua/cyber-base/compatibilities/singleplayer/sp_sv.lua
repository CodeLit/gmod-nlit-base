if game.SinglePlayer() then

    util.AddNetworkString(NCompat.SP.NUseNet)
    util.AddNetworkString(NCompat.SP.ToolsNet)

    hook.Add('PlayerUse', 'NUse SP Compatibility', function(ply,ent)
        net.Start(NCompat.SP.NUseNet)
        net.WriteEntity(ent)
        net.Send(ply)
    end)

    hook.Add('PlayerButtonDown', 'NSP Tools Fix', function( ply, button )
        if table.HasValue({KEY_R,MOUSE_LEFT,MOUSE_RIGHT}, button) then
            local pkt = GNet.Packet(NCompat.SP.ToolsNet)
            pkt:WriteUInt(button,GNet.CalculateRequiredBits(300))
            pkt:Send()
        end
    end)
end