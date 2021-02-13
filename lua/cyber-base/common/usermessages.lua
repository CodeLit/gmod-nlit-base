local meta = FindMetaTable('Player')

local netStrMessage = 'N Colored Message'
local notifyStr = 'N Notification'

if SERVER then

	util.AddNetworkString(netStrMessage)
	util.AddNetworkString(notifyStr)

	function meta:PlayerMessage(...)
		if !IsValid(self) then return end
		local args = {...}
		net.Start(netStrMessage)
		net.WriteTable(args)
		net.Send(self)
	end

	function meta:NotifyProtected(message,type,seconds)
		if !IsValid(self) or self.Notified then return end
		self:Notify(message,type,seconds)
		self.Notified = true
		timer.Simple(0.3,function() self.Notified = nil end)
	end

	function CW:BroadcastMsg(...)
		local args = {...}
		net.Start(netStrMessage)
		net.WriteTable(args)
		net.Broadcast()
	end

	function CW:NotifyAll(message,type,seconds,funcWillBeNotified)
		net.Start(notifyStr)
		net.WriteTable({t=message,n=type,s=seconds})
		if isfunction(funcNotNotifyThis) then
			for _,ply in pairs(player.GetAll()) do if !funcWillBeNotified(ply) then net.SendOmit(ply) end end
		end
		net.Broadcast()
	end
	
elseif CLIENT then

	function meta:PlayerMessage(...)
		chat.AddText(...)
		chat.PlaySound()
	end

	net.Receive(netStrMessage,function()
		local msg = net.ReadTable()
		LocalPlayer():PlayerMessage(unpack(msg))
	end)

end
