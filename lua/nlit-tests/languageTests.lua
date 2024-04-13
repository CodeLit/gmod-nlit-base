local lang = nlitLang
local test = nlitTest
test:assertIsEqual(lang:Get('Save items'), 'Сохранить предметы')
lang:print('[Nlit\'s Framework][TEST] Language test passed!')