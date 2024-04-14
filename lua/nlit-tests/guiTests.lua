local test = nlitTest
local buttons = nlitLib:Load('buttons')
local panels = nlitLib:Load('panels')
local button = buttons:Create('Test button', function() end)
button:Remove()
local panel = panels:Create()
panel:Remove()
print('[Nlit\'s Framework][TEST] GUI test passed!')