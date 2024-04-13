local lang = nlitLang
local test = nlitTest
test:assertIsEqual(lang:Get('Save items'), 'Сохранить предметы')
lang:print('[Nlit Framework][TEST] Language test passed!')