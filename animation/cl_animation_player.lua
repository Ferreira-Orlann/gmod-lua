local PLAYER = FindMetaTable("Player")
PLAYER.OnGoing_ViewAnimation = nil

function PLAYER:StartViewAnimation(id)
    local on_anim = OnGoing_ViewAnimation.New(SLib.viewanimation.registered[id], self)
    self.OnGoing_ViewAnimation = on_anim
    return true
end

function PLAYER:GetOnGoing_ViewAnimation()
    return self.OnGoing_ViewAnimation
end

function PLAYER:SetOnGoing_ViewAnimation(view)
    self.OnGoing_ViewAnimation = view
end