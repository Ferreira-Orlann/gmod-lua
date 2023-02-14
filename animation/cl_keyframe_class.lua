KeyFrame = {}
KeyFrame.End = function() end
KeyFrame.__index = KeyFrame

--[[
    KeyFrame.Pos = nil
    KeyFrame.Angles = nil
    KeyFrame.Duration = 1 -- duration in second from precedent KeyFrame
]]

function KeyFrame.New(pos, angles, duration, endf)
    local o = setmetatable({}, KeyFrame)
    o.Pos = pos
    o.Angles = angles
    o.Duration = duration
    o.End = endf or KeyFrame.End
    o.Start = KeyFrame.Start
    return o
end

function KeyFrame:SetStart(func)
    self.Start = func
end