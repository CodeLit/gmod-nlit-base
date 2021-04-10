CWCfg = CWCfg or {}
CWCfg.Name = 'Configurer'

CWCfg.CheckAccess = function(ply) -- Who can access to config?
    return ply:IsSuperAdmin()
end

CWCfg.NetStr = 'CWCfg'