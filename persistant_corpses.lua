PLUGIN.name = "Corps Persistents"
PLUGIN.author = "Sora S."
PLUGIN.description = "Corps Persistents."

ix.config.Add("persistent_body", true, "Est-ce que le corps d'un joueur doit rester après sa réaparition.", nil, {
	category = "Corps"
})

ix.config.Add("persistent_body_time", 300, "Aprés combien de temps le corps est déruit (en seconde).", nil, {
	category = "Corps",
	data = {min = 1, max = 1200, decimals = 1}
})

local playerMeta = FindMetaTable("Player")

ix.persistant_corpse = ix.persistant_corpse or {}
ix.persistant_corpse.callbacks = ix.persistant_corpse.callbacks or {}
local callbacks = ix.persistant_corpse.callbacks


local voidFunc = function() end
-- callback can be nil on client side
function ix.persistant_corpse:RegisterOption(name, servercallback, clientcallback)
	if (SERVER) then
		if (!isfunction(servercallback)) then
			servercallback = voidFunc
		end
		self.callbacks[#self.callbacks + 1] = {
			["name"] = name,
			["callback"] = servercallback
		}
	else
		if (!isfunction(clientcallback)) then
			clientcallback = voidFunc
		end
		self.callbacks[#self.callbacks + 1] = {
			["name"] = name,
			["callback"] = clientcallback
		}
	end
end

if (SERVER) then
	util.AddNetworkString("ixDeathRagdoll")

	function playerMeta:HasDeathRagdoll()
		return IsValid(self.deathRagdoll)
	end

	function playerMeta:GetDeathRagdoll()
		return self.deathRagdoll
	end

	function playerMeta:CreateDeathRagdoll()
		self.deathRagdoll = self:CreateServerRagdoll()
		function self.deathRagdoll:OnOptionSelected(client, option, data)
			for i = 1, #callbacks do
				data = callbacks[i]
				if (data != nil and data.name == option) then
					data.callback(client, self)
					return
				end
			end
		end
		self.deathRagdoll:SetUseType(SIMPLE_USE)
		local tname = self:SteamID64() .. "_deathRagdoll"
		if (timer.Exists(tname)) then
			timer.Remove(tname)
		end
		timer.Create(tname, ix.accessories.config.DeathBodiesDespawnTime, 1, function()
			self.deathRagdoll:Remove()
		end)
		self:SetLocalVar("ragdoll", self.deathRagdoll:EntIndex())
	end

	function playerMeta:DestroyDeathRagdoll()
		if (self:HasDeathRagdoll()) then
			local tname = self:SteamID64() .. "_deathRagdoll"
			if (timer.Exists(tname)) then
				timer.Remove(tname)
			end
			hook.Run("PreDeathRagdollRemove", self, self.deathRagdoll)
			self.deathRagdoll:Remove()
			hook.Run("PostDeathRagdollRemove", self)
		end
	end

	function PLUGIN:PlayerSpawn(client)
		client:SetLocalVar("ragdoll", 0)
	end

	function PLUGIN:PlayerDisconnected(client)
		client:DestroyDeathRagdoll()
	end

	-- function PLUGIN:ShouldSpawnClientRagdoll(client)
	-- 	client:DestroyDeathRagdoll()
	-- 	client:CreateDeathRagdoll()
	-- 	print("CreateRagdoll")
	-- 	return false
	-- end

	hook.Add("ShouldSpawnClientRagdoll", "test", function(client)
		client:DestroyDeathRagdoll()
		client:CreateDeathRagdoll()
		return false
	end)

	function PLUGIN:PlayerUse(client, entity)
		if (entity:GetClass() != "prop_ragdoll") then return false end
		local owner = entity:GetNetVar("player", nil)
		if (IsValid(owner)) then
			local data
			local count = #callbacks
			if (count < 1) then return end
			if (count == 1) then
				data = callbacks[1]
				if (data.callback != nil) then
					data.callback(client, entity)
				end
				return
			end
			net.Start("ixDeathRagdoll")
				net.WriteEntity(entity)
			net.Send(client)
		end
	end
else
	net.Receive("ixDeathRagdoll", function(len)
		local options = {}
		local data
		local entity = net.ReadEntity()
		if (!IsValid(entity)) then return end
		for i = 1, #callbacks do
			data = callbacks[i]
			if (data != nil) then
				options[data.name] = data.callback
			end
		end
		if (table.Count(options) > 0) then
			ix.menu.Open(options, entity)
		end
	end)
end