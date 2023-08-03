# Sora's ViewAnimation

GLua script for simple camera animation 

#### CLIENT SIDE ONLY !

### Usage/Examples

```lua
local anim = ViewAnimation.New() -- Return our new ViewAnimation

local function sleep(self, oanim)
    oanim:Sleep(5)
end

-- Always start with 0 duration keyframe for setup up the starting pos
anim:AddKeyFrame(KeyFrame.New(Vector(-2327.242920, 4410.893066, 8817.189453), Angle(1.496, 89.411, 0.000), 0))
anim:AddKeyFrame(KeyFrame.New(Vector(-11371.220703, 11276.468750, 9133.9570310), Angle(28.830, -89.112, 0.000), 20, sleep))
anim:AddKeyFrame(KeyFrame.New(Vector(-6861.858887, -858.115723, 9039.701172), Angle(34.459, -62.377, 0.000), 10))
anim:AddKeyFrame(KeyFrame.New(Vector(4116.708008, -3864.465820, 9034.041992), Angle(25.783, -12.620, 0.000), 10))
anim:AddKeyFrame(KeyFrame.New(Vector(-356.637878, -10715.268555, 10126.531250), Angle(20.666, -76.505, 0.000), 10))
anim:End()

LocalPlayer():StartViewAnimation(anim.Id)
-- LocalPlayer().SetOnGoing_ViewAnimation() = nil => Reset
```

# Sora's Persistent Corpse

Helix plugin to make bodies remain after player death

This plugin use helix's ix.menu native library

### Functions
```lua
-- Shared 
-- Utility: Create an option
ix.persistant_corpse:RegisterOption(name, servercallback, clientcallback)

```

### Hooks
```
-- ServerSide
-- Param one: client: Player
-- Param two: ragdoll: Entity
--      class: "prop_ragdoll"
PreDeathRagdollRemove

-- ServerSide
-- Param one: client: Player
PostDeathRagdollRemove

-- ServerSide
-- Param one: client: Player
PreDeathRagdollCreated

-- ServerSide
-- Param one: client: Player
-- Param two: ragdoll: Entity
--      class: "prop_ragdoll"
PostDeathRagdollCreated
```
# Support

For support, sora.suzuki.mail@gmail.com or add me on Discord: "soras."

