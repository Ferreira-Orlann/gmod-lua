OnGoing_ViewAnimation = {}
OnGoing_ViewAnimation.__index = OnGoing_ViewAnimation

--[[
    OnGoing_ViewAnimation.Animation = nil
    OnGoing_ViewAnimation.Player = nil
    OnGoing_ViewAnimation.KeyFrames = {}
]]

function OnGoing_ViewAnimation.New(animation, ply)
    local o = setmetatable({}, OnGoing_ViewAnimation)
    o.Animation = animation
    o.Player = ply
    o.KeyFrames = table.Copy(animation.KeyFrames)
    o.PreviousPlayerViewData = nil
    o.PreviousPos = nil
    o.PreviousAngles = nil
    o.Time = nil
    o.SleepTime = CurTime() - 1
    return o
end

function OnGoing_ViewAnimation:End()
end

function OnGoing_ViewAnimation:Think(pos, angles, fov)
    local keyframe = self.KeyFrames[1]
    local pdata = self.PreviousPlayerViewData
    local frametime = FrameTime()
    local data = {
        fov = fov,
        drawviewer = true
    }
    if (self.SleepTime > CurTime()) then
        return pdata
    end
    if (self.Time == nil) then
        self.Time = 0
    end
    if (pdata == nil) then
        pdata = {
            origin = pos,
            angles = angles,
            fov = fov,
            drawviewer = true
        }
    end
    if (self.PreviousPos == nil) then
        self.PreviousPos = pos
    end
    if (self.PreviousAngles == nil) then
        self.PreviousAngles = angles
    end
    local duration = keyframe.Duration
    if (duration == 0) then
        data.origin = keyframe.Pos
        data.angles = keyframe.Angles
        self.PreviousPlayerViewData = data
        self.Time = 0
        self:Next(keyframe)
        return data
    end
    local multiplicateur = 1 / ((1 / frametime) * duration)
    local kpos = keyframe.Pos
    local ppos = self.PreviousPos
    local kang = keyframe.Angles
    local pang = self.PreviousAngles
    data.origin = pdata.origin + Vector((kpos.x - ppos.x) * multiplicateur, (kpos.y - ppos.y) * multiplicateur, (kpos.z - ppos.z) * multiplicateur)
    data.angles = pdata.angles + Angle((kang.x - pang.x) * multiplicateur, (kang.y - pang.y) * multiplicateur, (kang.z - pang.z) * multiplicateur)
    self.Time = self.Time + frametime
    if (self.Time >= duration) then
        data.origin = kpos
        self.Time = 0
        self:Next(keyframe)
    end
    self.PreviousPlayerViewData = data
    return data
end

function OnGoing_ViewAnimation:Next(keyframe)
    self.PreviousPos = keyframe.Pos
    self.PreviousAngles = keyframe.Angles
    keyframe:End(self)
    table.remove(self.KeyFrames, 1)
    if (#self.KeyFrames <= 0) then
        self.Player:SetOnGoing_ViewAnimation(nil)
        self:End()
    end
end

function OnGoing_ViewAnimation:Sleep(seconds)
    self.SleepTime = CurTime() + seconds
end
