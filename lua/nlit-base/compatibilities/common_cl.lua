local GetConVar = GetConVar
local CreateClientConVar = CreateClientConVar
local cvars = cvars
local RunConsoleCommand = RunConsoleCommand
local lang = GetConVar('gmod_language'):GetString()
CreateClientConVar('nlit_lang', lang, true, true)
cvars.AddChangeCallback('gmod_language', function(cname, oldval, newval) RunConsoleCommand('nlit_lang', newval) end, 'Network My Lang Through The Server')
RunConsoleCommand('nlit_lang', lang)