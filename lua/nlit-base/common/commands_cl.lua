--- Commands for gmod-nlit-base
-- @module nlitCommands
local Frames = nlitLib:Load('frames')
--- Clears all opened frames by closing them.
-- This command is intended for debugging or resetting UI state.
-- @usage nlit_clear_frames (in gmod console)
local function nlit_clear_frames()
    for _, frame in pairs(Frames.OpenedFrames or {}) do
        if IsValid(frame) then frame:Close() end
    end

    print('Frames cleared!')
end

concommand.Add('nlit_clear_frames', nlit_clear_frames)