local PLY = FindMetaTable('Player')

PLY.Notify = PLY.Notify or function(ply,text,notType,time)
	DarkRP.notify(ply, notType, time, text, true)
end