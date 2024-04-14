nlitCfg = nlitCfg or {}
nlitCfg.Name = 'Configurer'
nlitCfg.CheckAccess = function(ply)
    -- Who can access to config?
    return ply:IsSuperAdmin()
end

nlitCfg.NetStr = 'nlitCfg'