snet = snet or {}
snet.Data = snet.Data or {}
snet.Receivers = snet.Receivers or {}

snet.BitCount = 4 -- 0000, 0001, 0010, ...

function snet:Register(name)
    if SERVER then
        util.AddNetworkString(name)
    end
    self.Data[name] = {
        func = {},
        names = {}
    }
    net.Receive (name, function(len, xxxxxxxx)
        local id = net.ReadUInt(snet.BitCount)
        local func = self.Data[idname]["func"][id]
        if (func == nil) then return end
        if (SERVER) then
            func(len - snet.BitCount, xxxxxxxx)
        else
            func(len - snet.BitCount)
        end
    end)
end

function snet:Start(name, id)
    net.Start(name)
    net.WriteUInt(id, self.BitCount)
end

function snet:TranslateId(name, id)
    if type(id) == "number" then return id end
    return self.Data[name]["names"][id]
end

function snet:AddFunc(idname, id, func)
    if type(id) == "string" and not self.Data[name]["names"][id] then
        self.Data[name]["names"][id] = #self.Data[name]["names"] + 1
    end
    self.Data[idname]["func"][self:TranslateId(idname, id)] = func
end

-- Player (ply) need to be nil when called on cliend side
function snet:Call(idname, id, func, xxxxxxxx)
    self:Start(idname, id)
    func()
    if xxxxxxxx then
        net.Send(xxxxxxxx)
    else
        net.SendToServer()
    end
end