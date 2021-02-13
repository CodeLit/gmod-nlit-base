CW.Req = CW.Req or {}

function CW.Req:Get(url,params,onSuccess,onFail,headers)
  local first = true
  for k,v in pairs(params) do
    if first then url = url..'?'
    else url = url..'&' end
    url = url..k..'='..v
    first = false
  end

  http.Fetch(url,onSuccess,onFail,headers)
end

function CW.Req:Post(url,params,onSuccess,onFail,headers)
  http.Post(url,params or {},onSuccess,onFail,headers)
end

function CW.Req:UrlEncode(str)

  local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
  end

  if str == nil then
    return
  end
  str = str:gsub("\n", "\r\n")
  str = str:gsub("([^%w ])", char_to_hex)
  str = str:gsub(" ", "+")
  return str
end

function CW.Req:UrlDecode(str)
  local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
  end

  if str == nil then
    return
  end
  str = str:gsub("+", " ")
  str = str:gsub("%%(%x%x)", hex_to_char)
  return str
end
