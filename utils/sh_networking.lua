snet = snet or {}
snet.Data = snet.Data or {}
snet.Receivers = snet.Receivers or {}

snet.BitCount = 4 -- 0000, 0001, 0010, ...

function snet:Register(name)
    if SERVER then
        util.AddNetworkString(name)
    end
    self.Data[name] = {}
    net.Receive(name, function(len, ply)
        local id = net.ReadUInt(snet.BitCount)
        local func = self.Data[name][id]
        if (func == nil) then return end
        if (SERVER) then
            func(len - snet.BitCount, ply)
        else
            func(len - snet.BitCount)
        end
    end)
end

function snet:Start(name, id)
    net.Start(name)
    net.WriteUInt(id, self.BitCount)
end

function snet:AddFunc(idname, id, func)
    self.Data[idname][id] = func
end

-- Player (ply) need to be nil when called on cliend side
function snet:Call(idname, id, func, ply)
    self:Start(idname, id)
    func()
    if ply then
        net.Send(ply)
    else
        net.SendToServer()
    end
end