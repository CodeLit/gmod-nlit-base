local concommand = concommand
local pairs = pairs
local IsValid = IsValid

CWGUI = {
    Buttons = CW:Lib('Buttons'),
    Editable = CW:Lib('Editable'),
    Frames = CW:Lib('Frames'),
    Icons = CW:Lib('Icons'),
    Inputs = CW:Lib('Inputs'),
    Lists = CW:Lib('Lists'),
    Menus = CW:Lib('Menus'),
    Panels = CW:Lib('Panels'),
    Text = CW:Lib('Text'),
}

concommand.Add('cw_clear_frames', function()
    for _, frame in pairs(CW.OpenedFrames or {}) do
        if IsValid(frame) then
            frame:Close()
        end
    end
end)