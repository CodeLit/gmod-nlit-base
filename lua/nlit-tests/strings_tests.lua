local test = nlitTest
local strings = nlitString
test:assertIsEqual(strings:IQ('someQoutedString'), '\'someQoutedString\'')
test:assertIsEqual(strings:Get('someFoundstring', '[A-Z].*$'), 'Foundstring')
test:assertIsEqual(strings:Len('someLengthString'), 16)
-- test:assertIsEqual(strings:Capitalize('somecapitalizedstring'), 'Somecapitalizedstring')
-- test:assertIsEqual(strings:Capitalize('someCapitalizedString'), 'SomeCapitalizedString')
test:assertIsEqual(strings:Lower('someLowerString'), 'somelowerstring')
test:assertIsEqual(strings:Upper('someUpperString'), 'SOMEUPPERSTRING')
print('[Nlit\'s Framework][TEST] Strings test passed!')