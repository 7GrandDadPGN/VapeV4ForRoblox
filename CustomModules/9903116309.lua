-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local collectionservice = game:GetService("CollectionService")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset
local uninjectflag = false
local br = {}

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, num, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, num, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local function createwarning(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or plr:GetAttribute("teamId") == lplr:GetAttribute("teamId") and plr.TeamColor.Color)
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
			repeat wait() until isfile(path)
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
		local char = br["ChickynoidClient"].characters[plr.UserId]
		char = char and char.characterModel and char.characterModel.model
		return char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char
	end
	return br["ChickynoidClient"].characterModel and br["ChickynoidClient"].characterModel.model
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

local rayparams = RaycastParams.new()
rayparams.FilterType = Enum.RaycastFilterType.Blacklist
local function getAttackable()
	local tab = {}
	for i,v in pairs(players:GetPlayers()) do 
		if v ~= lplr and v:GetAttribute("teamId") ~= lplr:GetAttribute("teamId") then
			local char = isAlive(v)
			if char then 
				table.insert(tab, {Player = v, Character = char})
			end
		end
	end
	return tab
end

local function getTeammates()
	local tab = {}
	for i,v in pairs(players:GetPlayers()) do 
		if v ~= lplr and v:GetAttribute("teamId") == lplr:GetAttribute("teamId") then
			local char = isAlive(v)
			if char then 
				table.insert(tab, {Player = v, Character = char})
			end
		end
	end
	return tab
end

local function getBattleRoyaleEntity(plr)
	for i,v in pairs(collectionservice:GetTagged("royale-entity")) do 
		if v:GetAttribute("userId") == plr.UserId then 
			return v
		end
	end
end

local function GetNearestHumanoidToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
	for i, v in pairs(getAttackable()) do
		local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
		if vis then
			local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
			if mag <= closest then
				if checkvis then 
					rayparams.FilterDescendantsInstances = {lplr.Character}
					local res = br["GameQueryUtil"]:raycast(cam.CFrame.p, CFrame.lookAt(cam.CFrame.p, v.Character.Head:GetRenderCFrame().p).lookVector * 1000, rayparams)
					if res == nil or res.Instance and res.Instance:IsDescendantOf(v.Character) ~= true then continue end
				end
				closest = mag
				returnedplayer = v
			end
		end
	end
    return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
	local localchar = isAlive()
	if localchar then
		for i, v in pairs(getTeammates()) do
			local mag = (localchar.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
			if mag <= closest then
				if checkvis then 
					rayparams.FilterDescendantsInstances = {lplr.Character}
					local res = br["GameQueryUtil"]:raycast(cam.CFrame.p, CFrame.lookAt(cam.CFrame.p, v.Character.Head:GetRenderCFrame().p).lookVector * 1000, rayparams)
					if res == nil or res.Instance and res.Instance:IsDescendantOf(v.Character) ~= true then continue end
				end
				closest = mag
				returnedplayer = v
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

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

runcode(function()
	local Flamework = require(repstorage.rbxts_include.node_modules["@flamework"].core.out.flamework).Flamework
	repeat task.wait() until Flamework.isInitialized
	br = {
		["ClientStoreController"] = Flamework.resolveDependency("client/controllers/global/rodux/rodux-controller@RoduxController"),
		["CrosshairController"] = Flamework.resolveDependency("client/controllers/global/crosshair/crosshair-controller@CrosshairController"),
		["ChickynoidClient"] = require(repstorage.rbxts_include.node_modules.chickynoid.src).ChickynoidClient,
		["EntityService"] = Flamework.resolveDependency("@easy-games/damage:server/services/entity/entity-service@EntityService"),
		["GameQueryUtil"] = require(repstorage.rbxts_include.node_modules["@easy-games"]["game-core"].out).GameQueryUtil,
		["GunController"] = Flamework.resolveDependency("client/controllers/global/gun/gun-controller@GunController"),
		["GunUtil"] = require(repstorage.TS.gun["gun-util"]).GunUtil,
		["ItemPickupController"] = Flamework.resolveDependency("client/controllers/global/ground-item/item-pickup-controller@ItemPickupController"),
		["ItemTable"] = require(repstorage.TS.item["item-meta"]).RoyaleItemMeta,
		["ItemHolderController"] = Flamework.resolveDependency("client/controllers/game/held-item/item-holder-controller@ItemHolderController"),
		["InventoryController"] = Flamework.resolveDependency("client/controllers/global/inventory/inventory-controller@InventoryController"),
		["LobbyClientEvents"] = require(repstorage.rbxts_include.node_modules["@easy-games"].lobby.out.client.events).LobbyClientEvents,
		["MatchManagerController"] = Flamework.resolveDependency("@easy-games/minigame-engine:client/controllers/match/match-manager-controller@MatchManagerController"),
		["Networking"] = require(repstorage.TS.networking),
		["sprintTable"] = Flamework.resolveDependency("client/controllers/global/movement/sprint-controller@SprintController")
	}
end)

runcode(function()
	local Sprint = {["Enabled"] = false}
	Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Sprint",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						if Sprint["Enabled"] == false then break end
						if br["sprintTable"].sprinting == false then
							br["sprintTable"]:startSprinting()
						end
					until Sprint["Enabled"] == false
				end)
			else
				br["sprintTable"]:stopSprinting()
			end
		end,
		["HoverText"] = "Sets your sprinting to true."
	})
end)

GuiLibrary["SelfDestructEvent"].Event:connect(function()
	uninjectflag = true
end)

GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("BlinkOptionsButton")
GuiLibrary["RemoveObject"]("FlyOptionsButton")
GuiLibrary["RemoveObject"]("HighJumpOptionsButton")
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
GuiLibrary["RemoveObject"]("KillauraOptionsButton")
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("PhaseOptionsButton")
GuiLibrary["RemoveObject"]("SpiderOptionsButton")
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
GuiLibrary["RemoveObject"]("SpinBotOptionsButton")
GuiLibrary["RemoveObject"]("SwimOptionsButton")
GuiLibrary["RemoveObject"]("SafeWalkOptionsButton")
GuiLibrary["RemoveObject"]("GravityOptionsButton")
GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
GuiLibrary["RemoveObject"]("TriggerBotOptionsButton")
runcode(function()
	local SilentAim = {["Enabled"] = false}
	local SilentAimFOV = {["Value"] = 0}
	local aimfovframecolor = {["Value"] = 0.44}
	local aimfovshow = {["Enabled"] = false}
	local aimfovframe
	local SilentAimfunc
	local SilentAimfunc2
	SilentAim = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SilentAim",
		["Function"] = function(callback)
			if callback then
				if aimfovframe then
					aimfovframe.Visible = true
				end
				SilentAimfunc = debug.getupvalue(br["CrosshairController"].getAimPosition, 4)
				SilentAimfunc2 = br["GunUtil"].aimconeDirectionAdjustment
				local currentplr
				debug.setupvalue(br["CrosshairController"].getAimPosition, 4, {
					raycast = function(self, origin, direction, args, ...)
						local plr = GetNearestHumanoidToMouse(true, SilentAimFOV["Value"], true)
						currentplr = plr
						if plr then 
							direction = CFrame.lookAt(origin, plr.Character.Head:GetRenderCFrame().p).lookVector * 1000
						end
						return SilentAimfunc:raycast(origin, direction, args, ...)
					end
				})
				br["GunUtil"].aimconeDirectionAdjustment = function(self, origin, direction, ...)
					if currentplr then
						return direction
					end
					return SilentAimfunc2(self, origin, direction, ...)
				end
			else
				debug.setupvalue(br["CrosshairController"].getAimPosition, 4, SilentAimfunc)
				br["GunUtil"].aimconeDirectionAdjustment = SilentAimfunc2
				SilentAimfunc = nil
				SilentAimfunc2 = nil
				if aimfovframe then
					aimfovframe.Visible = false
				end
			end
		end
	})
	SilentAimFOV = SilentAim.CreateSlider({
		["Name"] = "FOV",
		["Function"] = function(val) 
			if aimfovframe then
				aimfovframe.Size = UDim2.new(0, val, 0, val)
			end
		end,
		["Min"] = 1,
		["Max"] = 1000,
		["Default"] = 70
	})
	aimfovframecolor = SilentAim.CreateColorSlider({
		["Name"] = "Circle Color",
		["Function"] = function(hue, sat, val)
			if aimfovframe then
				aimfovframe.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	aimfovshow = SilentAim.CreateToggle({
		["Name"] = "FOV Circle",
		["Function"] = function(callback) 
			if callback then
				aimfovframe = Instance.new("Frame")
				aimfovframe.BackgroundTransparency = 0.8
				aimfovframe.ZIndex = -1
				aimfovframe.Visible = SilentAim["Enabled"]
				aimfovframe.BackgroundColor3 = Color3.fromHSV(aimfovframecolor["Hue"], aimfovframecolor["Sat"], aimfovframecolor["Value"])
				aimfovframe.Size = UDim2.new(0, SilentAimFOV["Value"], 0, SilentAimFOV["Value"])
				aimfovframe.AnchorPoint = Vector2.new(0.5, 0.5)
				aimfovframe.Position = UDim2.new(0.5, 0, 0.5, -18)
				aimfovframe.Parent = GuiLibrary["MainGui"]
				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 2048)
				corner.Parent = aimfovframe
			else
				if aimfovframe then
					aimfovframe:Remove()
				end
			end
		end,
	})
end)

local healthColorToPosition = {
	[0.01] = Color3.fromRGB(255, 28, 0);
	[0.5] = Color3.fromRGB(250, 235, 0);
	[0.99] = Color3.fromRGB(27, 252, 107);
}

local function HealthbarColorTransferFunction(healthPercent)
	healthPercent = math.clamp(healthPercent, 0.01, 0.99)
	local lastcolor = Color3.new(1, 1, 1)
	for samplePoint, colorSampleValue in pairs(healthColorToPosition) do
		local distance = (healthPercent / samplePoint)
		if distance == 1 then
			return colorSampleValue
		elseif distance < 1 then 
			return lastcolor:lerp(colorSampleValue, distance)
		else
			lastcolor = colorSampleValue
		end
	end
	return lastcolor
end

GuiLibrary["RemoveObject"]("ESPOptionsButton")
runcode(function()
	local ESPFolder = Instance.new("Folder")
	ESPFolder.Name = "ESPFolder"
	ESPFolder.Parent = GuiLibrary["MainGui"]
	local espfolderdrawing = {}
	players.PlayerRemoving:connect(function(plr)
		if ESPFolder:FindFirstChild(plr.Name) then
			ESPFolder[plr.Name]:Remove()
		end
		if espfolderdrawing[plr.Name] then
			pcall(function()
				pcall(function()
					espfolderdrawing[plr.Name].Quad1:Remove()
					espfolderdrawing[plr.Name].Quad2:Remove()
					espfolderdrawing[plr.Name].Quad3:Remove()
					espfolderdrawing[plr.Name].Quad4:Remove()
				end)
				pcall(function()
					espfolderdrawing[plr.Name].Head:Remove()
					espfolderdrawing[plr.Name].Head2:Remove()
					espfolderdrawing[plr.Name].Torso:Remove()
					espfolderdrawing[plr.Name].Torso2:Remove()
					espfolderdrawing[plr.Name].Torso3:Remove()
					espfolderdrawing[plr.Name].LeftArm:Remove()
					espfolderdrawing[plr.Name].RightArm:Remove()
					espfolderdrawing[plr.Name].LeftLeg:Remove()
					espfolderdrawing[plr.Name].RightLeg:Remove()
				end)
				espfolderdrawing[plr.Name] = nil
			end)
		end
	end)

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local ESPColor = {["Value"] = 0.44}
	local ESPHealthBar = {["Enabled"] = false}
	local ESPMethod = {["Value"] = "2D"}
	local ESPDrawing = {["Enabled"] = false}
	local ESPTeammates = {["Enabled"] = true}
	local ESPAlive = {["Enabled"] = false}
	local ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ESP", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("ESP", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if ESPDrawing["Enabled"] then 
							if ESPMethod["Value"] == "2D" then
								if espfolderdrawing[plr.Name] then
									thing = espfolderdrawing[plr.Name]
									thing.Quad1.Visible = false
									thing.Quad1.Color = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
									thing.Quad2.Visible = false
									thing.Quad3.Visible = false
									thing.Quad4.Visible = false
								else
									espfolderdrawing[plr.Name] = {}
									espfolderdrawing[plr.Name].Quad1 = Drawing.new("Quad")
									espfolderdrawing[plr.Name].Quad1.Thickness = 1
									espfolderdrawing[plr.Name].Quad1.ZIndex = 2
									espfolderdrawing[plr.Name].Quad1.Color = Color3.new(1, 1, 1)
									espfolderdrawing[plr.Name].Quad2 = Drawing.new("Quad")
									espfolderdrawing[plr.Name].Quad2.Thickness = 2
									espfolderdrawing[plr.Name].Quad2.ZIndex = 1
									espfolderdrawing[plr.Name].Quad2.Color = Color3.new(0, 0, 0)
									espfolderdrawing[plr.Name].Quad3 = Drawing.new("Line")
									espfolderdrawing[plr.Name].Quad3.Thickness = 1
									espfolderdrawing[plr.Name].Quad3.ZIndex = 2
									espfolderdrawing[plr.Name].Quad3.Color = Color3.new(0, 0, 0)
									espfolderdrawing[plr.Name].Quad4 = Drawing.new("Line")
									espfolderdrawing[plr.Name].Quad4.Thickness = 2
									espfolderdrawing[plr.Name].Quad4.ZIndex = 1
									espfolderdrawing[plr.Name].Quad4.Color = Color3.new(0, 0, 0)
									thing = espfolderdrawing[plr.Name]
								end

								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
									plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100}
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									local rootSize = (aliveplr.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position + Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position - Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										--thing.Visible = rootVis
										local sizex, sizey = (rootSize / rootPos.Z), (headPos.Y - legPos.Y) 
										local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(plrattr.health / plrattr.maxHealth)
											thing.Quad3.Color = color
											thing.Quad3.Visible = true
											thing.Quad4.From = floorpos(Vector2.new(posx - 4, posy + 1))
											thing.Quad4.To = floorpos(Vector2.new(posx - 4, posy + sizey - 1))
											thing.Quad4.Visible = true
											local healthposy = sizey * math.clamp(plrattr.health / plrattr.maxHealth, 0, 1)
											thing.Quad3.From = floorpos(Vector2.new(posx - 4, posy + sizey - (sizey - healthposy)))
											thing.Quad3.To = floorpos(Vector2.new(posx - 4, posy))
											--thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
										end
										thing.Quad1.PointA = floorpos(Vector2.new(posx + sizex, posy))
										thing.Quad1.PointB = floorpos(Vector2.new(posx, posy))
										thing.Quad1.PointC = floorpos(Vector2.new(posx, posy + sizey))
										thing.Quad1.PointD = floorpos(Vector2.new(posx + sizex, posy + sizey))
										thing.Quad1.Visible = true
										thing.Quad2.PointA = floorpos(Vector2.new(posx + sizex, posy))
										thing.Quad2.PointB = floorpos(Vector2.new(posx, posy))
										thing.Quad2.PointC = floorpos(Vector2.new(posx, posy + sizey))
										thing.Quad2.PointD = floorpos(Vector2.new(posx + sizex, posy + sizey))
										thing.Quad2.Visible = true
									end
								end
							else
								if espfolderdrawing[plr.Name] then
									thing = espfolderdrawing[plr.Name]
									for linenum, line in pairs(thing) do
										line.Color = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
										line.Visible = false
									end
								else
									thing = {}
									thing.Head = Drawing.new("Line")
									thing.Head2 = Drawing.new("Line")
									thing.Torso = Drawing.new("Line")
									thing.Torso2 = Drawing.new("Line")
									thing.Torso3 = Drawing.new("Line")
									thing.LeftArm = Drawing.new("Line")
									thing.RightArm = Drawing.new("Line")
									thing.LeftLeg = Drawing.new("Line")
									thing.RightLeg = Drawing.new("Line")
									espfolderdrawing[plr.Name] = thing
								end
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootPos, rootVis = cam:WorldToViewportPoint(plr.HumanoidRootPart.Position)
									local rigcheck = aliveplr.Humanoid.RigType == Enum.HumanoidRigType.R6
									if rootVis and plr.Character:FindFirstChild((rigcheck and "Torso" or "UpperTorso")) and plr.Character:FindFirstChild((rigcheck and "Left Arm" or "LeftHand")) and plr.Character:FindFirstChild((rigcheck and "Right Arm" or "RightHand")) and plr.Character:FindFirstChild((rigcheck and "Left Leg" or "LeftFoot")) and plr.Character:FindFirstChild((rigcheck and "Right Leg" or "RightFoot")) and plr.Character:FindFirstChild("Head") then
										local head = CalculateObjectPosition((aliveplr.Head.CFrame).p)
										local headfront = CalculateObjectPosition((aliveplr.Head.CFrame * CFrame.new(0, 0, -0.5)).p)
										local toplefttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
										local toprighttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
										local toptorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
										local bottomtorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local bottomlefttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
										local bottomrighttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
										local leftarm = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightarm = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local leftleg = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightleg = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
										thing.Torso.From = toplefttorso
										thing.Torso.To = toprighttorso
										thing.Torso.Visible = true
										thing.Torso2.From = toptorso
										thing.Torso2.To = bottomtorso
										thing.Torso2.Visible = true
										thing.Torso3.From = bottomlefttorso
										thing.Torso3.To = bottomrighttorso
										thing.Torso3.Visible = true
										thing.LeftArm.From = toplefttorso
										thing.LeftArm.To = leftarm
										thing.LeftArm.Visible = true
										thing.RightArm.From = toprighttorso
										thing.RightArm.To = rightarm
										thing.RightArm.Visible = true
										thing.LeftLeg.From = bottomlefttorso
										thing.LeftLeg.To = leftleg
										thing.LeftLeg.Visible = true
										thing.RightLeg.From = bottomrighttorso
										thing.RightLeg.To = rightleg
										thing.RightLeg.Visible = true
										thing.Head.From = toptorso
										thing.Head.To = head
										thing.Head.Visible = true
										thing.Head2.From = head
										thing.Head2.To = headfront
										thing.Head2.Visible = true
										--[[CalculateLine(toplefttorso, toprighttorso, thing.TopTorsoLine)
										CalculateLine(toptorso, bottomtorso, thing.MiddleTorsoLine)
										CalculateLine(bottomlefttorso, bottomrighttorso, thing.BottomTorsoLine)
										CalculateLine(toplefttorso, leftarm, thing.LeftArm)
										CalculateLine(toprighttorso, rightarm, thing.RightArm)
										CalculateLine(bottomlefttorso, leftleg, thing.LeftLeg)
										CalculateLine(bottomrighttorso, rightleg, thing.RightLeg)
										CalculateLine(toptorso, head, thing.Head)
										CalculateLine(head, headfront, thing.HeadForward)]]
									end
								end
							end
						else
							if ESPMethod["Value"] == "2D" then
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
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
									plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100}
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									local rootSize = (aliveplr.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position + Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position - Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(plrattr.health / plrattr.maxHealth)
											thing.HealthLineMain.BackgroundColor3 = color
											thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plrattr.health / plrattr.maxHealth, 0, 1), (math.clamp(plrattr.health / plrattr.maxHealth, 0, 1) == 0 and 0 or -2))
										end
										thing.Visible = rootVis
										thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
										thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
									end
								end
							end
							if ESPMethod["Value"] == "Skeleton" then
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
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									local rigcheck = aliveplr.Humanoid.RigType == Enum.HumanoidRigType.R6
									if rootVis and plr.Character:FindFirstChild((rigcheck and "Torso" or "UpperTorso")) and plr.Character:FindFirstChild((rigcheck and "Left Arm" or "LeftHand")) and plr.Character:FindFirstChild((rigcheck and "Right Arm" or "RightHand")) and plr.Character:FindFirstChild((rigcheck and "Left Leg" or "LeftFoot")) and plr.Character:FindFirstChild((rigcheck and "Right Leg" or "RightFoot")) and plr.Character:FindFirstChild("Head") then
										thing.Visible = true
										local head = CalculateObjectPosition((aliveplr.Head.CFrame).p)
										local headfront = CalculateObjectPosition((aliveplr.Head.CFrame * CFrame.new(0, 0, -0.5)).p)
										local toplefttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
										local toprighttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
										local toptorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
										local bottomtorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local bottomlefttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
										local bottomrighttorso = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
										local leftarm = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightarm = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local leftleg = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
										local rightleg = CalculateObjectPosition((aliveplr.Character[(rigcheck and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
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
							if ESPMethod["Value"] == "VideoFrame" then
								if ESPFolder:FindFirstChild(plr.Name) then
									thing = ESPFolder[plr.Name]
									thing.Visible = false
								else
									thing = Instance.new("ImageLabel")
									thing.BackgroundTransparency = 1
									thing.BorderSizePixel = 0
									thing.Image = getcustomassetfunc("honestlyquiteincredible.png")
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = ESPFolder
								end
								
								local aliveplr = isAlive(plr, ESPAlive["Enabled"])
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
									local rootSize = (aliveplr.HumanoidRootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position + Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position - Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										thing.Visible = rootVis
										thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
										thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
									end
								end
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("ESP") 
				ESPFolder:ClearAllChildren()
				for i,v in pairs(espfolderdrawing) do 
					pcall(function()
						espfolderdrawing[i].Quad1:Remove()
						espfolderdrawing[i].Quad2:Remove()
						espfolderdrawing[i].Quad3:Remove()
						espfolderdrawing[i].Quad4:Remove()
						espfolderdrawing[i] = nil
					end)
					pcall(function()
						espfolderdrawing[i].Head:Remove()
						espfolderdrawing[i].Head2:Remove()
						espfolderdrawing[i].Torso:Remove()
						espfolderdrawing[i].Torso2:Remove()
						espfolderdrawing[i].Torso3:Remove()
						espfolderdrawing[i].LeftArm:Remove()
						espfolderdrawing[i].RightArm:Remove()
						espfolderdrawing[i].LeftLeg:Remove()
						espfolderdrawing[i].RightLeg:Remove()
						espfolderdrawing[i] = nil
					end)
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPMethod = ESP.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"2D", "Skeleton", "VideoFrame"},
		["Function"] = function(val)
			ESPFolder:ClearAllChildren()
			for i,v in pairs(espfolderdrawing) do 
				pcall(function()
					espfolderdrawing[i].Quad1:Remove()
					espfolderdrawing[i].Quad2:Remove()
					espfolderdrawing[i].Quad3:Remove()
					espfolderdrawing[i].Quad4:Remove()
					espfolderdrawing[i] = nil
				end)
				pcall(function()
					espfolderdrawing[i].Head:Remove()
					espfolderdrawing[i].Head2:Remove()
					espfolderdrawing[i].Torso:Remove()
					espfolderdrawing[i].Torso2:Remove()
					espfolderdrawing[i].Torso3:Remove()
					espfolderdrawing[i].LeftArm:Remove()
					espfolderdrawing[i].RightArm:Remove()
					espfolderdrawing[i].LeftLeg:Remove()
					espfolderdrawing[i].RightLeg:Remove()
					espfolderdrawing[i] = nil
				end)
			end
			ESPHealthBar["Object"].Visible = (val == "2D")
		end,
	})
	ESPColor = ESP.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
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
	ESPTeammates = ESP.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	ESPDrawing = ESP.CreateToggle({
		["Name"] = "Drawing",
		["Function"] = function() 
			ESPFolder:ClearAllChildren()
			for i,v in pairs(espfolderdrawing) do 
				pcall(function()
					espfolderdrawing[i].Quad1:Remove()
					espfolderdrawing[i].Quad2:Remove()
					espfolderdrawing[i].Quad3:Remove()
					espfolderdrawing[i].Quad4:Remove()
					espfolderdrawing[i] = nil
				end)
				pcall(function()
					espfolderdrawing[i].Head:Remove()
					espfolderdrawing[i].Head2:Remove()
					espfolderdrawing[i].Torso:Remove()
					espfolderdrawing[i].Torso2:Remove()
					espfolderdrawing[i].Torso3:Remove()
					espfolderdrawing[i].LeftArm:Remove()
					espfolderdrawing[i].RightArm:Remove()
					espfolderdrawing[i].LeftLeg:Remove()
					espfolderdrawing[i].RightLeg:Remove()
					espfolderdrawing[i] = nil
				end)
			end
		end,
	})
	ESPAlive = ESP.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)

GuiLibrary["RemoveObject"]("ArrowsOptionsButton")
runcode(function()
	local ArrowsFolder = Instance.new("Folder")
	ArrowsFolder.Name = "ArrowsFolder"
	ArrowsFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
		if ArrowsFolder:FindFirstChild(plr.Name) then
			ArrowsFolder[plr.Name]:Remove()
		end
	end)
	local ArrowsColor = {["Value"] = 0.44}
	local ArrowsTeammate = {["Enabled"] = true}
	local Arrows = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Arrows", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("Arrows", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if ArrowsFolder:FindFirstChild(plr.Name) then
							thing = ArrowsFolder[plr.Name]
							thing.Visible = false
							thing.ImageColor3 = getPlayerColor(plr) or Color3.fromHSV(ArrowsColor["Hue"], ArrowsColor["Sat"], ArrowsColor["Value"])
						else
							thing = Instance.new("ImageLabel")
							thing.BackgroundTransparency = 1
							thing.BorderSizePixel = 0
							thing.Size = UDim2.new(0, 256, 0, 256)
							thing.AnchorPoint = Vector2.new(0.5, 0.5)
							thing.Position = UDim2.new(0.5, 0, 0.5, 0)
							thing.Visible = false
							thing.Image = getcustomassetfunc("vape/assets/ArrowIndicator.png")
							thing.Name = plr.Name
							thing.Parent = ArrowsFolder
						end
						
						local aliveplr = isAlive(plr)
						if aliveplr and plr ~= lplr and (ArrowsTeammate["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
							local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.HumanoidRootPart.Position)
							local camcframeflat = CFrame.new(cam.CFrame.p, cam.CFrame.p + cam.CFrame.lookVector * Vector3.new(1, 0, 1))
							local pointRelativeToCamera = camcframeflat:pointToObjectSpace(aliveplr.HumanoidRootPart.Position)
							local unitRelativeVector = (pointRelativeToCamera * Vector3.new(1, 0, 1)).unit
							local rotation = math.atan2(unitRelativeVector.Z, unitRelativeVector.X)
							thing.Visible = not rootVis
							thing.Rotation = math.deg(rotation)
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("Arrows") 
				ArrowsFolder:ClearAllChildren()
			end
		end, 
		["HoverText"] = "Draws arrows on screen when entities\nare out of your field of view."
	})
	ArrowsColor = Arrows.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end,
	})
	ArrowsTeammate = Arrows.CreateToggle({
		["Name"] = "Teammate",
		["Function"] = function() end,
		["Default"] = true
	})
end)

GuiLibrary["RemoveObject"]("TracersOptionsButton")
runcode(function()
	local TracersFolder = Instance.new("Folder")
	TracersFolder.Name = "TracersFolder"
	TracersFolder.Parent = GuiLibrary["MainGui"]
	local TracersDrawing
	local tracersdrawingtab = {}
	players.PlayerRemoving:connect(function(plr)
		if TracersFolder:FindFirstChild(plr.Name) then
			TracersFolder[plr.Name]:Remove()
		end
		if tracersdrawingtab[plr.Name] then 
			pcall(function()
				tracersdrawingtab[plr.Name]:Remove()
				tracersdrawingtab[plr.Name] = nil
			end)
		end
	end)
	local TracersColor = {["Value"] = 0.44}
	local TracersTransparency = {["Value"] = 1}
	local TracersStartPosition = {["Value"] = "Middle"}
	local TracersEndPosition = {["Value"] = "Head"}
	local TracersTeammates = {["Enabled"] = true}
	local TracersAlive = {["Enabled"] = false}
	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("Tracers", 500, function()
					for i,plr in pairs(players:GetChildren()) do
							local thing
							if TracersDrawing["Enabled"] then
								if tracersdrawingtab[plr.Name] then 
									thing = tracersdrawingtab[plr.Name]
									thing.Visible = false
								else
									thing = Drawing.new("Line")
									thing.Thickness = 1
									thing.Visible = false
									tracersdrawingtab[plr.Name] = thing
								end

								local aliveplr = isAlive(plr, TracersAlive["Enabled"])
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.Character.HumanoidRootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.Character.HumanoidRootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.Transparency = 1 - TracersTransparency["Value"] / 100
									thing.Color = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.From = startVector
									thing.To = endVector
								end
							else
								if TracersFolder:FindFirstChild(plr.Name) then
									thing = TracersFolder[plr.Name]
									if thing.Visible then
										thing.Visible = false
									end
								else
									thing = Instance.new("Frame")
									thing.BackgroundTransparency = 0
									thing.AnchorPoint = Vector2.new(0.5, 0.5)
									thing.BackgroundColor3 = Color3.new(0, 0, 0)
									thing.BorderSizePixel = 0
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = TracersFolder
								end
								
								local aliveplr = isAlive(plr, TracersAlive["Enabled"])
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.HumanoidRootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.HumanoidRootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.BackgroundTransparency = TracersTransparency["Value"] / 100
									thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.Size = UDim2.new(0, Distance, 0, 2)
									thing.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
									thing.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
								end
							end
						end
				end)
			else
				RunLoops:UnbindFromRenderStep("Tracers") 
				TracersFolder:ClearAllChildren()
				for i,v in pairs(tracersdrawingtab) do 
					pcall(function()
						v:Remove()
						tracersdrawingtab[i] = nil
					end)
				end
			end
		end
	})
	TracersStartPosition = Tracers.CreateDropdown({
		["Name"] = "Start Position",
		["List"] = {"Middle", "Bottom"},
		["Function"] = function() end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		["Name"] = "End Position",
		["List"] = {"Head", "Torso"},
		["Function"] = function() end
	})
	TracersColor = Tracers.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	TracersTransparency = Tracers.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	TracersDrawing = Tracers.CreateToggle({
		["Name"] = "Drawing",
		["Function"] = function() 
			TracersFolder:ClearAllChildren()
			for i,v in pairs(tracersdrawingtab) do 
				pcall(function()
					v:Remove()
					tracersdrawingtab[i] = nil
				end)
			end
		end
	})
	TracersAlive = Tracers.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)

GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
runcode(function()
	runcode(function()
		local function removeTags(str)
			str = str:gsub("<br%s*/>", "\n")
			return (str:gsub("<[^<>]->", ""))
		end
	
		local function floorpos(pos)
			return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
		end
	
		local NameTagsFolder = Instance.new("Folder")
		NameTagsFolder.Name = "NameTagsFolder"
		NameTagsFolder.Parent = GuiLibrary["MainGui"]
		local nametagsfolderdrawing = {}
		players.PlayerRemoving:connect(function(plr)
			if NameTagsFolder:FindFirstChild(plr.Name) then
				NameTagsFolder[plr.Name]:Remove()
			end
			if nametagsfolderdrawing[plr.Name] then 
				pcall(function()
					nametagsfolderdrawing[plr.Name].Text:Remove()
					nametagsfolderdrawing[plr.Name].BG:Remove()
					nametagsfolderdrawing[plr.Name] = nil
				end)
			end
		end)
		local NameTagsColor = {["Value"] = 0.44}
		local NameTagsDisplayName = {["Enabled"] = false}
		local NameTagsHealth = {["Enabled"] = false}
		local NameTagsDistance = {["Enabled"] = false}
		local NameTagsBackground = {["Enabled"] = true}
		local NameTagsScale = {["Value"] = 10}
		local NameTagsFont = {["Value"] = "SourceSans"}
		local NameTagsTeammates = {["Enabled"] = true}
		local NameTagsAlive = {["Enabled"] = false}
		local fontitems = {"SourceSans"}
		local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
			["Name"] = "NameTags", 
			["Function"] = function(callback) 
				if callback then
					RunLoops:BindToRenderStep("NameTags", 500, function()
						for i,plr in pairs(players:GetChildren()) do
							local thing
							local localchar = isAlive()
							if NameTagsDrawing["Enabled"] then
								if nametagsfolderdrawing[plr.Name] then
									thing = nametagsfolderdrawing[plr.Name]
									thing.Text.Visible = false
									thing.BG.Visible = false
								else
									nametagsfolderdrawing[plr.Name] = {}
									nametagsfolderdrawing[plr.Name].Text = Drawing.new("Text")
									nametagsfolderdrawing[plr.Name].Text.Size = 17	
									nametagsfolderdrawing[plr.Name].Text.Font = 0
									nametagsfolderdrawing[plr.Name].Text.Text = ""
									nametagsfolderdrawing[plr.Name].Text.ZIndex = 2
									nametagsfolderdrawing[plr.Name].BG = Drawing.new("Square")
									nametagsfolderdrawing[plr.Name].BG.Filled = true
									nametagsfolderdrawing[plr.Name].BG.Transparency = 0.5
									nametagsfolderdrawing[plr.Name].BG.Color = Color3.new(0, 0, 0)
									nametagsfolderdrawing[plr.Name].BG.ZIndex = 1
									thing = nametagsfolderdrawing[plr.Name]
								end
	
								local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
								if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local headPos, headVis = cam:WorldToViewportPoint((aliveplr.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.HumanoidRootPart.Size.Y, 0)).Position)
									
									if headVis then
										local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
										plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100}
										local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										local blocksaway = math.floor(((localchar and localchar.HumanoidRootPart.Position or Vector3.new(0,0,0)) - aliveplr.HumanoidRootPart.Position).magnitude / 3)
										local color = HealthbarColorTransferFunction(plrattr.health / plrattr.maxHealth)
										thing.Text.Text = (NameTagsDistance["Enabled"] and entity.isAlive and '['..blocksaway..'] ' or '')..displaynamestr..(NameTagsHealth["Enabled"] and ' '..math.floor(plrattr.health).."" or '')
										thing.Text.Size = 17 * (NameTagsScale["Value"] / 10)
										thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
										thing.Text.Visible = headVis
										thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont["Value"]) or 1) - 1, 0, 3))
										thing.Text.Position = floorpos(Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y)))
										thing.BG.Visible = headVis and NameTagsBackground["Enabled"]
										thing.BG.Size = floorpos(Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y))
										thing.BG.Position = floorpos(Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5))
									end
								end
							else
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
									thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Parent = NameTagsFolder
								end
									
								local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
								if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or plr:GetAttribute("teamId") ~= lplr:GetAttribute("teamId")) then
									local headPos, headVis = cam:WorldToViewportPoint((aliveplr.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.HumanoidRootPart.Size.Y, 0)).Position)
									headPos = headPos
									
									if headVis then
										local plrattr = br["EntityService"]:getLivingEntityById(plr:GetAttribute("LivingEntityID"))
										plrattr = plrattr and plrattr.attributes or {health = 100, maxHealth = 100}
										local rawText = (NameTagsDistance["Enabled"] and localchar and "["..math.floor(((localchar and localchar.HumanoidRootPart.Position or Vector3.zero) - aliveplr.HumanoidRootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(plrattr.health) or "")
										local color = HealthbarColorTransferFunction(plrattr.health / plrattr.maxHealth)
										local modifiedText = (NameTagsDistance["Enabled"] and localchar and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor(((localchar and localchar.HumanoidRootPart.Position or Vector3.zero) - aliveplr.HumanoidRootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plrattr.health).."</font>" or '')
										local nametagSize = textservice:GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
										thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
										thing.Text = modifiedText
										thing.Font = Enum.Font[NameTagsFont["Value"]]
										thing.TextSize = 14 * (NameTagsScale["Value"] / 10)
										thing.BackgroundTransparency = NameTagsBackground["Enabled"] and 0.5 or 1
										thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
										thing.Visible = headVis
										thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
									end
								end
							end
						end
					end)
				else
					RunLoops:UnbindFromRenderStep("NameTags")
					NameTagsFolder:ClearAllChildren()
					for i,v in pairs(nametagsfolderdrawing) do 
						pcall(function()
							nametagsfolderdrawing[i].Text:Remove()
							nametagsfolderdrawing[i].BG:Remove()
							nametagsfolderdrawing[i] = nil
						end)
					end
				end
			end,
			["HoverText"] = "Renders nametags on entities through walls."
		})
		for i,v in pairs(Enum.Font:GetEnumItems()) do 
			if v.Name ~= "SourceSans" then 
				table.insert(fontitems, v.Name)
			end
		end
		NameTagsFont = NameTags.CreateDropdown({
			["Name"] = "Font",
			["List"] = fontitems,
			["Function"] = function() end,
		})
		NameTagsColor = NameTags.CreateColorSlider({
			["Name"] = "Player Color", 
			["Function"] = function(val) end
		})
		NameTagsScale = NameTags.CreateSlider({
			["Name"] = "Scale",
			["Function"] = function(val) end,
			["Default"] = 10,
			["Min"] = 1,
			["Max"] = 50
		})
		NameTagsBackground = NameTags.CreateToggle({
			["Name"] = "Background", 
			["Function"] = function() end,
			["Default"] = true
		})
		NameTagsDisplayName = NameTags.CreateToggle({
			["Name"] = "Use Display Name", 
			["Function"] = function() end,
			["Default"] = true
		})
		NameTagsHealth = NameTags.CreateToggle({
			["Name"] = "Health", 
			["Function"] = function() end
		})
		NameTagsDistance = NameTags.CreateToggle({
			["Name"] = "Distance", 
			["Function"] = function() end
		})
		NameTagsTeammates = NameTags.CreateToggle({
			["Name"] = "Teammates", 
			["Function"] = function() end,
			["Default"] = true
		})
		NameTagsDrawing = NameTags.CreateToggle({
			["Name"] = "Drawing",
			["Function"] = function() 
				NameTagsFolder:ClearAllChildren()
				for i,v in pairs(nametagsfolderdrawing) do 
					pcall(function()
						nametagsfolderdrawing[i].Text:Remove()
						nametagsfolderdrawing[i].BG:Remove()
						nametagsfolderdrawing[i] = nil
					end)
				end
			end,
		})
		NameTagsAlive = NameTags.CreateToggle({
			["Name"] = "Alive Check",
			["Function"] = function() end
		})
	end)
end)

runcode(function()
	local PickupItems = {["Enabled"] = false}
	PickupItems = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "InventoryManager",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait(0.1)
						local localchar = isAlive()
						if localchar then 
							for i,v in pairs(collectionservice:GetTagged("ground-item-component")) do 
								local item = v:GetAttribute("displayItem")
								local itemmeta = br["ItemTable"][item]
								if (v.Position - localchar.HumanoidRootPart.Position).magnitude <= 9.5 and itemmeta then
									local armor = br["EntityService"]:getLivingEntityById(lplr:GetAttribute("LivingEntityID"))
									local inv = br["InventoryController"]:getPlayerInventory()
									inv = inv and inv.groups.default or {}
									armor = armor and armor.attributes.maxShield or 0
									local invcount = 0
									for i2,v2 in pairs(inv) do 
										if v2.item and v2.item.type ~= "" then invcount = invcount + 1 end
									end
									local specialitem = (item:find("ammo") or item:find("armor"))
									local allowed = (item:find("ammo") or (item:find("armor") and itemmeta.armor.maxShield > armor) or ((not specialitem) and (invcount < 6)))
									local oldslot
									if not allowed then 
										for i2,v2 in pairs(inv) do 
											if v2.item and v2.item.type then
												local helditemmeta = br["ItemTable"][v2.item.type]
												if helditemmeta.displayName == itemmeta.displayName then 
													allowed = (itemmeta.rarity or 0) > (helditemmeta.rarity or 0)
													if allowed then 
														oldslot = br["ItemHolderController"].currentSlotId
														br["ItemHolderController"]:setSlot(i2 - 1)
													end
												end
											end
										end
									end
									if allowed then 
										br["ItemPickupController"]:pickupItem({instance = v, getItemMeta = function() return itemmeta end})
										if oldslot then 
											br["ItemHolderController"]:setSlot(oldslot)
										end
									end
								end
							end
						end
					until (not PickupItems["Enabled"])
				end)
			end
		end
	})
end)

runcode(function()
	local AutoLeave = {["Enabled"] = false}
	local autoleaveconnection
	AutoLeave = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoLeave",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					local matchdoc = br["MatchManagerController"]:waitForMatchDocument()
					autoleaveconnection = matchdoc:watchAttribute("matchState", function(state)
						if state == 2 then 
							br["LobbyClientEvents"].joinQueue:fire({
								queueType = matchdoc:getQueueType()
							})
						end
					end)
				end)
			else
                if autoleaveconnection then autoleaveconnection:Disconnect() end
            end
		end
	})
end)