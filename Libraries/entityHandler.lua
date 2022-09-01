local entity = {
    entityList = {},
    entityConnections = {},
    entityPlayerConnections = {},
    entityIds = {},
    isAlive = false,
    character = {
        Head = {},
        Humanoid = {},
        HumanoidRootPart = {}
    }
}
local players = game:GetService("Players")
local httpservice = game:GetService("HttpService")
local lplr = players.LocalPlayer
local entityadded = Instance.new("BindableEvent")
local entityremoved = Instance.new("BindableEvent")
local entityupdated = Instance.new("BindableEvent")
do
    entity.entityAddedEvent = {
        Connect = function(self, func)
            return entityadded.Event:Connect(func)
        end,
        connect = function(self, func)
            return entityadded.Event:Connect(func)
        end,
        Fire = function(self, ...)
            entityadded:Fire(...)
        end,
    }
    entity.entityRemovedEvent = {
        Connect = function(self, func)
            return entityremoved.Event:Connect(func)
        end,
        connect = function(self, func)
            return entityremoved.Event:Connect(func)
        end,
        Fire = function(self, ...)
            entityremoved:Fire(...)
        end,
    }
    entity.entityUpdatedEvent = {
        Connect = function(self, func)
            return entityupdated.Event:Connect(func)
        end,
        connect = function(self, func)
            return entityupdated.Event:Connect(func)
        end,
        Fire = function(self, ...)
            entityupdated:Fire(...)
        end,
    }

    entity.isPlayerTargetable = function(plr)
        if (not lplr.Team) then return true end
        if plr.Team ~= lplr.Team then return true end
        return plr.Team and #plr.Team:GetPlayers() == #players:GetPlayers()
    end

    entity.getEntityFromPlayer = function(char)
        for i,v in next, entity.entityList do
            if v.Player == char then 
                return i, v
            end
        end
    end

    entity.removeEntity = function(obj)
        local tableIndex, ent = entity.getEntityFromPlayer(obj)
        if tableIndex then
            entity.entityRemovedEvent:Fire(obj)
            for i,v in next, (ent.Connections or {}) do if v.Disconnect then v:Disconnect() end end
            table.remove(entity.entityList, tableIndex)
        end
    end

    entity.refreshEntity = function(plr, localcheck)
        entity.removeEntity(plr)
        entity.characterAdded(plr, plr.Character, localcheck, true)
    end

    entity.getHealth = function(plr) -- Override this function to get health on games that dont use humanoid.health
        local tableIndex, ent = entity.getEntityFromPlayer(plr)
        if ent then 
            return ent.Humanoid.Health
        end
    end

    entity.getUpdateConnections = function(ent) -- Override this function to update connections on games that dont use humanoid health
        local hum = ent.Humanoid
        return {
            hum:GetPropertyChangedSignal("Health"),
            hum:GetPropertyChangedSignal("MaxHealth")
        }
    end

    entity.characterAdded = function(plr, char, localcheck, refresh)
        if char then
            task.spawn(function()
                local id = httpservice:GenerateGUID(true)
                entity.entityIds[plr.Name] = id
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10) or humrootpart and {Position = humrootpart.Position + Vector3.new(0, 3, 0), Name = "Head", Size = Vector3.new(1, 1, 1), CFrame = humrootpart.CFrame + Vector3.new(0, 3, 0), Parent = char}
                local hum = char:WaitForChild("Humanoid", 10) or char:FindFirstChildWhichIsA("Humanoid")
                if entity.entityIds[plr.Name] ~= id then return end
                if humrootpart and hum and head then
                    local childremoved
                    local newent
                    if localcheck then
                        entity.isAlive = true
                        entity.character.Head = head
                        entity.character.Humanoid = hum
                        entity.character.HumanoidRootPart = humrootpart
                    else
                        newent = {
                            Player = plr,
                            Character = char,
                            HumanoidRootPart = humrootpart,
                            RootPart = humrootpart,
                            Head = head,
                            Humanoid = hum,
                            Targetable = entity.isPlayerTargetable(plr),
                            Team = plr.Team,
                            Connections = {}
                        }
                        setmetatable(newent, {
                            __tostring = function()
                                return newent.Player.Name
                            end,
                            __index = function(t, k) 
                                if k == 'Health' then 
                                    return newent.Humanoid and newent.Humanoid.Health or 100
                                end
                                return rawget(t, k)
                            end
                        })
                        for i, v in pairs(entity.getUpdateConnections(newent)) do 
                            table.insert(newent.Connections, v:Connect(function() 
                                entity.entityUpdatedEvent:Fire(newent)
                            end))
                        end
                        table.insert(entity.entityList, newent)
                        entity.entityAddedEvent:Fire(newent)
                    end
                    childremoved = char.ChildRemoved:Connect(function(part)
                        if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then
                            childremoved:Disconnect()
                            if localcheck then
                                entity.isAlive = false
                            else
                                entity.removeEntity(plr)
                            end
                        end
                    end)
                    if newent then 
                        table.insert(newent.Connections, childremoved)
                    end
                    table.insert(entity.entityConnections, childremoved)
                end
            end)
        end
    end

    entity.entityAdded = function(plr, localcheck, custom)
        table.insert(entity.entityConnections, plr.CharacterAdded:Connect(function(char)
            entity.refreshEntity(plr, localcheck)
        end))
        table.insert(entity.entityConnections, plr.CharacterRemoving:Connect(function(char)
            if localcheck then
                entity.isAlive = false
            else
                entity.removeEntity(plr)
            end
        end))
        table.insert(entity.entityConnections, plr:GetPropertyChangedSignal("Team"):Connect(function()
            for i,v in next, entity.entityList do
                local newtarget = entity.isPlayerTargetable(v.Player)
                if v.Targetable ~= newtarget then 
                    entity.refreshEntity(plr, localcheck)
                end
            end
            if localcheck then
                entity.fullEntityRefresh()
            else
                entity.refreshEntity(plr, localcheck)
            end
        end))
        task.spawn(function()
            if not plr.Character then
                for i = 1, 10 do 
                    task.wait(0.1)
                    if plr.Character then break end
                end
            end
            if plr.Character then
                entity.refreshEntity(plr, localcheck)
            end
        end)
    end

    entity.fullEntityRefresh = function()
        entity.selfDestruct()
        for i,v in pairs(players:GetPlayers()) do entity.entityAdded(v, v == lplr) end
        table.insert(entity.entityConnections, players.PlayerAdded:Connect(function(v) entity.entityAdded(v, v == lplr) end))
        table.insert(entity.entityConnections, players.PlayerRemoving:Connect(function(v) entity.removeEntity(v) end))
    end

    entity.selfDestruct = function()
        for i,v in pairs(entity.entityIds) do entity.entityIds[i] = nil end
        for i,v in pairs(entity.entityConnections) do if v.Disconnect then v:Disconnect() end end
        for i,v in pairs(entity.entityList) do 
            entity.removeEntity(v.Player)
        end
    end
end

return entity