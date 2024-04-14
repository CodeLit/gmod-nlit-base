local game = game
local util = util
local hook = hook
local net = net
local table = table
local GNet = GNet
if game.SinglePlayer() then
    util.AddNetworkString(nlit.Compat.SP.NUseNet)
    util.AddNetworkString(nlit.Compat.SP.ToolsNet)
    hook.Add('PlayerUse', 'NUse SP Compatibility', function(ply, ent)
        net.Start(nlit.Compat.SP.NUseNet)
        net.WriteEntity(ent)
        net.Send(ply)
    end)

    hook.Add('PlayerButtonDown', 'NSP Tools Fix', function(ply, button)
        if table.HasValue({KEY_R, MOUSE_LEFT, MOUSE_RIGHT}, button) then
            local pkt = GNet.Packet(nlit.Compat.SP.ToolsNet)
            pkt:WriteUInt(button, GNet.CalculateRequiredBits(300))
            pkt:Send()
        end
    end)
end