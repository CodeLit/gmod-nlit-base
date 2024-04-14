local l = nlitLang.l
local test = nlitTest
test:assertIsEqual(l('Hello there', 'fr'), 'Bonjour')
test:assertIsEqual(l('Hello there', 'ru'), 'Приветствую')
if SERVER then
    test:assertIsEqual(l('Hello there'), 'Hello there')
else
    test:assertIsEqual(l('Hello there'), l('Hello there', nlitLang:GetLocalLang()))
end

print('[Nlit\'s Framework][TEST] Language test passed!')