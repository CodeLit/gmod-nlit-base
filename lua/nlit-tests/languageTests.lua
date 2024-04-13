local l = nlitLang.l
local test = nlitTest
test:assertIsEqual(l('Hello there', 'fr'), 'Bonjour')
test:assertIsEqual(l('Hello there', 'ru'), 'Приветствую')
test:assertIsEqual(l('Hello there'), 'Hello there')
lang:print('[Nlit\'s Framework][TEST] Language test passed!')