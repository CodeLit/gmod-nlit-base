CWLang = CWLang or {}
CWLang.List = CWLang.List or {}

local Lang = CW:Lib('lang')

CW:AddAllInFolder('cyber-langs')

local PLY = FindMetaTable('Player')

---Gets player 2-char lang code
---@return string code
function PLY:GetLang()
    return Lang:FormatLang(self:GetInfo('cw_lang'))
end