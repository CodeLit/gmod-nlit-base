local game = game
if game.SinglePlayer() then
    nlit.Compat.SP = nlit.Compat.SP or {}
    nlit.Compat.SP.NUseNet = 'NSinglePlayer NUse'
    nlit.Compat.SP.ToolsNet = 'NSinglePlayer Tools Fix'
end