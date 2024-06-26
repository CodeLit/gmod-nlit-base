--- Translates text
-- @module Translator
-- @usage local Translator = nlitLib:Load('translator')
-- -- Translations must be added to folder nlit-langs using Translator:AddTranslation() function.
-- @see Translator:AddTranslation
local Translator = {}
nlitLangList = nlitLangList or {}
local pairs = pairs
local GetConVar = GetConVar
local strings = nlitString
--- Adds translation to language. Can be used anywhere.
-- @param lang string 2-char language code
-- @param tbl table Translations from English (key-value pairs)
-- @usage Translator:AddTranslation('ru',{
--      ['Save items'] = 'Сохранить предметы',
--      ['Add items'] = 'Добавить предметы'
--  })
function Translator:AddTranslation(lang, tbl)
    nlitLangList[lang] = nlitLangList[lang] or {}
    for k, v in pairs(tbl) do
        nlitLangList[lang][k] = v
    end
end

--- Formats language to 2-chars code
-- @param lang string Full language code
-- @return string Formatted 2-char language code
function Translator:Format(lang)
    return strings:FormatToTwoCharsLang(lang)
end

if CLIENT then
    --- Returns local player language. Client function.
    -- @return string The 2-char language code of the local player
    function Translator:GetLocalLang()
        return self:Format(GetConVar('nlit_lang'):GetString())
    end
end
--- @export
return Translator