local pairs = pairs
local player = player
local string = string
local sql = sql
local istable = istable
local Ply = {}

function Ply:GetByNick(nick)
    for _, ply in pairs(player.GetHumans()) do
        if (string.find(string.lower(ply:Nick()), string.lower(nick), 1, true) ~= nil) then return ply end
    end
end

function Ply:GetRPNickName(steamid64)
    local data = sql.Query("SELECT * FROM darkrp_player WHERE uid = '" .. steamid64 .. "';")
    if not data or not istable(data) then return end

    return data[1].rpname
end

return Ply