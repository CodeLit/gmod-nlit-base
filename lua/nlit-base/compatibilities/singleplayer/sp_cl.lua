local game = game
local net = net
local timer = timer
local GNet = GNet
local LocalPlayer = LocalPlayer
local IsValid = IsValid
if game.SinglePlayer() then
    local cantUse
    net.Receive(nlit.Compat.SP.NUseNet, function()
        if cantUse then return end
        local ent = net.ReadEntity()
        if ent.NUse then
            ent:NUse()
            cantUse = true
            timer.Simple(.3, function() cantUse = nil end)
        end
    end)

    GNet.OnPacketReceive(nlit.Compat.SP.ToolsNet, function(pkt)
        local ply = LocalPlayer()
        local btn = pkt:ReadUInt(GNet.CalculateRequiredBits(300))
        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == 'gmod_tool' then
            local tool = ply:GetTool()
            local tr = ply:GetEyeTrace()
            if btn == MOUSE_LEFT then
                tool:LeftClick(tr)
            elseif btn == MOUSE_RIGHT then
                tool:RightClick(tr)
            elseif btn == KEY_R then
                tool:Reload(tr)
            end
        end
    end)
end