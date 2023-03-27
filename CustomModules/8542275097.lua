-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local textChatService = game:GetService("TextChatService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset
local chatconnection
local connectionstodisconnect = {}

local RenderStepTable = {}
local StepTable = {}

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end


local function createwarning(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "vape/assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat task.wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then
                    closest = mag
                    returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and (checkvis == false or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
                local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = v
                    end
                end
            end
        end
    end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local oldpos = Vector3.new(0, 0, 0)

local function getScaffold(vec, diagonaltoggle)
	local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
	local newpos = (oldpos - realvec)
	local returedpos = realvec
	if isAlive() then
		local angle = math.deg(math.atan2(-lplr.Character.Humanoid.MoveDirection.X, -lplr.Character.Humanoid.MoveDirection.Z))
		local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
		if goingdiagonal and ((newpos.X == 0 and newpos.Z ~= 0) or (newpos.X ~= 0 and newpos.Z == 0)) and diagonaltoggle then
			return oldpos
		end
	end
    return realvec
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

local skywars = {}
local getfunctions
runcode(function()
    getfunctions = function()
		local Flamework = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
		repeat task.wait() until Flamework.isInitialized
		local controllers = {}
		local controllerids = {}
		local eventnames = {}
		for i,v in pairs(debug.getupvalue(Flamework.Testing.patchDependency, 1).idToObj) do
			controllers[tostring(v)] = v
			controllerids[tostring(v)] = i 
			local controllerevents = {}
			for i2,v2 in pairs(v) do
				if type(v2) == "function" then
					local eventsfound = {}
					for i3,v3 in pairs(debug.getconstants(v2)) do
						if tostring(v3):find("-") == 9 then
							table.insert(eventsfound, tostring(v3))
						end
					end
					if #eventsfound > 0 then
						controllerevents[i2] = eventsfound
					end
				end
			end
			eventnames[tostring(v)] = controllerevents
		end
        local Events = require(game:GetService("ReplicatedStorage").TS.events).GlobalEvents.client
		skywars = {
			["EventHandler"] = Events,
			["Events"] = eventnames,
			["BlockFunctionHandler"] = require(lplr.PlayerScripts.TS.events).Functions,
			["HotbarController"] = controllers["HotbarController"],
			--["ReplicaHandler"] = require(lplr.PlayerScripts.TS.replicas).Replicas,
			["BlockUtil"] = require(game:GetService("ReplicatedStorage").TS.util["block-util"]).BlockUtil,
			["ScreenController"] = controllers["ScreenController"],
			["MeleeController"] = Flamework.resolveDependency(controllerids["MeleeController"]),
			["ItemTable"] = require(game:GetService("ReplicatedStorage").TS.item.item).Items,
			["HealthController"] = Flamework.resolveDependency(controllerids["HealthController"])
		}
    end
end)

getfunctions()
GuiLibrary["SelfDestructEvent"].Event:connect(function()
	if chatconnection then
		chatconnection:Disconnect()
	end
	for i3,v3 in pairs(connectionstodisconnect) do
		if v3.Disconnect then
			v3:Disconnect()
		end
	end
end)

local function getSword()
	for i,v in ipairs(skywars["HotbarController"]:getHotbarItems()) do
		local item = skywars["ItemTable"][v.Type]
		if item.Melee then
			return item
		end
	end
	return nil
end

local function getItem(itemname)
	for i,v in ipairs(skywars["HotbarController"]:getHotbarItems()) do
		if v.Type == itemname then
			local item = skywars["ItemTable"][v.Type]
			if item then
				return item, v
			end
		end
	end
	return nil, nil
end

local function getBlock()
	for i,v in ipairs(skywars["HotbarController"]:getHotbarItems()) do
		local item = skywars["ItemTable"][v.Type]
		if item.Block then
			return item, v
		end
	end
	return nil, nil
end

local function getHeldItem()
	local item = skywars["HotbarController"]:getHeldItemInfo()
	return item, item and item.Name or nil
end

local function equipItem(itemnam)
	skywars["EventHandler"][skywars["Events"].HotbarController.updateActiveItem[1]]:fire(itemnam)
end

GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
runcode(function()
	local oldenable
	local olddisable
	local blockplacetable = {}
	local blockplaceenabled = false
	local autoclickercps = {["GetRandomValue"] = function() return 1 end}
	local autoclicker = {["Enabled"] = false}
	local autoclickertick = tick()
	local autoclickerautoblock = {["Enabled"] = false}
	local autoclickerblocks = {["Enabled"] = false}
	local autoclickermousedown = false
	local autoclickerconnection1
	local autoclickerconnection2
	local firstclick = false
	autoclicker = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoClicker",
		["Function"] = function(callback)
			if callback then
				autoclickerconnection1 = uis.InputBegan:connect(function(input, gameProcessed)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = true
						firstclick = true
					end
				end)
				autoclickerconnection2 = uis.InputEnded:connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = false
					end
				end)
				BindToRenderStep("AutoClicker", 1, function() 
			
					if isAlive() and autoclickermousedown and autoclickertick <= tick() and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false then
						autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]())
						if skywars["HotbarController"]:getHeldItemInfo() and skywars["HotbarController"]:getHeldItemInfo().Melee then
							skywars["MeleeController"]:strike({
								UserInputType = Enum.UserInputType.MouseButton1
							})
						end
					end
				end)
			else
				oldenable = nil
				olddisable = nil
				if autoclickerconnection1 then
					autoclickerconnection1:Disconnect()
				end
				if autoclickerconnection2 then
					autoclickerconnection2:Disconnect()
				end
				UnbindFromRenderStep("AutoClicker")
			end
		end,
		["HoverText"] = "Hold attack button to automatically click"
	})
	autoclickercps = autoclicker.CreateTwoSlider({
		["Name"] = "CPS",
		["Min"] = 1,
		["Max"] = 20,
		["Function"] = function(val) end,
		["Default"] = 8,
		["Default2"] = 12
	})
end)

local killauranear
local Killaura = {["Enabled"] = false}
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
local Scaffold = {["Enabled"] = false}
runcode(function()
	local speedval = {["Value"] = 1}
	local speedjump = {["Enabled"] = false}
	local speedjumpheight = {["Value"] = 20}
	local speedjumpalways = {["Enabled"] = false}
	local bodyvelo
	speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed",
		["Function"] = function(callback)
			if callback then
				BindToStepped("Speed", 1, function(time, delta)
					if isAlive() and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) then
						local jumpcheck = speedjump["Enabled"] and killauranear and Killaura["Enabled"] and (not Scaffold["Enabled"])
						if (bodyvelo == nil or bodyvelo ~= nil and bodyvelo.Parent ~= lplr.Character.HumanoidRootPart) then
							bodyvelo = Instance.new("BodyVelocity")
							bodyvelo.Parent = lplr.Character.HumanoidRootPart
							bodyvelo.MaxForce = Vector3.new(100000, 0, 100000)
						else
							bodyvelo.MaxForce = Vector3.new(100000, 0, 100000)
							bodyvelo.Velocity = lplr.Character.Humanoid.MoveDirection * speedval["Value"]
						end
						if (speedjumpalways["Enabled"] and (not Scaffold["Enabled"]) or jumpcheck) then
							if (lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air) and lplr.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, speedjumpheight["Value"], lplr.Character.HumanoidRootPart.Velocity.Z)
							end
						end
					end
				end)
			else
				if bodyvelo then
					bodyvelo:Remove()
				end
				UnbindFromStepped("Speed")
			end
		end, 
		["HoverText"] = "Increases your movement."
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 150,
		["Function"] = function(val) end,
		["Default"] = 150
	})
	speedjumpheight = speed.CreateSlider({
		["Name"] = "Jump Height",
		["Min"] = 0,
		["Max"] = 30,
		["Default"] = 25,
		["Function"] = function() end
	})
	speedjump = speed.CreateToggle({
		["Name"] = "AutoJump", 
		["Function"] = function(callback) 
			if speedjumpalways["Object"] then
				speedjump["Object"].ToggleArrow.Visible = callback
				speedjumpalways["Object"].Visible = callback
			end
		end,
		["Default"] = true
	})
	speedjumpalways = speed.CreateToggle({
		["Name"] = "Always Jump",
		["Function"] = function() end
	})
	speedjumpalways["Object"].BackgroundTransparency = 0
	speedjumpalways["Object"].BorderSizePixel = 0
	speedjumpalways["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	speedjumpalways["Object"].Visible = speedjump["Enabled"]
end)

GuiLibrary["RemoveObject"]("KillauraOptionsButton")
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
runcode(function()
	local killaurabox = Instance.new("BoxHandleAdornment")
    killaurabox.Transparency = 0.5
    killaurabox.Color3 = Color3.new(1, 0, 0)
    killaurabox.Adornee = nil
    killaurabox.AlwaysOnTop = true
	killaurabox.Size = Vector3.new(3, 6, 3)
    killaurabox.ZIndex = 11
    killaurabox.Parent = GuiLibrary["MainGui"]
	local killauratargetframe = {["Players"] = {["Enabled"] = false}}
    local killauramethod = {["Value"] = "Normal"}
	local killauraothermethod = {["Value"] = "Normal"}
    local killauraanimmethod = {["Value"] = "Normal"}
    local killauraaps = {["GetRandomValue"] = function() return 1 end}
    local killaurarange = {["Value"] = 14}
    local killauraangle = {["Value"] = 360}
    local killauratargets = {["Value"] = 10}
    local killauramouse = {["Enabled"] = false}
    local killauraautoblock = {["Enabled"] = false}
    local killauragui = {["Enabled"] = false}
    local killauratarget = {["Enabled"] = false}
    local killaurasound = {["Enabled"] = false}
    local killauraswing = {["Enabled"] = false}
    local killaurahandcheck = {["Enabled"] = false}
    local killaurabaguette = {["Enabled"] = false}
    local killauraanimation = {["Enabled"] = false}
	local killauradelay = tick()
	Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Killaura",
		["Function"] = function(callback)
			if callback then
				BindToStepped("Killaura", 1, function()
					local plrs = GetAllNearestHumanoidToPosition(killauratargetframe["Players"]["Enabled"], killaurarange["Value"] + 0.5, killauratargets["Value"])
					local handcheck = (killaurahandcheck["Enabled"] and skywars["HotbarController"]:getHeldItemInfo() and skywars["HotbarController"]:getHeldItemInfo().Melee or (not killaurahandcheck["Enabled"]))
					targetinfo.Targets.Killaura = nil
					for i,plr in pairs(plrs) do
						if handcheck then
							targetinfo.Targets.Killaura = {
								Player = plr,
								Humanoid = {
									Health = (skywars["HealthController"]:getHealth(plr) or 100),
									MaxHealth = 100
								}
							}
						end
					end
					if killauratarget["Enabled"] and #plrs > 0 and handcheck then
						killaurabox.Adornee = (killauratarget["Enabled"] and plrs[#plrs].Character or nil)
					else
						killaurabox.Adornee = nil
					end
					if killauradelay <= tick() and (killauramouse["Enabled"] and uis:IsMouseButtonPressed(0) or (not killauramouse["Enabled"])) and handcheck then
						local sword = getSword()
						if (not killauraswing["Enabled"]) and #plrs > 0 and handcheck then
							skywars["MeleeController"]:playAnimation(sword)
						end
						local olditem, olditemname = getHeldItem()
						killauranear = #plrs > 0
						if sword then
							for i,plr in pairs(plrs) do
								equipItem(sword.Name)
								skywars["EventHandler"][skywars["Events"].MeleeController.strikeDesktop[1]]:fire(plr)
								equipItem(olditemname)
							end
						end
						killauradelay = tick() + 0.3
					end
				end)
			else
				UnbindFromStepped("Killaura")
				targetinfo.Targets.Killaura = nil
			end
		end
	})
	killauratargetframe = Killaura.CreateTargetWindow({})
    killauraaps = Killaura.CreateTwoSlider({
        ["Name"] = "Attacks per Second",
        ["Min"] = 1,
        ["Max"] = 10,
        ["Function"] = function(val) end, 
        ["Default"] = 8,
        ["Default2"] = 10
    })
    killaurarange = Killaura.CreateSlider({
        ["Name"] = "Attack range",
        ["Min"] = 1,
        ["Max"] = 13,
        ["Function"] = function(val) end, 
        ["Default"] = 13
    })
    killauraangle = Killaura.CreateSlider({
        ["Name"] = "Max angle",
        ["Min"] = 1,
        ["Max"] = 360,
        ["Function"] = function(val) end,
        ["Default"] = 360
    })
    killauratargets = Killaura.CreateSlider({
        ["Name"] = "Max targets",
        ["Min"] = 1,
        ["Max"] = 10,
        ["Function"] = function(val) end,
        ["Default"] = 10
    })
	killauramouse = Killaura.CreateToggle({
        ["Name"] = "Require mouse down",
        ["Function"] = function() end,
		["HoverText"] = "Only attacks when left click is held.",
        ["Default"] = false
    })
	killauragui = Killaura.CreateToggle({
        ["Name"] = "GUI Check",
        ["Function"] = function() end,
		["HoverText"] = "Attacks when you are not in a GUI."
    })
	killauratarget = Killaura.CreateToggle({
        ["Name"] = "Show target",
        ["Function"] = function() end,
		["HoverText"] = "Shows a red box over the opponent."
    })
	killauraswing = Killaura.CreateToggle({
        ["Name"] = "No Swing",
        ["Function"] = function() end,
		["HoverText"] = "Removes the swinging animation."
    })
    killaurahandcheck = Killaura.CreateToggle({
        ["Name"] = "Limit to items",
        ["Function"] = function() end,
		["HoverText"] = "Only attacks when your sword is held."
    })
end)

runcode(function()
	local predictedBlocks = {}
	connectionstodisconnect[#connectionstodisconnect + 1] = skywars["EventHandler"][skywars["Events"].BlockController.bindControls[1]]:connect(function(block)
		local realblock = predictedBlocks[block]
		if not realblock then
			return nil
		end
		predictedBlocks[block] = nil
		realblock:Destroy()
	end)
	local scaffoldtext = Instance.new("TextLabel")
	scaffoldtext.Font = Enum.Font.SourceSans
	scaffoldtext.TextSize = 20
	scaffoldtext.BackgroundTransparency = 1
	scaffoldtext.TextColor3 = Color3.fromRGB(255, 0, 0)
	scaffoldtext.Size = UDim2.new(0, 0, 0, 0)
	scaffoldtext.Position = UDim2.new(0.5, 0, 0.5, 30)
	scaffoldtext.Text = "0"
	scaffoldtext.Visible = false
	scaffoldtext.Parent = GuiLibrary["MainGui"]
	local ScaffoldExpand = {["Value"] = 1}
	local ScaffoldDiagonal = {["Enabled"] = false}
	local ScaffoldTower = {["Enabled"] = false}
	local ScaffoldDownwards = {["Enabled"] = false}
	local ScaffoldStopMotion = {["Enabled"] = false}
	local ScaffoldBlockCount = {["Enabled"] = false}
	local ScaffoldHandCheck = {["Enabled"] = false}
	local scaffoldstopmotionval = false
	local scaffoldallowed = true
	local scaffoldposcheck = tick()
	local scaffoldstopmotionpos = Vector3.new(0, 0, 0)
	local oldpos
	local olditem
	local Scaffold = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Scaffold",
		["Function"] = function(callback)
			if callback then
				scaffoldtext.Visible = ScaffoldBlockCount["Enabled"]
				BindToStepped("Scaffold", 1, function()
					local helditem = skywars["HotbarController"]:getHeldItemInfo()
					local handcheck = (ScaffoldHandCheck["Enabled"] and helditem and helditem.Block or (not ScaffoldHandCheck["Enabled"]))
					local block, otherblock = getBlock()
					if helditem and helditem.Block then
						block, otherblock = getItem(helditem.Name)
					end

					if block and isAlive() and handcheck then
						if uis:IsKeyDown(Enum.KeyCode.Space) then
							if scaffoldstopmotionval == false then
								scaffoldstopmotionval = true
								scaffoldstopmotionpos = lplr.Character.HumanoidRootPart.CFrame.p
							end
						else
							scaffoldstopmotionval = false
						end
						local woolamount = otherblock.Quantity
						scaffoldtext.Text = (woolamount and tostring(woolamount) or "0")
						if woolamount then
							if woolamount >= 128 then
								scaffoldtext.TextColor3 = Color3.fromRGB(9, 255, 198)
							elseif woolamount >= 64 then
								scaffoldtext.TextColor3 = Color3.fromRGB(255, 249, 18)
							else
								scaffoldtext.TextColor3 = Color3.fromRGB(255, 0, 0)
							end
						end
						if ScaffoldTower["Enabled"] and uis:IsKeyDown(Enum.KeyCode.Space) and uis:GetFocusedTextBox() == nil then
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
							if ScaffoldStopMotion["Enabled"] and scaffoldstopmotionval then
								lplr.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(scaffoldstopmotionpos.X, lplr.Character.HumanoidRootPart.CFrame.p.Y, scaffoldstopmotionpos.Z))
							end
						end
						for i = 1, ScaffoldExpand["Value"] do
							local newpos = getScaffold((lplr.Character.Head.Position + ((scaffoldstopmotionval == false and lplr.Character.Humanoid.MoveDirection or Vector3.new(0, 0, 0)) * (i * 3.5))) + Vector3.new(0, -math.floor(lplr.Character.Humanoid.HipHeight * (uis:IsKeyDown(Enum.KeyCode.LeftShift) and ScaffoldDownwards["Enabled"] and 5 or 3) * (lplr.Character:GetAttribute("Transparency") and 1.1 or 1)), 0), ScaffoldDiagonal["Enabled"] and (lplr.Character.HumanoidRootPart.Velocity.Y < 2))
							newpos = Vector3.new(newpos.X, math.clamp(newpos.Y - (uis:IsKeyDown(Enum.KeyCode.Space) and ScaffoldTower["Enabled"] and 4 or 0), -999, 999), newpos.Z)
							if newpos ~= oldpos then
								if not skywars["BlockUtil"].canPlace(newpos) then
									return nil
								end
								local olditem, olditemname = getHeldItem()
								equipItem(block.Name)
								local v18 = block.Block.Ref:Clone();
								v18.Position = newpos;
								v18.Parent = workspace.BlockContainer;
								predictedBlocks[newpos] = v18
								skywars["EventHandler"][skywars["Events"].BlockController.placeBlock[1]](newpos, game:GetService("HttpService"):GenerateGUID(false))
								equipItem(olditemname)
								oldpos = newpos
							end
						end
					end
				end)
			else
				UnbindFromStepped("Scaffold")
				olditem = nil
				scaffoldtext.Visible = false
			end
		end
	})
	ScaffoldExpand = Scaffold.CreateSlider({
		["Name"] = "Expand",
		["Min"] = 1,
		["Max"] = 8,
		["Function"] = function(val) end,
		["Default"] = 1,
		["HoverText"] = "Build range"
	})
	ScaffoldDiagonal = Scaffold.CreateToggle({
		["Name"] = "Diagonal", 
		["Function"] = function(callback) end,
		["Default"] = true
	})
	ScaffoldTower = Scaffold.CreateToggle({
		["Name"] = "Tower", 
		["Function"] = function(callback) 
			if ScaffoldStopMotion["Object"] then
				ScaffoldTower["Object"].ToggleArrow.Visible = callback
				ScaffoldStopMotion["Object"].Visible = callback
			end
		end
	})
	ScaffoldDownwards  = Scaffold.CreateToggle({
		["Name"] = "Downwards", 
		["Function"] = function(callback) end,
		["HoverText"] = "Goes down when left shift is held."
	})
	ScaffoldStopMotion = Scaffold.CreateToggle({
		["Name"] = "Stop Motion",
		["Function"] = function() end,
		["HoverText"] = "Stops your movement when going up"
	})
	ScaffoldStopMotion["Object"].BackgroundTransparency = 0
	ScaffoldStopMotion["Object"].BorderSizePixel = 0
	ScaffoldStopMotion["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ScaffoldStopMotion["Object"].Visible = ScaffoldTower["Enabled"]
	ScaffoldBlockCount = Scaffold.CreateToggle({
		["Name"] = "Block Count",
		["Function"] = function(callback) 
			if Scaffold["Enabled"] then
				scaffoldtext.Visible = callback 
			end
		end,
		["HoverText"] = "Shows the amount of blocks in the middle."
	})
	ScaffoldHandCheck = Scaffold.CreateToggle({
		["Name"] = "Whitelist Only",
		["Function"] = function() end,
		["HoverText"] = "Only builds with blocks in your hand."
	})
end)

runcode(function()
	local ChestOpen
	local ChestStealer = {["Enabled"] = false}
	local ChestBlacklist = {}
	ChestStealer = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ChestStealer",
		["Function"] = function(callback)
			if callback then
				ChestOpen = skywars["EventHandler"][skywars["Events"].ChestController.onStart[1]]:connect(function(one, two, three)
					if ChestBlacklist[one] == nil then
						ChestBlacklist[one] = true
						for i,v in pairs(two) do
							skywars["EventHandler"][skywars["Events"].ChestController.updateChest[1]](one, v.Type, -v.Quantity)
						end
						skywars["EventHandler"][skywars["Events"].ChestController.closeChest[1]](one)
					end
				end)
				spawn(function()
					repeat
						task.wait(0.3)
						if isAlive() then
							for i,v in pairs(workspace.BlockContainer.Map.Chests:GetChildren()) do
								if v.PrimaryPart then
									if (lplr.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude <= 10 and ChestBlacklist[v] == nil then
										skywars["EventHandler"][skywars["Events"].ChestController.openChest[1]](v)
									end
								end
							end
						end
					until (not ChestStealer["Enabled"])
				end)
			else
				if ChestOpen then
					ChestOpen:Disconnect()
				end
			end
		end
	})

	local DropStealer = {["Enabled"] = false}
	DropStealer = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "DropStealer",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.2)
						if isAlive() then
							for i,v in pairs(workspace:GetChildren()) do
								if v.Name == "Handle" then
									firetouchinterest(lplr.Character.HumanoidRootPart, workspace.Handle, 1)
									firetouchinterest(lplr.Character.HumanoidRootPart, workspace.Handle, 0)
								end
							end
						end
					until (not DropStealer["Enabled"])
				end)
			end
		end
	})
end)

runcode(function()
	local AutoReport = {["Enabled"] = false}
	local oldplr 
	AutoReport = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoReport",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.2 + (math.random(1, 10) / 10))
						local plr
						repeat task.wait() plr = game.Players:GetChildren()[math.random(1, #game.Players:GetChildren())] until plr ~= oldplr and plr ~= lplr
						skywars["EventHandler"][skywars["Events"].ReportController.submitReport[1]]:fire(plr.UserId)
					until (not AutoReport["Enabled"])
				end)
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("FlyOptionsButton")
local flymissile
runcode(function()
	local OldNoFallFunction
	local flyspeed = {["Value"] = 40}
	local flyverticalspeed = {["Value"] = 40}
	local flyupanddown = {["Enabled"] = true}
	local flypop = {["Enabled"] = true}
	local olddeflate
	local flyposy = 0
	local flyrequests = 0
	local flytime = 60
	local flylimit = false
	local flyup = false
	local flydown = false
	local tnttimer = 0
	local flypress
	local flyendpress

	fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Fly",
		["Function"] = function(callback)
			if callback then
				if isAlive() then
					spawn(function()
						flyposy = lplr.Character.HumanoidRootPart.Position.Y
						repeat task.wait() flyposy = lplr.Character.HumanoidRootPart.Position.Y until flyposy == lplr.Character.HumanoidRootPart.Position.Y
					end)
				end
				flypress = game:GetService("UserInputService").InputBegan:connect(function(input1)
					if flyupanddown["Enabled"] and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space then
							flyup = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift then
							flydown = true
						end
					end
				end)
				flyendpress = game:GetService("UserInputService").InputEnded:connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space then
						flyup = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift then
						flydown = false
					end
				end)
				if isAlive() then
					flyposy = lplr.Character.HumanoidRootPart.Position.Y
				end
				BindToStepped("Fly", 1, function(time, delta) 
					if isAlive() and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) then
						if flyup then
							flyposy = flyposy + (1 * ((flyverticalspeed["Value"] - 16) * delta)) * 1
						end
						if flydown then
							flyposy = flyposy - (1 * ((flyverticalspeed["Value"] - 16) * delta)) * 1
						end
						local flypos = (lplr.Character.Humanoid.MoveDirection * (math.clamp(flyspeed["Value"] - 16, 1, 150) * delta)) * 1
						lplr.Character.HumanoidRootPart.Transparency = 1
						lplr.Character.HumanoidRootPart.CFrame = addvectortocframe(lplr.Character.HumanoidRootPart.CFrame, Vector3.new(flypos.X, (flyposy - lplr.Character.HumanoidRootPart.CFrame.p.Y), flypos.Z))
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
					end
				end)
			else
				flyup = false
				flydown = false
				flypress:Disconnect()
				flyendpress:Disconnect()
				UnbindFromStepped("Fly")
				olddeflate = nil
			end
		end,
		["HoverText"] = "Makes you go zoom (Balloons or TNT Required)"
	})
	flyspeed = fly.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 150,
		["Function"] = function(val) end, 
		["Default"] = 100
	})
	flyverticalspeed = fly.CreateSlider({
		["Name"] = "Vertical Speed",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) end, 
		["Default"] = 44
	})
	flyupanddown = fly.CreateToggle({
		["Name"] = "Y Level",
		["Function"] = function() end, 
		["Default"] = true
	})
end)

GuiLibrary["RemoveObject"]("ESPOptionsButton")
runcode(function()
	local ESPFolder = Instance.new("Folder")
	ESPFolder.Name = "ESPFolder"
	ESPFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
		if ESPFolder:FindFirstChild(plr.Name) then
			ESPFolder[plr.Name]:Remove()
		end
	end)
	local ESPColor = {["Value"] = 0.44}
	local ESPHealthBar = {["Enabled"] = false}
	local ESPMethod = {["Value"] = "2D"}
	local ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ESP", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("ESP", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						if ESPMethod["Value"] == "2D" then
							local thing
							if ESPFolder:FindFirstChild(plr.Name) then
								thing = ESPFolder[plr.Name]
								thing.Visible = false
								thing.Line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								thing.Line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								thing.Line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								thing.Line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
							else
								thing = Instance.new("Frame")
								thing.BackgroundTransparency = 1
								thing.BorderSizePixel = 0
								thing.Visible = false
								thing.Name = plr.Name
								thing.Parent = ESPFolder
								local line1 = Instance.new("Frame")
								line1.BorderSizePixel = 0
								line1.Name = "Line1"
								line1.ZIndex = 2
								line1.Size = UDim2.new(1, -2, 0, 1)
								line1.Position = UDim2.new(0, 1, 0, 1)
								line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								line1.Parent = thing
								local line2 = Instance.new("Frame")
								line2.BorderSizePixel = 0
								line2.Name = "Line2"
								line2.Size = UDim2.new(1, -2, 0, 1)
								line2.ZIndex = 2
								line2.Position = UDim2.new(0, 1, 1, -2)
								line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								line2.Parent = thing
								local line3 = Instance.new("Frame")
								line3.BorderSizePixel = 0
								line3.Name = "Line3"
								line3.Size = UDim2.new(0, 1, 1, -2)
								line3.Position = UDim2.new(0, 1, 0, 1)
								line3.ZIndex = 2
								line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								line3.Parent = thing
								local line4 = Instance.new("Frame")
								line4.BorderSizePixel = 0
								line4.Name = "Line4"
								line4.Size = UDim2.new(0, 1, 1, -2)
								line4.Position = UDim2.new(1, -2, 0, 1)
								line4.ZIndex = 2
								line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								line4.Parent = thing
								local line1clone = line1:Clone()
								line1clone.ZIndex = 1
								line1clone.Size = UDim2.new(1, 0, 0, 3)
								line1clone.BackgroundTransparency = 0.5
								line1clone.Position = UDim2.new(0, 0, 0, 0)
								line1clone.BackgroundColor3 = Color3.new(0, 0, 0)
								line1clone.Parent = thing
								local line2clone = line2:Clone()
								line2clone.ZIndex = 1
								line2clone.Size = UDim2.new(1, 0, 0, 3)
								line2clone.BackgroundTransparency = 0.5
								line2clone.Position = UDim2.new(0, 0, 1, -3)
								line2clone.BackgroundColor3 = Color3.new(0, 0, 0)
								line2clone.Parent = thing
								local line3clone = line3:Clone()
								line3clone.ZIndex = 1
								line3clone.Size = UDim2.new(0, 3, 1, 0)
								line3clone.BackgroundTransparency = 0.5
								line3clone.Position = UDim2.new(0, 0, 0, 0)
								line3clone.BackgroundColor3 = Color3.new(0, 0, 0)
								line3clone.Parent = thing
								local line4clone = line4:Clone()
								line4clone.ZIndex = 1
								line4clone.Size = UDim2.new(0, 3, 1, 0)
								line4clone.BackgroundTransparency = 0.5
								line4clone.Position = UDim2.new(1, -3, 0, 0)
								line4clone.BackgroundColor3 = Color3.new(0, 0, 0)
								line4clone.Parent = thing
								local healthline = Instance.new("Frame")
								healthline.BorderSizePixel = 0
								healthline.Name = "HealthLineMain"
								healthline.ZIndex = 2
								healthline.AnchorPoint = Vector2.new(0, 1)
								healthline.Visible = ESPHealthBar["Enabled"]
								healthline.Size = UDim2.new(0, 1, 1, -2)
								healthline.Position = UDim2.new(0, -4, 1, -1)
								healthline.BackgroundColor3 = Color3.new(0, 1, 0)
								healthline.Parent = thing
								local healthlineclone = healthline:Clone()
								healthlineclone.ZIndex = 1
								healthlineclone.AnchorPoint = Vector2.new(0, 0)
								healthlineclone.Size = UDim2.new(0, 3, 1, 0)
								healthlineclone.BackgroundTransparency = 0.5
								healthlineclone.Visible = ESPHealthBar["Enabled"]
								healthlineclone.Name = "HealthLineBKG"
								healthlineclone.Position = UDim2.new(0, -5, 0, 0)
								healthlineclone.BackgroundColor3 = Color3.new(0, 0, 0)
								healthlineclone.Parent = thing
							end
							
							if isAlive(plr) and plr ~= lplr then
								local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
								local rootSize = (plr.Character.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
								local headPos, headVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
								local legPos, legVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
								rootPos = rootPos
								if rootVis then
									if ESPHealthBar["Enabled"] then
										local color = HealthbarColorTransferFunction((skywars["HealthController"]:getHealth(plr) or 100) / 100)
										thing.HealthLineMain.BackgroundColor3 = color
										thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp((skywars["HealthController"]:getHealth(plr) or 100) / 100, 0, 1), (math.clamp((skywars["HealthController"]:getHealth(plr) or 100) / 100, 0, 1) == 0 and 0 or -2))
									end
									thing.Visible = rootVis
									thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
									thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
								end
							end
						end
						if ESPMethod["Value"] == "Skeleton" then
							local thing
							if ESPFolder:FindFirstChild(plr.Name) then
								thing = ESPFolder[plr.Name]
								thing.Visible = false
								for linenum, line in pairs(thing:GetChildren()) do
									line.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								end
							else
								thing = Instance.new("Frame")
								thing.BackgroundTransparency = 1
								thing.BorderSizePixel = 0
								thing.Visible = false
								thing.Name = plr.Name
								thing.Parent = ESPFolder
								local line1 = Instance.new("Frame")
								line1.BorderSizePixel = 0
								line1.Name = "TopTorsoLine"
								line1.AnchorPoint = Vector2.new(0.5, 0.5)
								line1.ZIndex = 2
								line1.Size = UDim2.new(0, 0, 0, 0)
								line1.Position = UDim2.new(0, 0, 0, 0)
								line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
								line1.Parent = thing
								local line2 = line1:Clone()
								line2.Name = "MiddleTorsoLine"
								line2.Parent = thing
								local line3 = line1:Clone()
								line3.Name = "BottomTorsoLine"
								line3.Parent = thing
								local line4 = line1:Clone()
								line4.Name = "LeftArm"
								line4.Parent = thing
								local line5 = line1:Clone()
								line5.Name = "RightArm"
								line5.Parent = thing
								local line6 = line1:Clone()
								line6.Name = "LeftLeg"
								line6.Parent = thing
								local line7 = line1:Clone()
								line7.Name = "RightLeg"
								line7.Parent = thing
								local line8 = line1:Clone()
								line8.Name = "Head"
								line8.Parent = thing
								local line9 = line1:Clone()
								line9.Name = "HeadForward"
								line9.Parent = thing
							end
							
							if isAlive(plr) and plr ~= lplr then
								local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
								if rootVis and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")) and plr.Character:FindFirstChild((plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")) and plr.Character:FindFirstChild("Head") then
									thing.Visible = true
									local head = CalculateObjectPosition((plr.Character["Head"].CFrame).p)
									local headfront = CalculateObjectPosition((plr.Character["Head"].CFrame * CFrame.new(0, 0, -0.5)).p)
									local toplefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 1, 0)).p)
									local toprighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 1, 0)).p)
									local toptorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 1, 0)).p)
									local bottomtorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -1, 0)).p)
									local bottomlefttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -1, 0)).p)
									local bottomrighttorso = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -1, 0)).p)
									local leftarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
									local rightarm = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
									local leftleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
									local rightleg = CalculateObjectPosition((plr.Character[(plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
									CalculateLine(toplefttorso, toprighttorso, thing.TopTorsoLine)
									CalculateLine(toptorso, bottomtorso, thing.MiddleTorsoLine)
									CalculateLine(bottomlefttorso, bottomrighttorso, thing.BottomTorsoLine)
									CalculateLine(toplefttorso, leftarm, thing.LeftArm)
									CalculateLine(toprighttorso, rightarm, thing.RightArm)
									CalculateLine(bottomlefttorso, leftleg, thing.LeftLeg)
									CalculateLine(bottomrighttorso, rightleg, thing.RightLeg)
									CalculateLine(toptorso, head, thing.Head)
									CalculateLine(head, headfront, thing.HeadForward)
								end
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("ESP") 
				ESPFolder:ClearAllChildren()
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPColor = ESP.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	ESPMethod = ESP.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"2D", "Skeleton"},
		["Function"] = function(val)
			ESPFolder:ClearAllChildren()
			ESPHealthBar["Object"].Visible = (val == "2D")
		end,
	})
	ESPHealthBar = ESP.CreateToggle({
		["Name"] = "Health Bar", 
		["Function"] = function(callback)
			if callback then 
				for i,v in pairs(ESPFolder:GetChildren()) do
					v.HealthLineMain.Visible = true
					v.HealthLineBKG.Visible = true
				end
			else
				for i,v in pairs(ESPFolder:GetChildren()) do
					v.HealthLineMain.Visible = false
					v.HealthLineBKG.Visible = false
				end
			end
		end
	})
end)
GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
runcode(function()
	local healthColorToPosition = {
		[Vector3.new(Color3.fromRGB(255, 28, 0).r,
	  Color3.fromRGB(255, 28, 0).g,
	  Color3.fromRGB(255, 28, 0).b)] = 0.1;
		[Vector3.new(Color3.fromRGB(250, 235, 0).r,
	  Color3.fromRGB(250, 235, 0).g,
	  Color3.fromRGB(250, 235, 0).b)] = 0.5;
		[Vector3.new(Color3.fromRGB(27, 252, 107).r,
	  Color3.fromRGB(27, 252, 107).g,
	  Color3.fromRGB(27, 252, 107).b)] = 0.8;
	}
	local min = 0.1
	local minColor = Color3.fromRGB(255, 28, 0)
	local max = 0.8
	local maxColor = Color3.fromRGB(27, 252, 107)
	
	local function HealthbarColorTransferFunction(healthPercent)
		if healthPercent < min then
			return minColor
		elseif healthPercent > max then
			return maxColor
		end
	
	
		local numeratorSum = Vector3.new(0,0,0)
		local denominatorSum = 0
		for colorSampleValue, samplePoint in pairs(healthColorToPosition) do
			local distance = healthPercent - samplePoint
			if distance == 0 then
				
				return Color3.new(colorSampleValue.x, colorSampleValue.y, colorSampleValue.z)
			else
				local wi = 1 / (distance*distance)
				numeratorSum = numeratorSum + wi * colorSampleValue
				denominatorSum = denominatorSum + wi
			end
		end
		local result = numeratorSum / denominatorSum
		return Color3.new(result.x, result.y, result.z)
	end

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
		if NameTagsFolder:FindFirstChild(plr.Name) then
			NameTagsFolder[plr.Name]:Remove()
		end
	end)
	local NameTagsColor = {["Value"] = 0.44}
	local NameTagsDisplayName = {["Enabled"] = false}
	local NameTagsHealth = {["Enabled"] = false}
	local NameTagsDistance = {["Enabled"] = false}
	local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameTags", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("NameTags", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if NameTagsFolder:FindFirstChild(plr.Name) then
							thing = NameTagsFolder[plr.Name]
							thing.Visible = false
						else
							thing = Instance.new("TextLabel")
							thing.BackgroundTransparency = 0.5
							thing.BackgroundColor3 = Color3.new(0, 0, 0)
							thing.BorderSizePixel = 0
							thing.Visible = false
							thing.RichText = true
							thing.Name = plr.Name
							thing.Font = Enum.Font.SourceSans
							thing.TextSize = 14
							if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
								local rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
								if NameTagsHealth["Enabled"] then
									rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name).." "..math.floor((skywars["HealthController"]:getHealth(plr) or 100))
								end
								local color = HealthbarColorTransferFunction((skywars["HealthController"]:getHealth(plr) or 100) / 100)
								local modifiedText = (NameTagsDistance["Enabled"] and isAlive() and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor((skywars["HealthController"]:getHealth(plr) or 100)).."</font>" or '')
								local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
								thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
								thing.Text = modifiedText
							else
								local nametagSize = game:GetService("TextService"):GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
								thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
								thing.Text = plr.Name
							end
							thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
							thing.Parent = NameTagsFolder
						end
						
						if isAlive(plr) and plr ~= lplr then
							local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, plr.Character.Head.Size.Y + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
							headPos = headPos
							
							if headVis then
								local rawText = (NameTagsDistance["Enabled"] and isAlive() and "["..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor((skywars["HealthController"]:getHealth(plr) or 100)) or "")
								local color = HealthbarColorTransferFunction((skywars["HealthController"]:getHealth(plr) or 100) / 100)
								local modifiedText = (NameTagsDistance["Enabled"] and isAlive() and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor((skywars["HealthController"]:getHealth(plr) or 100)).."</font>" or '')
								local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
								thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
								thing.Text = modifiedText
								thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
								thing.Visible = headVis
								thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("NameTags")
				NameTagsFolder:ClearAllChildren()
			end
		end,
		["HoverText"] = "Renders nametags on entities through walls."
	})
	NameTagsColor = NameTags.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		["Name"] = "Use Display Name", 
		["Function"] = function() end
	})
	NameTagsHealth = NameTags.CreateToggle({
		["Name"] = "Health", 
		["Function"] = function() end
	})
	NameTagsDistance = NameTags.CreateToggle({
		["Name"] = "Distance", 
		["Function"] = function() end
	})
end)

runcode(function()
	local AutoToxic = {["Enabled"] = false}
	local AutoToxicGG = {["Enabled"] = false}
	local AutoToxicWin = {["Enabled"] = false}
	local AutoToxicDeath = {["Enabled"] = false}
	local AutoToxicRespond = {["Enabled"] = false}
	local AutoToxicFinalKill = {["Enabled"] = false}
	local AutoToxicTeam = {["Enabled"] = false}
	local AutoToxicPhrases = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local AutoToxicPhrases2 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local AutoToxicPhrases3 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local AutoToxicPhrases4 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local AutoToxicPhrases5 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
	local victorysaid = false
	local responddelay = false
	local lastsaid = ""
	local lastsaid2 = ""
	local ignoredplayers = {}

	local function toxicfindstr(str, tab)
		if tab then
			for i,v in pairs(tab) do
				if str:lower():find(v) then
					return true
				end
			end
		end
		return false
	end

	skywars["EventHandler"][skywars["Events"].GameController.onStart[2]]:connect(function(winstuff)
		local v14 = winstuff and winstuff.placements and #winstuff.placements > 0 and winstuff.placements[1] or nil;
		if v14 == lplr and victorysaid == false then
			victorysaid = true
			if AutoToxic["Enabled"] then
				if AutoToxicGG["Enabled"] then
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("gg", "All")
					if shared.ggfunction then
						shared.ggfunction()
					end
				end
				if AutoToxicWin["Enabled"] then
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(#AutoToxicPhrases["ObjectList"] > 0 and AutoToxicPhrases["ObjectList"][math.random(1, #AutoToxicPhrases["ObjectList"])] or "EZ L TRASH KIDS", "All")
				end
			end
		end
	end)

	chatconnection = textChatService.MessageReceived:Connect(function(tab)
		local plr = tab.TextSource
		if (#AutoToxicPhrases5["ObjectList"] > 0 and toxicfindstr(tab.Text, AutoToxicPhrases5["ObjectList"]) or #AutoToxicPhrases5["ObjectList"] == 0 and (tab.Text:lower():find("hack") or tab.Text:lower():find("exploit") or tab.Text:lower():find("cheat"))) and plr ~= lplr and table.find(ignoredplayers, plr.UserId) == nil and AutoToxic["Enabled"] and AutoToxicRespond["Enabled"] then
			local custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
			if custommsg == lastsaid2 then
				custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
			else
				lastsaid2 = custommsg
			end
			if custommsg then
				custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
			end
			local msg = custommsg or "waaaa waaaa "..(plr.DisplayName or plr.Name)
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
			table.insert(ignoredplayers, plr.UserId)
		end
	end)

	local justsaid = ""
	local leavesaid = false
		connectionstodisconnect[#connectionstodisconnect + 1] = skywars["EventHandler"][skywars["Events"].GameController.onStart[1]]:connect(function(p7, p8)
			if p7 == lplr and leavesaid == false then
				leavesaid = true
				if AutoToxic["Enabled"] and AutoToxicDeath["Enabled"] then
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(#AutoToxicPhrases3["ObjectList"] > 0 and AutoToxicPhrases3["ObjectList"][math.random(1, #AutoToxicPhrases3["ObjectList"])] or "My gaming chair expired midfight.", "All")
				end
			end
			if AutoToxic["Enabled"] then
				if p8 and p8 == lplr then
					local plr = p7
					if plr and AutoToxicFinalKill["Enabled"] then
						local custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])]
						if custommsg == lastsaid then
							custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])]
						else
							lastsaid = custommsg
						end
						if custommsg then
							custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
						end
						local msg = custommsg or "L "..(plr.DisplayName or plr.Name)
						game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
					end
				end
			end
		end)	

	AutoToxic = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoToxic",
		["Function"] = function() end
	})
	AutoToxicGG = AutoToxic.CreateToggle({
		["Name"] = "AutoGG",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicWin = AutoToxic.CreateToggle({
		["Name"] = "Win",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicDeath = AutoToxic.CreateToggle({
		["Name"] = "Death",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicRespond = AutoToxic.CreateToggle({
		["Name"] = "Respond",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicFinalKill = AutoToxic.CreateToggle({
		["Name"] = "Kill",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicTeam = AutoToxic.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end, 
	})
	AutoToxicPhrases = AutoToxic.CreateTextList({
		["Name"] = "ToxicList",
		["TempText"] = "phrase (win)",
	})
	AutoToxicPhrases2 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList2",
		["TempText"] = "phrase (kill) <name>",
	})
	AutoToxicPhrases3 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList3",
		["TempText"] = "phrase (death)",
	})
	AutoToxicPhrases4 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList4",
		["TempText"] = "phrase (text to respond with) <name>",
	})
	AutoToxicPhrases4["Object"].AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases5 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList5",
		["TempText"] = "phrase (text to respond to)",
	})
	AutoToxicPhrases5["Object"].AddBoxBKG.AddBox.TextSize = 12
end)

runcode(function()
	local NoFall = {["Enabled"] = false}
	local nofallconnection
	local debounce = false
	local pos = CFrame.new(0, 500, 0)
	NoFall = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NoFall",
		["Function"] = function(callback)
			if callback then
				if isAlive() then
					spawn(function()
						repeat
							task.wait()
							if isAlive() and lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
								lplr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
								local ray
								local ray2
								pos = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 70, 0)
								local start = lplr.Character.HumanoidRootPart.CFrame
								ray = nil
								repeat
									task.wait()
									local raycastparameters = RaycastParams.new()
									raycastparameters.FilterDescendantsInstances = {workspace.BlockContainer}
									raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
									ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -lplr.Character.Humanoid.HipHeight, 0), raycastparameters)
								until ray ~= nil
								local oldlanded = (ray and ray.Position and ray.Position + Vector3.new(0, lplr.Character.Humanoid.HipHeight * 2, 0) or lplr.Character.HumanoidRootPart.CFrame.p)
								if (start.p.Y - oldlanded.Y > 10) then
									local flyenabled = GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"]
									if GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] then
										GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["ToggleButton"](false)
									end
									lplr.Character.HumanoidRootPart.CFrame = pos
									task.wait(0.1)
									lplr.Character.HumanoidRootPart.CFrame = CFrame.new(oldlanded, oldlanded + lplr.Character.HumanoidRootPart.CFrame.lookVector)
									lplr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
									lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
									lplr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
									task.wait(0.1)
									lplr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
									if flyenabled and (not GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"]) then
										GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["ToggleButton"](false)
									end
								else
									lplr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
									lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
								end
								task.wait(0.3)
							end
						until (not NoFall["Enabled"])
					end)
					
						--[[if newstate == Enum.HumanoidStateType.Landed and debounce == false then
							debounce = true
							local oldlanded = lplr.Character.HumanoidRootPart.CFrame
							lplr.Character.Humanoid:SetStateEnabled(7, false)
							lplr.Character.Humanoid:ChangeState(4)
							lplr.Character.HumanoidRootPart.CFrame = pos
							task.wait(0.1)
							lplr.Character.Humanoid:SetStateEnabled(7, true)
							lplr.Character.HumanoidRootPart.CFrame = oldlanded
							task.wait(0.1)
							debounce = false
						end]]
				end
			else
				lplr.Character.Humanoid:SetStateEnabled(7, true)
				if nofallconnection then
					nofallconnection:Disconnect()
				end
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("AntiVoidOptionsButton")
runcode(function()
	local antivoidpart
	local antivoidmethod = {["Value"] = "Dynamic"}
	local antivoidnew = {["Enabled"] = false}
	local antivoidnewdelay = {["Value"] = 10}
	local antitransparent = {["Enabled"] = false}
	local AntiVoid = {["Enabled"] = false}
	local lastvalidpos
	AntiVoid = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AntiVoid", 
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until antivoidypos ~= 0
					repeat
						task.wait(0.2)
						if AntiVoid["Enabled"] and isAlive() then
							local raycastparameters = RaycastParams.new()
							raycastparameters.FilterDescendantsInstances = {workspace.BlockContainer, antivoidpart}
							raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
							local newray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), raycastparameters)
							if newray and newray.Instance == antivoidpart then
								
							else
								lastvalidpos = CFrame.new(newray and newray.Position and (newray.Position + Vector3.new(0, lplr.Character.Humanoid.HipHeight * 2, 0)) or lplr.Character.HumanoidRootPart.CFrame.p)
							end
						end
					until AntiVoid["Enabled"] == false
				end)
				spawn(function()
					repeat task.wait() until antivoidypos ~= 0
					antivoidpart = Instance.new("Part")
					antivoidpart.CanCollide = false
					antivoidpart.Size = Vector3.new(10000, 1, 10000)
					antivoidpart.Anchored = true
					antivoidpart.Transparency = (antitransparent["Enabled"] and 1 or 0.5)
					antivoidpart.Position = Vector3.new(0, 0, 0)
					connectionstodisconnect[#connectionstodisconnect + 1] = antivoidpart.Touched:connect(function(touchedpart)
						if touchedpart.Parent == lplr.Character and isAlive() then
							if antivoidnew["Enabled"] then
								lplr.Character.HumanoidRootPart.CFrame = lastvalidpos + Vector3.new(0, 500, 0)
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								task.wait(0.1)
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								task.wait(0.1)
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								task.wait(0.1)
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								lplr.Character.HumanoidRootPart.CFrame = lastvalidpos
							else
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, (antivoidmethod["Value"] == "Dynamic" and math.clamp((math.abs(lplr.Character.HumanoidRootPart.Velocity.Y) + 2), 1, 100) or 100), 0)
							end
						end
					end)
					antivoidpart.Parent = workspace
				end)
			else
				if antivoidpart then
					antivoidpart:Remove() 
				end
			end
		end, 
		["HoverText"] = "Gives you a chance to get on land (Bouncing Twice, abusing, or bad luck will lead to lagbacks)"
	})
	antivoidmethod = AntiVoid.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Dynamic", "Set"},
		["Function"] = function() end
	})
	antivoidnew = AntiVoid.CreateToggle({
		["Name"] = "Lagback Mode",
		["Function"] = function(callback) 
			if antivoidnewdelay["Object"] then
				antivoidnewdelay["Object"].Visible = callback
			end
		end,
		["Default"] = true
	})
	antivoidnewdelay = AntiVoid.CreateSlider({
		["Name"] = "Freeze Delay",
		["Min"] = 6,
		["Max"] = 30,
		["Default"] = 10,
		["Function"] = function() end
	})
	antivoidnewdelay["Object"].Visible = antivoidnew["Enabled"]
	antitransparent = AntiVoid.CreateToggle({
		["Name"] = "Invisible",
		["Function"] = function(callback) 
			if antivoidpart then
				antivoidpart.Transparency = (callback and 1 or 0.5)
			end
		end,
		["Default"] = true
	})
end)

runcode(function()
	local BetterFP = {["Enabled"] = false}
	--assign vars
	local currentfp
	local currentfptool
	local modificationcframe = {CFrame = CFrame.new(0, 0, 0), Remove = function() end}
	local oldswinganim
	local currentlyswinging = false
	BetterFP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({ -- create button
		["Name"] = "BetterFP",
		["Function"] = function(callback)
			if callback then
				modificationcframe = Instance.new("Part") --cool part so we can use tweenservice for animations
				modificationcframe.CFrame = CFrame.new(0, 0, 0)
				modificationcframe.Anchored = true
				oldswinganim = skywars["MeleeController"].playAnimation
				skywars["MeleeController"].playAnimation = function(Self, ...) -- attack anim hook for first person
					if currentlyswinging == false then
						spawn(function()
							currentlyswinging = true
							game:GetService("TweenService"):Create(modificationcframe, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(0, 0, -3) * CFrame.Angles(math.rad(-40), 0, math.rad(-60))}):Play()
							task.wait(0.1)
							game:GetService("TweenService"):Create(modificationcframe, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = CFrame.Angles(0, 0, 0)}):Play()
							task.wait(0.1)
							currentlyswinging = false
						end)
					end
					return oldswinganim(Self, ...)
				end
				BindToRenderStep("BetterFP", 1, function() --renderstep moment
					if lplr.Character then
						local tool = lplr.Character:FindFirstChildWhichIsA("Tool")
						if tool and tool:FindFirstChild("Handle") then
							tool.Handle.LocalTransparencyModifier = ((cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.6 and 1 or 0) --are they in first person, hide ugly tool models :puke:
							for i,v in pairs(tool.Handle:GetChildren()) do
								if v:IsA("Texture") then
									v.Transparency = 1
								end
							end
							if (cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.6 then
								if currentfp ~= tool.Name then
									if currentfptool then
										currentfptool:Remove()
										currentfptool = nil
									end
									local clone = tool.Handle:Clone()
									clone.Parent = cam
									clone.LocalTransparencyModifier = 0
									clone.Anchored = true
									for i,v in pairs(clone:GetChildren()) do
										if v:IsA("Texture") then
											v.Transparency = 0
										end
									end
									currentfptool = clone
									currentfp = tool.Name
								end
							else
								currentfp = nil
								if currentfptool then
									currentfptool:Remove()
									currentfptool = nil
								end
							end
						else
							currentfp = nil
							if currentfptool then
								currentfptool:Remove()
								currentfptool = nil
							end
						end
						if currentfptool then
							currentfptool.LocalTransparencyModifier = 0
							currentfptool.CFrame = (cam.CFrame * (CFrame.new(3, -0.8, -3) * CFrame.Angles(0, math.rad(90), 0) * modificationcframe.CFrame))--clone located at camera
						end
					end
				end)
			else
				UnbindFromRenderStep("BetterFP") -- renderstep moment
				currentfp = nil
				if currentfptool then
					currentfptool:Remove()
				end
				if modificationcframe then
					modificationcframe:Remove()
				end
				skywars["MeleeController"].playAnimation = oldswinganim
				oldswinganim = nil
				local tool = lplr.Character:FindFirstChildWhichIsA("Tool")
				if tool then
					tool.Handle.LocalTransparencyModifier = 0 -- reset transparency
					for i,v in pairs(tool.Handle:GetChildren()) do
						if v:IsA("Texture") then
							v.Transparency = 0
						end
					end
				end
			end
		end,
		["HoverText"] = "Makes first person better (better viewmodel)"
	})
end)
