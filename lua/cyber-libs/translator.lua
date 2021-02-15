--- Translates text
---@module Translator
---@usage local l = CW:Lib('translator')
--- local text = l('my long story text','ru') -- will translate this text to russian
--- -- translations must be added to folder cyber-langs using CWLang:AddTranslation() function.
---@see CWLang:AddTranslation

local Lang = CW:Lib('lang')

---Translates text
---@param text string
---@param langCode string
---@return string Translated text
local function Translator(text,langCode)

    if CLIENT then
        langCode = Lang:GetLocalLang()
    end

    local langData = CWLang.List[langCode]

    if langData and langData[text] then
        return langData[text]
    end

    if CWLang.Translate then -- перенаправляем на внешний переводчик, если не находит слово
        return CWLang:Translate(text,langCode)
    end

    return text
end

return Translator