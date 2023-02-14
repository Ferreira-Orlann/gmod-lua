SLib = SLib or {}
SLib.viewanimation = SLib.animation or {}
SLib.viewanimation.registered = {}

hook.Add( "HUDShouldDraw", "ROLC_HUDShouldDraw_Anim", function()
    if (LocalPlayer():GetOnGoing_ViewAnimation() ~= nil) then
        return false
    end
end)

hook.Add( "CalcView", "ROLC_CalcView_Anim", function( ply, pos, angles, fov )
    if (ply:GetOnGoing_ViewAnimation() ~= nil) then
        return ply:GetOnGoing_ViewAnimation():Think(pos, angles, fov)
    end
end)

hook.Add("CreateMove", "ROLC_CreateMove", function( cmddata)
    if (LocalPlayer():GetOnGoing_ViewAnimation() ~= nil) then
        cmddata:ClearMovement()
        return true
    end
end)