--- Translates text
-- @module nlitLang
-- @usage local Lang = require 'nlitLang'
-- local text = Lang:l('my long story text','ru') -- will translate this text to Russian
-- -- Translations must be added to folder nlit-langs using Lang:AddTranslation() function.
-- @see Lang:AddTranslation
local Lang = {}
local pairs = pairs
local GetConVar = GetConVar
local strings = nlitString
--- Adds translation to language. Can be used anywhere.
-- @param lang string 2-char language code
-- @param tbl table Translations from English (key-value pairs)
-- @usage Lang:AddTranslation('ru',{
--      ['Save items'] = 'Сохранить предметы',
--      ['Add items'] = 'Добавить предметы'
--  })
function Lang:AddTranslation(lang, tbl)
    self.List = self.List or {}
    self.List[lang] = self.List[lang] or {}
    for k, v in pairs(tbl) do
        self.List[lang][k] = v
    end
end

--- Formats language to 2-chars code
-- @param lang string Full language code
-- @return string Formatted 2-char language code
function Lang:Format(lang)
    return strings:FormatToTwoCharsLang(lang)
end

if CLIENT then
    --- Returns local player language. Client function.
    -- @return string The 2-char language code of the local player
    function Lang:GetLocalLang()
        return self:Format(GetConVar('nlit_lang'):GetString())
    end
end

--- Translates text
-- @param text string Text to translate
-- @param langCode string Optional language code, defaults to local player's language
-- @return string Translated text
function Lang:l(text, langCode)
    if CLIENT then langCode = langCode or self:GetLocalLang() end
    if not langCode then return text end
    local langData = self.List[langCode]
    if langData and langData[text] then return langData[text] end
    if self.Translate then -- Will redirect to external translator if not found a word
        return self:Translate(text, langCode)
    end
    return text
end

nlit:AddAllInFolder('nlit-langs')
return Lang