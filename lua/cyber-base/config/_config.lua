NCfg = NCfg or {}
NCfg.Name = 'Configurer'

NCfg.CheckAccess = function(ply) -- Who can access to config?
    return ply:IsSuperAdmin()
end

NCfg.NetStr = 'NCfg'