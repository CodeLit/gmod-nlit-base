

--- Global singleton class CWLang
---@module CWLang
CWLang = CWLang or {}

local Lang = CW:Lib('lang')

CWLang.List = CWLang.List or {}

---Adds translation to language. Can be used anywhere.
---@param lang string 2-char lang
---@param tbl table translations from english (key-value)
---@usage CWLang:AddTranslation('ru',{
---     ['Save items'] = 'Сохранить предметы',
---     ['Add items'] = 'Добавить предметы'
--- })
---@see Translator
function CWLang:AddTranslation(lang,tbl)
   self.List[lang] = self.List[lang] or {}
   for k,v in pairs(tbl) do
       self.List[lang][k] = v
   end
end

CW:AddAllInFolder('cyber-langs')

local PLY = FindMetaTable('Player')

---Gets player 2-char lang code
---@return string code
function PLY:GetLang()
    return Lang:FormatLang(self:GetInfo('cw_lang'))
end