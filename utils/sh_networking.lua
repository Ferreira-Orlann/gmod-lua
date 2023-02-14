snet = snet or {}
snet.Data = nt.Data or {}
snet.Receivers = snet.Receivers or {}

snet.BitCount = 4 -- Max number of function assigned to a name on each side

function snet:Register(name)
    if SERVER then
        util.AddNetworkString(name)
    end
    self.Data[name] = {}
    net.Receive(name, function(len, ply)
        local id = net.ReadUInt(snet.BitCount)
        if (SERVER) then
            self.Data[name][id](len - snet.BitCount, ply)
        else
            self.Data[name][id](len - snet.BitCount)
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
