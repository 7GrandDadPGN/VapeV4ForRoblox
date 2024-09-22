local GuiLibrary = shared.GuiLibrary
local playersService = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local textService = game:GetService("TextService")
local lightingService = game:GetService("Lighting")
local textChatService = game:GetService("TextChatService")
local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vapeConnections = {}
local vapeCachedAssets = {}
local vapeTargetInfo = shared.VapeTargetInfo
local vapeInjected = true
table.insert(vapeConnections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA("Camera")
end))
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local networkownerswitch = tick()
local isnetworkowner = function(part)
	local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()
end
local vapeAssetTable = {["vape/assets/VapeCape.png"] = "rbxassetid://13380453812", ["vape/assets/ArrowIndicator.png"] = "rbxassetid://13350766521"}
local getcustomasset = getsynasset or getcustomasset or function(location) return vapeAssetTable[location] or "" end
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local synapsev3 = syn and syn.toast_notification and "V3" or ""
local worldtoscreenpoint = function(pos)
	if synapsev3 == "V3" then
		local scr = worldtoscreen({pos})
		return scr[1] - Vector3.new(0, 36, 0), scr[1].Z > 0
	end
	return gameCamera.WorldToScreenPoint(gameCamera, pos)
end
local worldtoviewportpoint = function(pos)
	if synapsev3 == "V3" then
		local scr = worldtoscreen({pos})
		return scr[1], scr[1].Z > 0
	end
	return gameCamera.WorldToViewportPoint(gameCamera, pos)
end

local function vapeGithubRequest(scripturl)
	if not isfile("vape/"..scripturl) then
		local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..readfile("vape/commithash.txt").."/"..scripturl, true) end)
		assert(suc, res)
		assert(res ~= "404: Not Found", res)
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("vape/"..scripturl, res)
	end
	return readfile("vape/"..scripturl)
end

local function downloadVapeAsset(path)
	if not isfile(path) then
		task.spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary.MainGui
			repeat task.wait() until isfile(path)
			textlabel:Destroy()
		end)
		local suc, req = pcall(function() return vapeGithubRequest(path:gsub("vape/assets", "assets")) end)
        if suc and req then
		    writefile(path, req)
        else
            return ""
        end
	end
	if not vapeCachedAssets[path] then vapeCachedAssets[path] = getcustomasset(path) end
	return vapeCachedAssets[path]
end

local function warningNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function InfoNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/InfoNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(255,255,255)
		return frame
	end)
	return (suc and res)
end

local function removeTags(str)
	str = str:gsub("<br%s*/>", "\n")
	return (str:gsub("<[^<>]->", ""))
end

local function run(func) func() end


run(function() 
    local AutoClickCar = {Enabled = false}
    local Delay = {Value = 0.01}

    AutoClickCar = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "AutoClickCar",
        Function = function(callback) 
            repeat task.wait(Delay.Value or 0.01)
                fireclickdetector(workspace.Floppa:FindFirstChildWhichIsA("ClickDetector"))
            until not AutoClickCar.Enabled
        end,
        HoverText = "AutoClicks your floppa"
    })

    Delay = AutoClickCar.CreateSlider({
        Name = "Delay",
        Min = 0.01,
        Max = 60,
        Default = 0.01,
        Function = function(val) end
    })  
end)

local function TweenChar(cframe) 
    tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = cframe}):Play()
end

run(function() 
    local Recipies = {Enabled = false}
    local Dropdown = {Value = "None"}
    local hum = lplr.Character:FindFirstChildWhichIsA("Humanoid")
    local backpack = lplr.Backpack
    local function splitsecond() task.wait(0.1) end

    local function Buy(item) 
        local args = {[1] = item}
        game:GetService("ReplicatedStorage"):WaitForChild("Purchase5"):FireServer(unpack(args))
    end

    local function AddItem(item) 
        hum:EquipTool(backpack:FindFirstChild(item))
        local args = {[1] = "Add Ingredient",[2] = item}
        game:GetService("ReplicatedStorage"):WaitForChild("CookingEvent"):FireServer(unpack(args))        
    end

    local function temp(val) 
        local args = {[1] = "Change Temperature",[2] = val}
        game:GetService("ReplicatedStorage"):WaitForChild("CookingEvent"):FireServer(unpack(args))        
    end

    local function Cook() 
        local args = {
            [1] = "Cook"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("CookingEvent"):FireServer(unpack(args))        
    end

    local function TweenToStove() 
        tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(-50.2197418, 7.79999876, -60.5010338, 0.999999762, -1.30630951e-10, 0.000655336305, 2.20219593e-10, 1, -1.36706277e-07, -0.000655336305, 1.3670639e-07, 0.999999762)}):Play()
    end

    

    local function cookpizza() 
        Buy("Flour")
        splitsecond()
        Buy("Tomato")
        splitsecond()
        Buy("Cheese")
        TweenToStove()
        AddItem("Flour")
        splitsecond()
        AddItem("Tomato")
        splitsecond()
        AddItem("Cheese")
        splitsecond()
        temp(2)
        splitsecond()
        Cook()
        InfoNotification("Recipies", "Successfully Cooked. Time Took: "..tick(), 3)
    end

    local function cooksalad() 
        Buy("Lettuce")
        splitsecond()
        Buy("Lettuce")
        splitsecond()
        Buy("Tomato")
        splitsecond()
        TweenToStove()
        splitsecond()
        AddItem("Lettuce")
        splitsecond()
        AddItem("Lettuce")
        splitsecond()
        AddItem("Tomato")
        splitsecond()
        temp(3)
        splitsecond()
        Cook()
        InfoNotification("Recipies", "Successfully Cooked. Time Took: "..tick(), 3)
    end

    local function cookgc() 
        Buy("Bread")
        splitsecond()
        Buy("Cheese")
        splitsecond()
        TweenToStove()
        AddItem("Bread")
        splitsecond()
        AddItem("Cheese")
        splitsecond()
        temp(3)
        splitsecond()
        Cook()
        InfoNotification("Recipies", "Successfully Cooked. Time Took: "..tick(), 3)
    end

    local function cookspaghetti() 
        Buy("Beef")
        splitsecond()
        Buy("Tomato")
        splitsecond()
        Buy("Noodles")
        splitsecond()
        TweenToStove()
        splitsecond()
        AddItem("Beef")
        splitsecond()
        AddItem("Tomato")
        splitsecond()
        AddItem("Noodles")
        splitsecond()
        temp(2)
        splitsecond()
        Cook()
        InfoNotification("Recipies", "Successfully Cooked. Time Took: "..tick(), 3)
    end

    local function cookramen() 
        Buy("Noodles")
        splitsecond()
        Buy("Eggs")
        splitsecond()
        Buy("Soy Sauce")
        splitsecond()
        TweenToStove()
        splitsecond()
        AddItem("Noodles")
        splitsecond()
        AddItem("Eggs")
        splitsecond()
        AddItem("Soy Sauce")
        splitsecond()
        temp(2)
        splitsecond()
        Cook()
        InfoNotification("Recipies", "Successfully Cooked. Time Took: "..tick(), 3)
    end

    Recipies = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "Recipies",
        Function = function(callback) 
            if callback then
                if Dropdown.Value == "Grilled Cheese" then
                    cookgc()
                elseif Dropdown.Value == "Salad" then
                    cooksalad()
                elseif Dropdown.Value == "Pizza" then
                    cookpizza()
                elseif Dropdown.Value == "Spaghetti" then
                    cookspaghetti()
                elseif Dropdown.Value == "Ramen" then
                    cookramen()
                elseif Dropdown.Value == "Space Soup" then
                    if backpack:FindFirstChild("Almond Water") then 
                        local Meteorites = 0
                        for i, v in pairs(workspace:GetChildren()) do 
                            if v:IsA("Tool") and v.Name == "Meteorite" then 
                                Meteorites = Meteorites + 1
                            end
                        end
                        if Meteorites >= 2 then 
                            for i = 1, 2, 1 do
                                TweenChar(workspace:FindFirstChild("Meteorite").Handle.CFrame)
                                task.wait(1.1)
                            end
                        end
                        TweenToStove()
                        splitsecond()
                        AddItem("Almond Water")
                        splitsecond()
                        AddItem("Almond Water")
                        splitsecond()
                        AddItem("Meteorite")
                        splitsecond()
                        AddItem("Meteorite")
                        splitsecond()
                        temp(1)
                        splitsecond()
                        Cook()
                        InfoNotification("Recipies", "Successfully Cooked. Time Took: "..tick(), 3)
                    else
                        warningNotification("Recipies", "Need 2x Almond Water, 2x Meteorite.", 5)
                    end
                end
                Recipies.ToggleButton(true)
            end
        end
    })

    Dropdown = Recipies.CreateDropdown({
        Name = "Recipies",
        List = {"None", "Grilled Cheese", "Salad", "Pizza", "Spaghetti", "Ramen", "Space Soup"},
        Function = function(val) end
    })
end) -- longest piece of code i have ever written (lol)

run(function() 
    local SaveButton = {Enabled = false}

    SaveButton = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "SaveButton",
        Function = function(callback) 
            game:GetService("Players").LocalPlayer.PlayerGui.HUD.Frame.SaveButton.Visible = callback
        end
    })
end)

run(function() 
    local GetMeteorites = {Enabled = false}

    GetMeteorites = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "CollectMeteorites",
        Function = function(callback) 
            local meteorites = 0
            if callback then 
                for i, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and v.Name == "Meteorite" then 
                        TweenChar(v.Handle.CFrame)
                        meteorites = meteorites + 1
                        task.wait(1.1)
                    end
                end
            end
        end
    })
end)


task.spawn(function() 
    if workspace:FindFirstChild("Crystal Ball") then 
        workspace["Crystal Ball"].Transparency = 1
        workspace["Crystal Ball"]:FindFirstChildWhichIsA("ProximityPrompt").ActionText = "Interact"
    end
end)