local pairs = pairs
local http = http
local string = string
local tonumber = tonumber
---Jobs with HTTP Requests module
---@module Requests
local Requests = {}

---Can send GET Request
---@param url string
---@param params table keyvalues
---@param onSuccess function
---@param onFail function
---@param headers table
function Requests:Get(url, params, onSuccess, onFail, headers)
    local first = true

    for k, v in pairs(params) do
        if first then
            url = url .. '?'
        else
            url = url .. '&'
        end

        url = url .. k .. '=' .. v
        first = false
    end

    http.Fetch(url, onSuccess, onFail, headers)
end

---Can send POST Request
---@param url string
---@param params table keyvalues
---@param onSuccess function
---@param onFail function
---@param headers table
function Requests:Post(url, params, onSuccess, onFail, headers)
    http.Post(url, params or {}, onSuccess, onFail, headers)
end

---Encodes a string, preparing it to send using url data
---@param str string
---@return string Formatted string
function Requests:UrlEncode(str)
    local char_to_hex = function(c) return string.format("%%%02X", string.byte(c)) end
    if str == nil then return end
    str = str:gsub("\n", "\r\n")
    str = str:gsub("([^%w ])", char_to_hex)
    str = str:gsub(" ", "+")

    return str
end

---Decodes an url string
---@param str string
---@return string Unformatted string
function Requests:UrlDecode(str)
    local hex_to_char = function(x) return string.char(tonumber(x, 16)) end
    if str == nil then return end
    str = str:gsub("+", " ")
    str = str:gsub("%%(%x%x)", hex_to_char)

    return str
end

return Requests