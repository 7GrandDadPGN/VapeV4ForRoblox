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

do
    entity.isPlayerTargetable = function(plr)
        if plr.Team ~= lplr.Team or lplr.Team == nil then
            return true
        end
    end

    entity.getEntityFromPlayer = function(char)
        for i,v in pairs(entity.entityList) do
            if v.Player == char then
                return i
            end
        end
        return nil
    end

    entity.removeEntity = function(obj)
        local tableIndex = entity.getEntityFromPlayer(obj)
        if tableIndex then
            table.remove(entity.entityList, tableIndex)
        end
    end

    entity.refreshEntity = function(plr, localcheck)
        local tableIndex = entity.getEntityFromPlayer(plr)
        if tableIndex then
            table.remove(entity.entityList, tableIndex)
        end
        entity.characterAdded(plr, plr.Character, localcheck)
    end

    entity.characterAdded = function(plr, char, localcheck)
        if char then
            spawn(function()
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10)
                local hum = char:WaitForChild("Humanoid", 10)
                if humrootpart and hum and head then
                    if localcheck then
                        entity.isAlive = true
                        entity.character.Head = head
                        entity.character.Humanoid = hum
                        entity.character.HumanoidRootPart = humrootpart
                    else
                        table.insert(entity.entityList, {
                            Player = plr,
                            Character = char,
                            RootPart = humrootpart,
                            Targetable = entity.isPlayerTargetable(plr),
                            Team = plr.Team
                        })
                    end
                    entity.entityConnections[#entity.entityConnections + 1] = char.ChildRemoved:connect(function(part)
                        if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then
                            if localcheck then
                                entity.isAlive = false
                            else
                                entity.removeEntity(plr)
                            end
                        end
                    end)
                end
            end)
        end
    end

    entity.entityAdded = function(plr, localcheck, custom)
        entity.entityConnections[#entity.entityConnections + 1] = plr.CharacterAdded:connect(function(char)
            entity.refreshEntity(plr, localcheck)
        end)
        entity.entityConnections[#entity.entityConnections + 1] = plr.CharacterRemoving:connect(function(char)
            if localcheck then
                entity.isAlive = false
            else
                entity.removeEntity(plr)
            end
        end)
        entity.entityConnections[#entity.entityConnections + 1] = plr:GetPropertyChangedSignal("Team"):connect(function()
            if localcheck then
                entity.fullEntityRefresh()
            else
                task.wait(0.5)
                entity.refreshEntity(plr, localcheck)
            end
        end)
        if plr.Character then
            entity.refreshEntity(plr, localcheck)
        end
    end

    entity.fullEntityRefresh = function()
        entity.entityList = {}
        for i,v in pairs(entity.entityConnections) do if v.Disconnect then v:Disconnect() end end
        entity.entityConnections = {}
        for i2,v2 in pairs(game:GetService("Players"):GetChildren()) do entity.entityAdded(v2, v2 == lplr) end
        entity.entityConnections[#entity.entityConnections + 1] = game:GetService("Players").PlayerAdded:connect(function(v2) entity.entityAdded(v2, v2 == lplr) end)
        entity.entityConnections[#entity.entityConnections + 1] = game:GetService("Players").PlayerRemoving:connect(function(v2) entity.removeEntity(v2) end)
    end
end

return entity