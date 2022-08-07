local entity = {
    entityList = {},
    entityConnections = {},
    isAlive = false,
    character = {
        Head = {},
        Humanoid = {},
        HumanoidRootPart = {}
    }
}
local lplr = game:GetService("Players").LocalPlayer
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
        if plr.Team ~= lplr.Team or lplr.Team == nil then
            return true
        end
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

    entity.characterAdded = function(plr, char, localcheck, refresh)
        if char then
            task.spawn(function()
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10) or humrootpart and {Position = humrootpart.Position + Vector3.new(0, 3, 0), Name = "Head", Size = Vector3.new(1, 1, 1), CFrame = humrootpart.CFrame + Vector3.new(0, 3, 0), Parent = char}
                local hum = char:WaitForChild("Humanoid", 10) or char:FindFirstChildWhichIsA("Humanoid")
                if humrootpart and hum and head then
                    if localcheck then
                        entity.isAlive = true
                        entity.character.Head = head
                        entity.character.Humanoid = hum
                        entity.character.HumanoidRootPart = humrootpart
                    else
                        local newent = {
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
                        table.insert(newent.Connections, hum:GetPropertyChangedSignal("Health"):connect(function() entity.entityUpdatedEvent:Fire(newent) end))
                        table.insert(newent.Connections, hum:GetPropertyChangedSignal("MaxHealth"):connect(function() entity.entityUpdatedEvent:Fire(newent) end))
                        table.insert(entity.entityList, newent)
                        entity.entityAddedEvent:Fire(newent)
                    end
                    table.insert(entity.entityConnections, char.ChildRemoved:connect(function(part)
                        if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then
                            if localcheck then
                                entity.isAlive = false
                            else
                                entity.removeEntity(plr)
                            end
                        end
                    end))
                end
            end)
        end
    end

    entity.entityAdded = function(plr, localcheck, custom)
        table.insert(entity.entityConnections, plr.CharacterAdded:connect(function(char)
            entity.refreshEntity(plr, localcheck)
        end))
        table.insert(entity.entityConnections, plr.CharacterRemoving:connect(function(char)
            if localcheck then
                entity.isAlive = false
            else
                entity.removeEntity(plr)
            end
        end))
        table.insert(entity.entityConnections, plr:GetPropertyChangedSignal("Team"):connect(function()
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
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do entity.entityAdded(v, v == lplr) end
        table.insert(entity.entityConnections, game:GetService("Players").PlayerAdded:connect(function(v) entity.entityAdded(v, v == lplr) end))
        table.insert(entity.entityConnections, game:GetService("Players").PlayerRemoving:connect(function(v) entity.removeEntity(v) end))
    end

    entity.selfDestruct = function()
        for i,v in pairs(entity.entityConnections) do if v.Disconnect then v:Disconnect() end end
        for i,v in pairs(entity.entityList) do 
            entity.removeEntity(v.Player)
        end
    end
end

return entity