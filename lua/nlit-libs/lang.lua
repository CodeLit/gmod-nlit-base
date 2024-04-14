--- Translates text
-- @module Lang
-- @param text string Text to translate
-- @param langCode string Optional language code, defaults to local player's language
-- @return string Translated text
-- @see Translator:AddTranslation
-- @usage local l = nlitLib:Load('lang')
-- local text = l('my long story text','ru') -- will translate this text to Russian
local Translator = nlitLib:Load('translator')
local function l(text, langCode)
    if CLIENT then langCode = langCode or Translator:GetLocalLang() end
    if not langCode then return text end
    local langData = nlitLangList[langCode]
    if langData and langData[text] then return langData[text] end
    if Translator.Translate then -- Will redirect to external translator if not found a word
        return Translator:Translate(text, langCode)
    end
    return text
end
--- @export
return l