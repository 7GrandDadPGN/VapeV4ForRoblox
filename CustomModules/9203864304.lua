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

local backpack = lplr.Backpack
local hum = lplr.Character:FindFirstChildWhichIsA("Humanoid")

local function splitsecond() task.wait(0.1) end
local function second() task.wait(1) end

run(function() 
    local Recipies = {Enabled = false}
    local Dropdown = {Value = "None"}
    
    local Methods = {
        ["Grilled Cheese"] = {
            Item1 = "Bread",
            Item2 = "Cheese",
            temp = 3
        },

        ["Pizza"] = {
            Item1 = "Flour",
            Item2 = "Tomato"
            Item3 = "Cheese",
            temp = 2
        },

        ["Salad"] = {
            Item1 = "Lettuce",
            Item2 = "Lettuce",
            Item3 = "Tomato",
            temp = 3
        },

        ["Spaghetti"] = {
            Item1 = "Beef",
            Item2 = "Tomato",
            Item3 = "Noodles",
            temp = 2
        },

        ["Ramen"] = {
            Item1 = "Noodles",
            Item2 = "Eggs",
            Item3 = "Soy Sauce",
            temp = 2
        },

        ["Mac & Cheese"] = {
            Item1 = "Noodles",
            Item2 = "Milk",
            Item3 = "Cheese",
            temp = 2
        },

        ["Cake"] = {
            Item1 = "Eggs",
            Item2 = "Milk",
            Item3 = "Sugar",
            Item4 = "Flour",
            temp = 1
        },

        ["Burger"] = {
            Item1 = "Bread",
            Item2 = "Beef",
            Item3 = "Lettuce",
            Item4 = "Tomato",
            temp = 1
        },

        ["Space Soup"] = {
            Item1 = "Almond Water",
            Item2 = "Almond Water",
            Item3 = "Meteorite",
            Item4 = "Meteorite",
            temp = 1
        }
    }

    local function Buy(item) 
        if item ~= "None" then 
            local args = {[1] = item}
            game:GetService("ReplicatedStorage"):WaitForChild("Purchase5"):FireServer(unpack(args))
        end
    end

    local function AddItem(item) 
        if item ~= "None" then
            hum:EquipTool(backpack:FindFirstChild(item))
            local args = {[1] = "Add Ingredient",[2] = item}
            game:GetService("ReplicatedStorage"):WaitForChild("CookingEvent"):FireServer(unpack(args))
        end
    end

    local function temp(val) 
        local args = {[1] = "Change Temperature",[2] = val}
        game:GetService("ReplicatedStorage"):WaitForChild("CookingEvent"):FireServer(unpack(args))        
    end

    local function FireCookEvent() 
        local args = {[1] = "Cook"}
        game:GetService("ReplicatedStorage"):WaitForChild("CookingEvent"):FireServer(unpack(args))        
    end

    local function TweenToStove() 
        tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(-50.2197418, 7.79999876, -60.5010338, 0.999999762, -1.30630951e-10, 0.000655336305, 2.20219593e-10, 1, -1.36706277e-07, -0.000655336305, 1.3670639e-07, 0.999999762)}):Play()
    end

    Recipies = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "Recipies",
        Function = function(callback) 
            if callback then
                if Dropdown.Value ~= "None" then
                    local meth = Methods[Dropdown.Value]
                    local items = #meth - 1
                    local item = 1

                    for i = 1,items,1 do 
                        splitsecond()
                        Buy(meth[item])
                        splitsecond()
                        AddItem(meth[item])
                        item = item + 1
                    end
                    splitsecond()
                    temp(meth.temp)
                    splitsecond()
                    FireCookEvent()
                end
                Recipies.ToggleButton(true)
            end
        end
    })

    Dropdown = Recipies.CreateDropdown({
        Name = "Recipies",
        List = {"None", "Grilled Cheese", "Salad", "Pizza", "Spaghetti", "Ramen", "Mac & Cheese", "Cake", "Burger", "Space Soup"},
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
             if callback then 
                local Meteorites = 0
                local oldcframe = lplr.Character.HumanoidRootPart.CFrame

                for i, v in paris(workspace:GetDescendants()) do 
                    if v:IsA("Tool") and v.Name = "Meteorite" then 
                        TweenChar(v.Handle.CFrame)
                    end
                end
                repeat task.wait() until not workspace:FindFirstChild("Meteorite")
                second()
                TweenChar(oldcframe)
                splitsecond()
                InfoNotification("CollectMeteorites", "Successfully Collected Meteorites. Meteorites:"..Meteorites, 3)
            end
        end
    })
end)

run(function() 
    local AutoSave = {Enabled = false}

    AutoSave = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "AutoSave",
        Function = function(callback) 
            if callback then 
                repeat task.wait(1)
                    workspace["Floppy Disk"]:FindFirstChildWhichIsA("ProximityPrompt"):InputHoldBegin()
                    workspace["Floppy Disk"]:FindFirstChildWhichIsA("ProximityPrompt"):InputHoldEnd()
                until not AutoSave.Enabled
            end
        end
    })

    AutoSave.Object.Visible = false
end)

run(function() 
    local ClearBackpack = {Enabled = false}

    ClearBackpack = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "ClearBackpack",
        Function = function(callback) 
            if callback then 
                backpack:ClearAllChildren()
                ClearBackpack.ToggleButton(true)
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