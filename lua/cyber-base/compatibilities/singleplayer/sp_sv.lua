if game.SinglePlayer() then

    util.AddNetworkString(CW.Compat.SP.NUseNet)
    util.AddNetworkString(CW.Compat.SP.ToolsNet)

    hook.Add('PlayerUse', 'NUse SP Compatibility', function(ply,ent)
        net.Start(CW.Compat.SP.NUseNet)
        net.WriteEntity(ent)
        net.Send(ply)
    end)

    hook.Add('PlayerButtonDown', 'NSP Tools Fix', function( ply, button )
        if table.HasValue({KEY_R,MOUSE_LEFT,MOUSE_RIGHT}, button) then
            local pkt = GNet.Packet(CW.Compat.SP.ToolsNet)
            pkt:WriteUInt(button,GNet.CalculateRequiredBits(300))
            pkt:Send()
        end
    end)
end