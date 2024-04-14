--- Clears all opened frames by closing them.
-- This command is intended for debugging or resetting UI state.
concommand.Add('nlit_clear_frames', function()
    for _, frame in pairs(Frames.OpenedFrames or {}) do
        if IsValid(frame) then frame:Close() end
    end
end)