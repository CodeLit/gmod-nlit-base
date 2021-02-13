function CWStr:ToJson(arr) return util.TableToJSON(arr) end

function CWStr:FromJson(str) return util.JSONToTable(str) end
