local lang = GetConVar('gmod_language'):GetString()
CreateClientConVar('n_lang',lang,true,true)

cvars.AddChangeCallback('gmod_language', function(cname,oldval,newval)
  RunConsoleCommand('n_lang',newval)
end,'Network My Lang Through The Server')

RunConsoleCommand('n_lang',lang)