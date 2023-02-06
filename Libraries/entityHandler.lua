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
        if (not plr.Team) then return true end
        if plr.Team ~= lplr.Team then return true end
        return #plr.Team:GetPlayers() == #players:GetPlayers()
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
            if ent.Connections then
                for i,v in next, ent.Connections do 
                    if v.Disconnect then pcall(function() v:Disconnect() end) continue end
                    if v.disconnect then pcall(function() v:disconnect() end) continue end
                end
            end
            entity.entityList[tableIndex] = nil
        end
    end

    entity.refreshEntity = function(plr, localcheck)
        entity.removeEntity(plr)
        entity.characterAdded(plr, plr.Character, localcheck, true)
    end

    entity.getUpdateConnections = function(ent)
        local hum = ent.Humanoid
        return {
            hum:GetPropertyChangedSignal("Health"),
            hum:GetPropertyChangedSignal("MaxHealth")
        }
    end

    entity.characterAdded = function(plr, char, localcheck, refresh)
        local id = httpservice:GenerateGUID(true)
        entity.entityIds[plr.Name] = id
        if char then
            task.spawn(function()
                local humrootpart = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
                if not humrootpart then
                    for i = 1, 100 do 
                        humrootpart = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
                        if humrootpart then break end
                        task.wait(0.01)
                    end
                end
                local head = char:WaitForChild("Head", 10) or humrootpart and setmetatable({Name = "Head", Size = Vector3.new(1, 1, 1), Parent = char}, {__index = function(t, k) 
                    if k == 'Position' then
                        return humrootpart.Position + Vector3.new(0, 3, 0)
                    elseif k == 'CFrame' then 
                        return humrootpart.CFrame + Vector3.new(0, 3, 0)
                    end
                end})
                local hum = char:FindFirstChildWhichIsA("Humanoid") or char:WaitForChild("Humanoid", 10)
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
                        for i, v in next, entity.getUpdateConnections(newent) do 
                            table.insert(newent.Connections, v:Connect(function() 
                                entity.entityUpdatedEvent:Fire(newent)
                            end))
                        end
                        table.insert(entity.entityList, newent)
                        entity.entityAddedEvent:Fire(newent)
                    end
                    childremoved = char.ChildRemoved:Connect(function(part)
                        if part == humrootpart or part == hum or part == head then
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
        table.insert(entity.entityConnections, plr:GetPropertyChangedSignal("Character"):Connect(function()
            if plr.Character then
                entity.refreshEntity(plr, localcheck)
            else
                if localcheck then
                    entity.isAlive = false
                else
                    entity.removeEntity(plr)
                end
            end
        end))
        table.insert(entity.entityConnections, plr:GetPropertyChangedSignal("Team"):Connect(function()
            for i,v in next, entity.entityList do
                if v.Targetable ~= entity.isPlayerTargetable(v.Player) then 
                    entity.refreshEntity(v.Player)
                end
            end 
            if localcheck then
                entity.fullEntityRefresh()
            else
                entity.refreshEntity(plr, localcheck)
            end
        end))
        if plr.Character then
            task.spawn(entity.refreshEntity, plr, localcheck)
        end
    end

    entity.fullEntityRefresh = function()
        entity.selfDestruct()
        for i,v in next, entity.entityIds do entity.entityIds[i] = nil end
        for i,v in next, players:GetPlayers() do entity.entityAdded(v, v == lplr) end
        table.insert(entity.entityConnections, players.PlayerAdded:Connect(function(v) entity.entityAdded(v, v == lplr) end))
        table.insert(entity.entityConnections, players.PlayerRemoving:Connect(function(v) entity.removeEntity(v) end))
    end

    entity.selfDestruct = function()
        for i,v in next, entity.entityConnections do 
            if v.Disconnect then pcall(function() v:Disconnect() end) continue end
            if v.disconnect then pcall(function() v:disconnect() end) continue end
        end
        for i,v in next, entity.entityIds do entity.entityIds[i] = nil end
        for i,v in next, entity.entityList do entity.removeEntity(v.Player) end
    end
end

return entity
