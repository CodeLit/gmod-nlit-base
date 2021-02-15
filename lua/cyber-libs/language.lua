local Lang = {}

local CWStr = CW:Lib('string')

function Lang:FormatLang(lang)
    return CWStr:FormatToTwoCharsLang(lang)
end

if CLIENT then

    function Lang:GetLocalLang()
        return self:FormatLang(GetConVar('cw_lang'):GetString())
    end

end

return Lang