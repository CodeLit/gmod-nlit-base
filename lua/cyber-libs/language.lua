--- Global singleton class for working with languages
---@module Language
local Language = {}

local CWStr = CW:Lib('string')

---Adds translation to language. Can be used anywhere.
---@param lang string 2-char lang
---@param tbl table translations from english (key-value)
---@usage CWLang:AddTranslation('ru',{
---     ['Save items'] = 'Сохранить предметы',
---     ['Add items'] = 'Добавить предметы'
--- })
---@see Translator
function Language:AddTranslation(lang,tbl)
   CWLang.List[lang] = CWLang.List[lang] or {}
   for k,v in pairs(tbl) do
       CWLang.List[lang][k] = v
   end
end

---Formats language to 2-chars code
---@param lang string
---@return string formatted lang
function Language:Format(lang)
    return CWStr:FormatToTwoCharsLang(lang)
end

if CLIENT then

    --- Returns local player language. Client function.
    ---@return string
    function Language:GetLocalLang()
        return self:Format(GetConVar('cw_lang'):GetString())
    end

end

return Language