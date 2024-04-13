local FindMetaTable = FindMetaTable
local util = util
local IsValid = IsValid
local net = net
local timer = timer
local isfunction = isfunction
local pairs = pairs
local player = player
local chat = chat
local LocalPlayer = LocalPlayer
local unpack = unpack
local meta = FindMetaTable('Player')
local netStrMessage = 'N Colored Message'
local notifyStr = 'N Notification'
if SERVER then
    util.AddNetworkString(netStrMessage)
    util.AddNetworkString(notifyStr)
    function meta:PlayerMessage(...)
        if not IsValid(self) then return end
        local args = {...}
        net.Start(netStrMessage)
        net.WriteTable(args)
        net.Send(self)
    end

    function meta:NotifyProtected(message, type, seconds)
        if not IsValid(self) or self.Notified then return end
        self:Notify(message, type, seconds)
        self.Notified = true
        timer.Simple(0.3, function() self.Notified = nil end)
    end

    function nlit:BroadcastMsg(...)
        local args = {...}
        net.Start(netStrMessage)
        net.WriteTable(args)
        net.Broadcast()
    end

    function nlit:NotifyAll(message, type, seconds, funcWillBeNotified)
        net.Start(notifyStr)
        net.WriteTable({
            t = message,
            n = type,
            s = seconds
        })

        if isfunction(funcNotNotifyThis) then
            for _, ply in pairs(player.GetAll()) do
                if not funcWillBeNotified(ply) then net.SendOmit(ply) end
            end
        end

        net.Broadcast()
    end
elseif CLIENT then
    function meta:PlayerMessage(...)
        chat.AddText(...)
        chat.PlaySound()
    end

    net.Receive(netStrMessage, function()
        local msg = net.ReadTable()
        LocalPlayer():PlayerMessage(unpack(msg))
    end)
end