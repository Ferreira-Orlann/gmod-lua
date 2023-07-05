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

For support, ferreira.orlann@gmail.com or add me on Discord: "soras."

