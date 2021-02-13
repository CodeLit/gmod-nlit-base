local files = {}

function files:curLuaFilePath()
  return debug.getinfo(2,'S').source:sub(2):match('(.*/)')
end

return files
