local game = game

if game.SinglePlayer() then
    CW.Compat.SP = CW.Compat.SP or {}
    CW.Compat.SP.NUseNet = 'NSinglePlayer NUse'
    CW.Compat.SP.ToolsNet = 'NSinglePlayer Tools Fix'
end