local test = nlitTest
local buttons = NGUI.Buttons
local frames = NGUI.Frames
local panels = NGUI.Panels
timer.Simple(1, function()
    local button = buttons:Create('Test button', function() print('Test button clicked!') end)
    button:Remove()
    local panel = panels:Create()
    panel:SetText('Test panel')
    panel:Remove()
    test:assertIsEqual(button:GetText(), 'Test button')
    frame = frames:Create('Test frame')
    frame:Close()
    print('[Nlit\'s Framework][TEST] GUI test passed!')
end)