local hook = hook
local GetConVar = GetConVar
local cam = cam
local LocalPlayer = LocalPlayer
local Angle = Angle
local D = nlitLib:Lib('draw')
local c = nlitColors
local lineSize = 50
local addLinesNum = 5 / 2
local Clr = c:Yellow()
hook.Add('PostDrawOpaqueRenderables', 'nlit Debug Helper', function()
    if not GetConVar('developer'):GetBool() then return end
    cam.Start3D2D(LocalPlayer():GetEyeTrace().HitPos, Angle(0, 0, 0), 0.1)
    D:Line(-lineSize, -lineSize, lineSize, lineSize, Clr)
    D:Line(-lineSize, lineSize, lineSize, -lineSize, Clr)
    for i = 1, addLinesNum do
        i = i
        D:Line(-lineSize + i, -lineSize - i, lineSize + i, lineSize - i, Clr)
        D:Line(-lineSize - i, lineSize - i, lineSize - i, -lineSize - i, Clr)
    end

    for i = 1, addLinesNum do
        i = -i
        D:Line(-lineSize + i, -lineSize - i, lineSize + i, lineSize - i, Clr)
        D:Line(-lineSize - i, lineSize - i, lineSize - i, -lineSize - i, Clr)
    end

    cam.End3D2D()
end)