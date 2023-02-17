SLib.viewanimation = SLib.animation or {}
SLib.viewanimation.registered = {}

ViewAnimation = {}
ViewAnimation.__index = ViewAnimation

--[[
    ViewAnimation.Id = nil
    ViewAnimation.KeyFrames = {}
]]

function ViewAnimation.New()
    local o = setmetatable({}, ViewAnimation)
    local id = #SLib.viewanimation.registered + 1
    ROLC.viewanimation.registered[id] = true
    o.Id = id
    o.KeyFrames = {}
    return o
end

function ViewAnimation:End()
    ROLC.viewanimation.registered[self.Id] = self
    return self
end

function ViewAnimation:AddKeyFrame(keyframe)
    self.KeyFrames[#self.KeyFrames + 1] = keyframe
    return self
end

function ViewAnimation:Start(ply)
    ply:StartViewAnimation(self.Id)
end