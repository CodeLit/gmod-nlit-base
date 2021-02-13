CW.Lang = CW.Lang or {}

CW.Lang.List = {}

function CW.Lang:AddTranslation(lang,tbl)
   CW.Lang.List[lang] = CW.Lang.List[lang] or {}
   for k,v in pairs(tbl) do
       CW.Lang.List[lang][k] = v
   end
end

CW:AddAllInFolder('cyber_langs')

function CW.Lang:FormatLang(lang)
    return CWStr:FormatToTwoCharsLang(lang)
end

if CLIENT then
    function CW.Lang:GetLocalLang()
        return CW.Lang:FormatLang(GetConVar('n_lang'):GetString())
    end
end

local PLY = FindMetaTable('Player')

function PLY:GetLang()
    return CW.Lang:FormatLang(self:GetInfo('n_lang'))
end

-- переводчик
function l(text,langCode)
    
    if CLIENT then
        langCode = CW.Lang:GetLocalLang()
    end
    
    local langData = CW.Lang.List[langCode]

    if langData and langData[text] then
        return langData[text]
    end

    if CW.Lang.Translate then -- перенаправляем на внешний переводчик, если не находит слово
        return CW.Lang:Translate(text,langCode)
    end

    return text
end