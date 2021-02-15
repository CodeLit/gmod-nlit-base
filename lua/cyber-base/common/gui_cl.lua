concommand.Add('cw_clear_frames', function ()
    for _, frame in pairs(CW.OpenedFrames or {}) do
        if IsValid(frame) then
            frame:Close()
        end
    end
end)