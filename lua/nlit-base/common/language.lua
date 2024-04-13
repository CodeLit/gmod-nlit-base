--- Translates text
-- @module nlitLang
-- @usage local l = nlitLang.Translator
-- local text = l('my long story text','ru') -- will translate this text to russian
-- -- translations must be added to folder nlit-langs using CWLang:AddTranslation() function.
-- @see nlitLang:AddTranslation
module('nlitLang', package.seeall)
local pairs = pairs
local GetConVar = GetConVar
local strings = nlitString
--- Adds translation to language. Can be used anywhere.
-- @param lang string 2-char lang
-- @param tbl table translations from english (key-value)
-- @usage Lang:AddTranslation('ru',{
--      ['Save items'] = 'Сохранить предметы',
--      ['Add items'] = 'Добавить предметы'
--  })
-- @see nlitLang
function AddTranslation(self, lang, tbl)
    self.List = self.List or {}
    self.List[lang] = self.List[lang] or {}
    for k, v in pairs(tbl) do
        self.List[lang][k] = v
    end
end

--- Formats language to 2-chars code
-- @param lang string
-- @return string formatted lang
function Format(self, lang)
    return strings:FormatToTwoCharsLang(lang)
end

if CLIENT then
    --- Returns local player language. Client function.
    -- @return string
    function GetLocalLang(self)
        return self:Format(GetConVar('nlit_lang'):GetString())
    end
end

--- Translates text
-- @param text string
-- @param langCode string
-- @return string Translated text
local function Translator(self, text, langCode)
    if CLIENT then langCode = nlitLang:GetLocalLang() end
    local langData = CWLang.List[langCode]
    if langData and langData[text] then return langData[text] end
    if CWLang.Translate then -- Will redirect to external translator if not found a word
        return CWLang:Translate(text, langCode)
    end
    return text
end

nlit.AddAllInFolder('nlit-langs')