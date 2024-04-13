local concommand = concommand
local pairs = pairs
local IsValid = IsValid
NGUI = NGUI or {
    Buttons = nlitLib:Lib('Buttons'),
    Editable = nlitLib:Lib('Editable'),
    Frames = nlitLib:Lib('Frames'),
    Icons = nlitLib:Lib('Icons'),
    Inputs = nlitLib:Lib('Inputs'),
    Lists = nlitLib:Lib('Lists'),
    Menus = nlitLib:Lib('Menus'),
    Panels = nlitLib:Lib('Panels'),
    Text = nlitLib:Lib('Text'),
}

concommand.Add('cw_clear_frames', function()
    for _, frame in pairs(CW.OpenedFrames or {}) do
        if IsValid(frame) then frame:Close() end
    end
end)