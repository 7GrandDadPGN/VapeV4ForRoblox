--[[ 
	Credits
	Infinite Yield - Blink (backtrack), Freecam and SpinBot (spin / fling)
	Please notify me if you need credits
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChildWhichIsA("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local v3check = syn and syn.toast_notification and "V3" or ""
local networkownertick = tick()
local networkownerfunc = isnetworkowner or function(part)
	if gethiddenproperty(part, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownertick = tick() + 8
	end
	return networkownertick <= tick()
end
local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		assert(betterisfile("vape/"..scripturl), "File not found : vape/"..scripturl)
		return readfile("vape/"..scripturl)
	else
		local res = game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
		assert(res ~= "404: Not Found", "File not found : vape/"..scripturl)
		return res
	end
end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == "GET" then
		return {
			Body = game:HttpGet(tab.Url, true),
			Headers = {},
			StatusCode = 200
		}
	end
	return {
		Body = "bad exploit",
		Headers = {},
		StatusCode = 404
	}
end 
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local entity = loadstring(GetURL("Libraries/entityHandler.lua"))()
shared.vapeentity = entity

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:Connect(func)
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
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
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
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local WhitelistFunctions = {StoredHashes = {}, PriorityList = {
	["VAPE OWNER"] = 3,
	["VAPE PRIVATE"] = 2,
	["DEFAULT"] = 1
}, WhitelistTable = {}, Loaded = true, CustomTags = {}}
do
	local shalib
	WhitelistFunctions.WhitelistTable = {
		players = {},
		owners = {},
		chattags = {}
	}
	task.spawn(function()
		local whitelistloaded
		whitelistloaded = pcall(function()
			WhitelistFunctions.WhitelistTable = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/whitelists/main/whitelist2.json", true))
		end)
		shalib = loadstring(GetURL("Libraries/sha.lua"))()
		if not whitelistloaded or not shalib then return end

		WhitelistFunctions.Loaded = true
	end)

	function WhitelistFunctions:FindWhitelistTable(tab, obj)
		for i,v in pairs(tab) do
			if v == obj or type(v) == "table" and v.hash == obj then
				return v
			end
		end
		return nil
	end

	function WhitelistFunctions:GetTag(plr)
		local plrstr = WhitelistFunctions:CheckPlayerType(plr)
		local hash = WhitelistFunctions:Hash(plr.Name..plr.UserId)
		if plrstr == "VAPE OWNER" then
			return "[VAPE OWNER] "
		elseif plrstr == "VAPE PRIVATE" then 
			return "[VAPE PRIVATE] "
		elseif WhitelistFunctions.WhitelistTable.chattags[hash] then
			local data = WhitelistFunctions.WhitelistTable.chattags[hash]
			local newnametag = ""
			if data.Tags then
				for i2,v2 in pairs(data.Tags) do
					newnametag = newnametag..'['..v2.TagText..'] '
				end
			end
			return newnametag
		end
		return WhitelistFunctions.CustomTags[plr] or ""
	end

	function WhitelistFunctions:Hash(str)
		if WhitelistFunctions.StoredHashes[tostring(str)] == nil and shalib then
			WhitelistFunctions.StoredHashes[tostring(str)] = shalib.sha512(tostring(str).."SelfReport")
		end
		return WhitelistFunctions.StoredHashes[tostring(str)] or ""
	end

	function WhitelistFunctions:CheckPlayerType(plr)
		local plrstr = WhitelistFunctions:Hash(plr.Name..plr.UserId)
		local playertype, playerattackable = "DEFAULT", true
		local private = WhitelistFunctions:FindWhitelistTable(WhitelistFunctions.WhitelistTable.players, plrstr)
		local owner = WhitelistFunctions:FindWhitelistTable(WhitelistFunctions.WhitelistTable.owners, plrstr)
		local tab = owner or private
		playertype = owner and "VAPE OWNER" or private and "VAPE PRIVATE" or "DEFAULT"
		playerattackable = (not tab) or (not (type(tab) == "table" and tab.invulnerable or true))
		return playertype, playerattackable
	end

	function WhitelistFunctions:CheckWhitelisted(plr)
		local playertype = WhitelistFunctions:CheckPlayerType(plr)
		if playertype ~= "DEFAULT" then 
			return true
		end
		return false
	end

	function WhitelistFunctions:IsSpecialIngame()
		for i,v in pairs(players:GetChildren()) do 
			if WhitelistFunctions:CheckWhitelisted(v) then 
				return true
			end
		end
		return false
	end
end
shared.vapewhitelist = WhitelistFunctions

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function friendCheck(plr, recolor)
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
		local friend = table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)
		friend = friend and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][friend] and true or nil
		if recolor then
			friend = friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or nil
		end
		return friend
	end
	return nil
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

local function targetCheck(plr)
	local ForceField = not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
	local state = plr.Humanoid.GetState(plr.Humanoid)
	return state ~= Enum.HumanoidStateType.Dead and state ~= Enum.HumanoidStateType.Physics and plr.Humanoid.Health > 0 and ForceField
end

do
	GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendRefresh.Event:Connect(function()
		entity.fullEntityRefresh()
	end)
	GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"].Refresh.Event:Connect(function()
		entity.fullEntityRefresh()
	end)
	local oldeventfunc = entity.getUpdateConnections
	entity.getUpdateConnections = function(ent)
		local newtab = {{Connect = function() 
			ent.Friend = friendCheck(ent.Player)
			return {Disconnect = function() end}
		end}}
		for i,v in pairs(oldeventfunc(ent)) do 
			table.insert(newtab, v)
		end
		return newtab
	end
	entity.isPlayerTargetable = function(plr)
		if (not GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"]) then return true end
		if friendCheck(plr) then return nil end
		if (not lplr.Team) then return true end
		if plr.Team ~= lplr.Team then return true end
        return plr.Team and #plr.Team:GetPlayers() == #players:GetPlayers()
	end
	entity.fullEntityRefresh()
end

local function isAlive(plr, alivecheck)
	if plr then
		local ind, tab = entity.getEntityFromPlayer(plr)
		return ((not alivecheck) or tab and tab.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) and tab
	end
	return entity.isAlive
end

local function vischeck(char, checktable)
	local rayparams = checktable.IgnoreObject or RaycastParams.new()
	if not checktable.IgnoreObject then 
		rayparams.FilterDescendantsInstances = {lplr.Character, char, cam, table.unpack(checktable.IgnoreTable or {})}
	end
	local ray = workspace.Raycast(workspace, checktable.Origin, CFrame.lookAt(checktable.Origin, char[checktable.AimPart].Position).lookVector * (checktable.Origin - char[checktable.AimPart].Position).Magnitude, rayparams)
	return not ray
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount, checktab)
	local returnedplayer = {}
	local currentamount = 0
	checktab = checktab or {}
    if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
			if not v.Targetable then continue end
            if targetCheck(v) and currentamount < amount then -- checks
				local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
                if mag <= distance then -- mag check
					if checktab.WallCheck then
						if not vischeck(v.Character, checktab) then continue end
					end
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance, checktab)
	local closest, returnedplayer, targetpart = distance, nil, nil
	checktab = checktab or {}
	if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
			if not v.Targetable then continue end
            if targetCheck(v) then -- checks
				local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
                if mag <= closest then -- mag check
					if checktab.WallCheck then
						if not vischeck(v.Character, checktab) then continue end
					end
                    closest = mag
					returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function worldtoscreenpoint(pos)
	if v3check == "V3" then 
		local scr = worldtoscreen({pos})
		return scr[1], scr[1].Z > 0
	end
	return cam.WorldToScreenPoint(cam, pos)
end

local function GetNearestHumanoidToMouse(player, distance, checktab)
    local closest, returnedplayer = distance, nil
	checktab = checktab or {}
    if entity.isAlive then
		local mousepos = uis.GetMouseLocation(uis)
		for i, v in pairs(entity.entityList) do -- loop through players
			if not v.Targetable then continue end
            if targetCheck(v) then -- checks
				local vec, vis = worldtoscreenpoint(v.Character[checktab.AimPart].Position)
				local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
                if vis and mag <= closest then -- mag check
					if checktab.WallCheck then
						if not vischeck(v.Character, checktab) then continue end
					end
                    closest = mag
					returnedplayer = v
                end
            end
        end
    end
    return returnedplayer
end

local function findTouchInterest(tool)
	return tool and tool:FindFirstChildWhichIsA("TouchTransmitter", true)
end

GuiLibrary["SelfDestructEvent"].Event:Connect(function()
	entity.selfDestruct()
end)

local radarcam = Instance.new("Camera")
radarcam.FieldOfView = 45
local Radar = GuiLibrary.CreateCustomWindow({
	["Name"] = "Radar", 
	["Icon"] = "vape/assets/RadarIcon1.png",
	["IconSize"] = 16
})
local RadarColor = Radar.CreateColorSlider({
	["Name"] = "Player Color", 
	["Function"] = function(val) end
})
local RadarFrame = Instance.new("Frame")
RadarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
RadarFrame.BorderSizePixel = 0
RadarFrame.BackgroundTransparency = 0.5
RadarFrame.Size = UDim2.new(0, 250, 0, 250)
RadarFrame.Parent = Radar.GetCustomChildren()
local RadarBorder1 = RadarFrame:Clone()
RadarBorder1.Size = UDim2.new(0, 6, 0, 250)
RadarBorder1.Parent = RadarFrame
local RadarBorder2 = RadarBorder1:Clone()
RadarBorder2.Position = UDim2.new(0, 6, 0, 0)
RadarBorder2.Size = UDim2.new(0, 238, 0, 6)
RadarBorder2.Parent = RadarFrame
local RadarBorder3 = RadarBorder1:Clone()
RadarBorder3.Position = UDim2.new(1, -6, 0, 0)
RadarBorder3.Size = UDim2.new(0, 6, 0, 250)
RadarBorder3.Parent = RadarFrame
local RadarBorder4 = RadarBorder1:Clone()
RadarBorder4.Position = UDim2.new(0, 6, 1, -6)
RadarBorder4.Size = UDim2.new(0, 238, 0, 6)
RadarBorder4.Parent = RadarFrame
local RadarBorder5 = RadarBorder1:Clone()
RadarBorder5.Position = UDim2.new(0, 0, 0.5, -1)
RadarBorder5.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder5.Size = UDim2.new(0, 250, 0, 2)
RadarBorder5.Parent = RadarFrame
local RadarBorder6 = RadarBorder1:Clone()
RadarBorder6.Position = UDim2.new(0.5, -1, 0, 0)
RadarBorder6.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder6.Size = UDim2.new(0, 2, 0, 124)
RadarBorder6.Parent = RadarFrame
local RadarBorder7 = RadarBorder1:Clone()
RadarBorder7.Position = UDim2.new(0.5, -1, 0, 126)
RadarBorder7.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder7.Size = UDim2.new(0, 2, 0, 124)
RadarBorder7.Parent = RadarFrame
local RadarMainFrame = Instance.new("Frame")
RadarMainFrame.BackgroundTransparency = 1
RadarMainFrame.Size = UDim2.new(0, 250, 0, 250)
RadarMainFrame.Parent = RadarFrame
Radar.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):Connect(function()
	RadarFrame.Position = UDim2.new(0, 0, 0, (Radar.GetCustomChildren().Parent.Size.Y.Offset == 0 and 45 or 0))
end)
players.PlayerRemoving:Connect(function(plr)
	if RadarMainFrame:FindFirstChild(plr.Name) then
		RadarMainFrame[plr.Name]:Remove()
	end
end)
GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
	["Name"] = "Radar", 
	["Icon"] = "vape/assets/RadarIcon2.png", 
	["Function"] = function(callback)
		Radar.SetVisible(callback) 
		if callback then
			RunLoops:BindToRenderStep("Radar", 1, function() 
				local v278 = (CFrame.new(0, 0, 0):inverse() * cam.CFrame).p * 0.2 * Vector3.new(1, 1, 1);
				local v279, v280, v281 = cam.CFrame:ToOrientation();
				local u90 = v280 * 180 / math.pi;
				local v277 = 0 - u90;
				local v276 = v278 + Vector3.new();
				radarcam.CFrame = CFrame.new(v276 + Vector3.new(0, 50, 0)) * CFrame.Angles(0, -v277 * (math.pi / 180), 0) * CFrame.Angles(-90 * (math.pi / 180), 0, 0)
				for i,plr in pairs(players:GetChildren()) do
					local thing
					if RadarMainFrame:FindFirstChild(plr.Name) then
						thing = RadarMainFrame[plr.Name]
						if thing.Visible then
							thing.Visible = false
						end
					else
						thing = Instance.new("Frame")
						thing.BackgroundTransparency = 0
						thing.Size = UDim2.new(0, 4, 0, 4)
						thing.BorderSizePixel = 1
						thing.BorderColor3 = Color3.new(0, 0, 0)
						thing.BackgroundColor3 = Color3.new(0, 0, 0)
						thing.Visible = false
						thing.Name = plr.Name
						thing.Parent = RadarMainFrame
					end
					
					local aliveplr = isAlive(plr)
					if aliveplr then
						local v238, v239 = radarcam:WorldToViewportPoint((CFrame.new(0, 0, 0):inverse() * aliveplr.RootPart.CFrame).p * 0.2)
						thing.Visible = true
						thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(RadarColor["Hue"], RadarColor["Sat"], RadarColor["Value"])
						thing.Position = UDim2.new(math.clamp(v238.X, 0.03, 0.97), -2, math.clamp(v238.Y, 0.03, 0.97), -2)
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("Radar")
			RadarMainFrame:ClearAllChildren()
		end
	end, 
	["Priority"] = 1
})


local function Cape(char, texture)
	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "Cape" then
			v:Remove()
		end
	end
	local hum = char:WaitForChild("Humanoid")
	local torso = nil
	if hum.RigType == Enum.HumanoidRigType.R15 then
	torso = char:WaitForChild("UpperTorso")
	else
	torso = char:WaitForChild("Torso")
	end
	local p = Instance.new("Part", torso.Parent)
	p.Name = "Cape"
	p.Anchored = false
	p.CanCollide = false
	p.TopSurface = 0
	p.BottomSurface = 0
	p.FormFactor = "Custom"
	p.Size = Vector3.new(0.2,0.2,0.2)
	p.Transparency = 1
	local decal = Instance.new("Decal", p)
	decal.Texture = texture
	decal.Face = "Back"
	local msh = Instance.new("BlockMesh", p)
	msh.Scale = Vector3.new(9,17.5,0.5)
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = CFrame.new(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
	local wave = false
	repeat wait(1/44)
		decal.Transparency = torso.Transparency
		local ang = 0.1
		local oldmag = torso.Velocity.magnitude
		local mv = 0.002
		if wave then
			ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
			wave = false
		else
			wave = true
		end
		ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
		motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
		motor.DesiredAngle = -ang
		if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
			motor.MaxVelocity = 0.04
		end
		repeat wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
		if torso.Velocity.magnitude < 0.1 then
			wait(0.1)
		end
	until not p or p.Parent ~= torso.Parent
end

local mousefunctions = mouse1release and mouse1press and (isrbxactive or iswindowactive) and true or false
runcode(function()
	local aimfov = {["Value"] = 1}
	local aimfovshow = {["Enabled"] = false}
	local aimvischeck = {["Enabled"] = false}
	local aimwallbang = {["Enabled"] = false}
	local aimautofire = {["Enabled"] = false}
	local aimsmartignore = {["Enabled"] = false}
	local aimprojectile = {["Enabled"] = false}
	local aimprojectilespeed = {["Value"] = 1000}
	local aimprojectilegravity = {["Value"] = 192.6}
	local aimsmartab = {}
	local aimfovframecolor = {["Value"] = 0.44}
	local aimfovfilled = {["Enabled"] = false}
	local aimheadshotchance = {["Value"] = 1}
	local aimassisttarget
	local aimhitchance = {["Value"] = 1}
	local aimmethod = {["Value"] = "FindPartOnRayWithIgnoreList"}
	local aimmode = {["Value"] = "Legit"}
	local aimmethodmode = {["Value"] = "Whitelist"}
	local aimignoredscripts = {["ObjectList"] = {}}
	local aimbound
	local shoottime = tick()
	local recentlyshotplr
	local recentlyshottick = tick()
	local aimfovframe
	local pressed = false
	local filterobj
	local tar = nil
	local AimAssist = {["Enabled"] = false}

	--skidded off the devforum because I hate projectile math
	-- Compute 2D launch angle
	-- v: launch velocity
	-- g: gravity (positive) e.g. 196.2
	-- d: horizontal distance
	-- h: vertical distance
	-- higherArc: if true, use the higher arc. If false, use the lower arc.
	local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
		local v2 = v * v
		local v4 = v2 * v2
		local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
		if not higherArc then root = -root end
		return math.atan((v2 + root) / (g * d))
	end

	-- Compute 3D launch direction from
	-- start: start position
	-- target: target position
	-- v: launch velocity
	-- g: gravity (positive) e.g. 196.2
	-- higherArc: if true, use the higher arc. If false, use the lower arc.
	local function LaunchDirection(start, target, v, g, higherArc: boolean)
		-- get the direction flattened:
		local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
		
		local h = target.Y - start.Y
		local d = horizontal.Magnitude
		local a = LaunchAngle(v, g, d, h, higherArc)
		
		-- NaN ~= NaN, computation couldn't be done (e.g. because it's too far to launch)
		if a ~= a then return nil end
		
		-- speed if we were just launching at a flat angle:
		local vec = horizontal.Unit * v
		
		-- rotate around the axis perpendicular to that direction...
		local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
		
		-- ...by the angle amount
		return CFrame.fromAxisAngle(rotAxis, a) * vec
	end

	local function FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, gravity: Number)
		local distance = (targetPosition - shooterPosition).Magnitude

		local p = targetPosition - shooterPosition
		local v = targetVelocity - shooterVelocity
		local a = Vector3.zero

		local timeTaken = (distance / projectileSpeed)
		
		if gravity > 0 then
			local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
		end

		local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
		local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
		local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
		
		return Vector3.new(goalX, goalY, goalZ)
	end

	local function isNotHoveringOverGui()
		local mousepos = uis:GetMouseLocation() - Vector2.new(0, 36)
		for i,v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		return true
	end
	local haha = RaycastParams.new()
	haha.FilterType = Enum.RaycastFilterType.Whitelist
	local silentaimfunctions = {
		FindPartOnRayWithIgnoreList = function(Args)
			local origin = Args[1].Origin
			local tar = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimheadshotchance["Value"] or aimautofire["Enabled"]) and "Head" or "HumanoidRootPart"
			local plr
			if aimmode["Value"] == "Legit" then
				plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
					WallCheck = aimvischeck["Enabled"],
					AimPart = tar,
					Origin = origin,
					IgnoreTable = aimsmartab
				})
			else
				plr = GetNearestHumanoidToPosition(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
					WallCheck = aimvischeck["Enabled"],
					AimPart = tar,
					Origin = origin,
					IgnoreTable = aimsmartab
				})
			end
			if not plr then
				return
			end
			tar = plr.Character[tar]
			recentlyshotplr = plr
			recentlyshottick = tick() + 1
			local direction = CFrame.lookAt(origin, tar.Position)
			if aimprojectile["Enabled"] then 
				local calculated = LaunchDirection(origin, FindLeadShot(tar.Position, tar.Velocity, aimprojectilespeed["Value"], origin, Vector3.zero, aimprojectilegravity["Value"]), aimprojectilespeed["Value"], aimprojectilegravity["Value"], false)
				if calculated then 
					direction = CFrame.lookAt(origin, origin + calculated)
				end
			end
			if aimwallbang["Enabled"] then
				return {tar, tar.Position, direction.lookVector * Args[1].Direction.Magnitude, tar.Material}
			end
			Args[1] = Ray.new(origin, direction.lookVector * Args[1].Direction.Magnitude)
			return
		end,
		Raycast = function(Args)
			local origin = Args[1]
			local ignoreobject = Args[3]
			local tar = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimheadshotchance["Value"] or aimautofire["Enabled"]) and "Head" or "HumanoidRootPart"
			local plr
			if aimmode["Value"] == "Legit" then
				plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
					WallCheck = aimvischeck["Enabled"],
					AimPart = tar,
					Origin = origin,
					IgnoreObject = ignoreobject
				})
			else
				plr = GetNearestHumanoidToPosition(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
					WallCheck = aimvischeck["Enabled"],
					AimPart = tar,
					Origin = origin,
					IgnoreObject = ignoreobject
				})
			end
			if not plr then
				return
			end
			tar = plr.Character[tar]
			recentlyshotplr = plr
			recentlyshottick = tick() + 1
			local direction = CFrame.lookAt(origin, tar.Position)
			if aimprojectile["Enabled"] then 
				local calculated = LaunchDirection(origin, FindLeadShot(tar.Position, tar.Velocity, aimprojectilespeed["Value"], origin, Vector3.zero, aimprojectilegravity["Value"]), aimprojectilespeed["Value"], aimprojectilegravity["Value"], false)
				if calculated then 
					direction = CFrame.lookAt(origin, origin + calculated)
				end
			end
			Args[2] = direction.lookVector * Args[2].Magnitude
			if aimwallbang["Enabled"] then
				haha.FilterDescendantsInstances = {tar}
				Args[3] = haha
			end
			return
		end,
		ScreenPointToRay = function(Args)
			local origin = cam.CFrame.p
			local tar = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimheadshotchance["Value"] or aimautofire["Enabled"]) and "Head" or "HumanoidRootPart"
			local plr
			if aimmode["Value"] == "Legit" then
				plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
					WallCheck = aimvischeck["Enabled"],
					AimPart = tar,
					Origin = origin,
					IgnoreTable = aimsmartab
				})
			else
				plr = GetNearestHumanoidToPosition(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
					WallCheck = aimvischeck["Enabled"],
					AimPart = tar,
					Origin = origin,
					IgnoreTable = aimsmartab
				})
			end
			if not plr then
				return
			end
			tar = plr.Character[tar]
			recentlyshotplr = plr
			recentlyshottick = tick() + 1
			local direction = CFrame.lookAt(origin, tar.Position)
			if aimprojectile["Enabled"] then 
				local calculated = LaunchDirection(origin, FindLeadShot(tar.Position, tar.Velocity, aimprojectilespeed["Value"], origin, Vector3.zero, aimprojectilegravity["Value"]), aimprojectilespeed["Value"], aimprojectilegravity["Value"], false)
				if calculated then 
					direction = CFrame.lookAt(origin, origin + calculated)
				end
			end
			return {Ray.new(direction.p + (Args[3] and direction.lookVector * Args[3] or Vector3.zero), direction.lookVector)}
		end
	}
	silentaimfunctions.FindPartOnRayWithWhitelist = silentaimfunctions.FindPartOnRayWithIgnoreList
	silentaimfunctions.FindPartOnRay = silentaimfunctions.FindPartOnRayWithIgnoreList
	silentaimfunctions.ViewportPointToRay = silentaimfunctions.ScreenPointToRay

	local silentaimenabled = {
		Normal = function()
			if not aimbound then
				aimbound = true
				local oldnamecall
				oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
					if (not AimAssist["Enabled"]) then
						return oldnamecall(self, ...)
					end
					local NamecallMethod = getnamecallmethod()
					if NamecallMethod ~= aimmethod["Value"] then
						return oldnamecall(self, ...)
					end 
					if checkcaller() then
						return oldnamecall(self, ...)
					end
					local calling = getcallingscript() 
					if calling then
						local list = #aimignoredscripts["ObjectList"] > 0 and aimignoredscripts["ObjectList"] or {"ControlScript", "ControlModule"}
						if table.find(list, tostring(calling)) then
							return oldnamecall(self, ...)
						end
					end
					local Args = {...}
					local res = silentaimfunctions[aimmethod["Value"]](Args)
					if res then 
						return unpack(res)
					end
					return oldnamecall(self, unpack(Args))
				end)
			end
		end,
		NormalV3 = function()
			if not aimbound then
				aimbound = true
				filterobj = NamecallFilter.new(aimmethod["Value"])
				local oldnamecall
				oldnamecall = hookmetamethod(game, "__namecall", getfilter(filterobj, function(self, ...) return oldnamecall(self, ...) end, function(self, ...)
					if (not AimAssist["Enabled"]) then
						return oldnamecall(self, ...)
					end
					if checkcaller() then
						return oldnamecall(self, ...)
					end
					local calling = getcallingscript() 
					if calling then
						local list = #aimignoredscripts["ObjectList"] > 0 and aimignoredscripts["ObjectList"] or {"ControlScript", "ControlModule"}
						if table.find(list, tostring(calling)) then
							return oldnamecall(self, ...)
						end
					end
					local Args = {...}
					local res = silentaimfunctions[aimmethod["Value"]](Args)
					if res then 
						return unpack(res)
					end
					return oldnamecall(self, unpack(Args))
				end))
			end
		end
	}

	local methodused
	AimAssist = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SilentAim", 
		["Function"] = function(callback) 
			if callback then
				methodused = "Normal"..v3check
				spawn(function()
					repeat
						task.wait(0.1)
						local targettable = {}
						local targetsize = 0
						if recentlyshotplr and recentlyshottick >= tick() then 
							local plr = recentlyshotplr
							if plr then
								targettable[plr.Player.Name] = {
									["UserId"] = plr.Player.UserId,
									["Health"] = plr.Humanoid.Health,
									["MaxHealth"] = plr.Humanoid.MaxHealth
								}
								targetsize = targetsize + 1
							end
						end
						targetinfo.UpdateInfo(targettable, targetsize)
					until (not AimAssist["Enabled"])
				end)
				if aimfovframe then
					aimfovframe.Visible = aimmode["Value"] ~= "Blatant"
				end
				if silentaimenabled[methodused] then 
					silentaimenabled[methodused]()
				end
			else
				tar = nil 
				if aimfovframe then
					aimfovframe.Visible = false
				end
			end
		end,
		["ExtraText"] = function() 
			return aimmethod["Value"]:gsub("FindPartOn", ""):gsub("PointToRay", "") 
		end
	})
	aimassisttarget = AimAssist.CreateTargetWindow({})
	aimmode = AimAssist.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Legit", "Blatant"},
		["Function"] = function(val) 
			if aimfovframe then
				aimfovframe.Visible = AimAssist["Enabled"] and val == "Legit"
			end
		end
	})
	aimmethodmode = AimAssist.CreateDropdown({
		["Name"] = "Method Type",
		["List"] = {"All", "Whitelist", "Blacklist"},
		["Function"] = function(val) end
	})
	aimmethodmode["Object"].Visible = false
	aimmethod = AimAssist.CreateDropdown({
		["Name"] = "Method", 
		["List"] = {"FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist", "Raycast", "FindPartOnRay", "ScreenPointToRay", "ViewportPointToRay"},
		["Function"] = function(val)
			aimmethodmode["Object"].Visible = val == "Raycast"
			if filterobj then 
				filterobj.NamecallMethod = val
			end
		end
	})
	aimfov = AimAssist.CreateSlider({
		["Name"] = "FOV", 
		["Min"] = 1, 
		["Max"] = 1000, 
		["Function"] = function(val) 
			if aimfovframe then
				aimfovframe.Radius = val
			end
		end,
		["Default"] = 80
	})
	aimhitchance = AimAssist.CreateSlider({
		["Name"] = "Hit Chance", 
		["Min"] = 1, 
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 100,
	})
	aimheadshotchance = AimAssist.CreateSlider({
		["Name"] = "Headshot Chance", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 25
	})
	local aimfovconnection
	aimfovshow = AimAssist.CreateToggle({
		["Name"] = "FOV Circle",
		["Function"] = function(callback) 
			if aimfovframecolor["Object"] then 
				aimfovframecolor["Object"].Visible = callback
			end
			if aimfovfilled["Object"] then 
				aimfovfilled["Object"].Visible = callback
			end
			if callback then
				aimfovframe = Drawing.new("Circle")
				aimfovframe.Transparency = 0.5
				aimfovframe.NumSides = 100
				aimfovframe.Filled = aimfovfilled["Enabled"]
				aimfovframe.Thickness = 1
				aimfovframe.Visible =  AimAssist["Enabled"] and aimmode["Value"] == "Legit"
				aimfovframe.Color = Color3.fromHSV(aimfovframecolor["Hue"], aimfovframecolor["Sat"], aimfovframecolor["Value"])
				aimfovframe.Radius = aimfov["Value"]
				aimfovframe.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
				aimfovconnection = cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					aimfovframe.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
				end)
			else
				if aimfovframe then
					aimfovframe:Remove()
				end
				if aimfovconnection then 
					aimfovconnection:Disconnect()
				end
			end
		end,
	})
	aimfovframecolor = AimAssist.CreateColorSlider({
		["Name"] = "Circle Color",
		["Function"] = function(hue, sat, val)
			if aimfovframe then
				aimfovframe.Color = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	aimfovframecolor["Object"].Visible = false
	aimfovfilled = AimAssist.CreateToggle({
		["Name"] = "Filled Circle",
		["Function"] = function(callback)
			if aimfovframe then
				aimfovframe.Filled = callback
			end
		end,
		["Default"] = true
	})
	aimfovfilled["Object"].Visible = false
	aimvischeck = AimAssist.CreateToggle({
		["Name"] = "Wall Check",
		["Function"] = function() end,
		["Default"] = true
	})
	aimwallbang = AimAssist.CreateToggle({
		["Name"] = "Wall Bang",
		["Function"] = function() end
	})
	aimautofire = AimAssist.CreateToggle({
		["Name"] = "AutoFire",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.01)
						if AimAssist["Enabled"] then
							local plr
							if aimmode["Value"] == "Legit" then
								plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
									WallCheck = aimvischeck["Enabled"],
									AimPart = "Head",
									Origin = cam.CFrame.p,
									IgnoreTable = aimsmartab
								})
							else
								plr = GetNearestHumanoidToPosition(aimassisttarget["Players"]["Enabled"], aimfov["Value"], {
									WallCheck = aimvischeck["Enabled"],
									AimPart = "Head",
									Origin = cam.CFrame.p,
									IgnoreTable = aimsmartab
								})
							end
							if plr then
								if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) and shoottime <= tick() then
									if isNotHoveringOverGui() and GuiLibrary["MainGui"]:FindFirstChild("ScaledGui") and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false and uis:GetFocusedTextBox() == nil then
										if pressed then
											mouse1release()
										else
											mouse1press()
										end
										pressed = not pressed
										shoottime = tick() + 0.001
									else
										if pressed then
											mouse1release()
										end
										pressed = false
									end
								end
							else
								if pressed then
									mouse1release()
								end
								pressed = false
							end
						end
					until (not aimautofire["Enabled"])
				end)
			end
		end,
		["HoverText"] = "Automatically fires gun",
	})
	aimprojectile = AimAssist.CreateToggle({
		["Name"] = "Projectile",
		["Function"] = function(callback)
			if aimprojectilespeed["Object"] then 
				aimprojectilespeed["Object"].Visible = callback
			end
			if aimprojectilegravity["Object"] then 
				aimprojectilegravity["Object"].Visible = callback
			end
		end
	})
	aimprojectilespeed = AimAssist.CreateSlider({
		["Name"] = "Projectile Speed",
		["Min"] = 1,
		["Max"] = 1000,
		["Default"] = 1000,
		["Function"] = function() end
	})
	aimprojectilespeed["Object"].Visible = false
	aimprojectilegravity = AimAssist.CreateSlider({
		["Name"] = "Projectile Gravity",
		["Min"] = 1,
		["Max"] = 192.6,
		["Default"] = 192.6,
		["Function"] = function() end
	})
	aimprojectilegravity["Object"].Visible = false
	local aimsmartconnection
	aimsmartignore = AimAssist.CreateToggle({
		["Name"] = "Smart Ignore",
		["Function"] = function(callback)
			if callback then
				aimsmartconnection = workspace.DescendantAdded:Connect(function(v)
					local lowername = v.Name:lower()
					if lowername:find("junk") or lowername:find("trash") or lowername:find("ignore") or lowername:find("particle") or lowername:find("spawn") or lowername:find("bullet") or lowername:find("debris") then
						table.insert(aimsmartab, v)
					end
				end)
				for i,v in pairs(workspace:GetDescendants()) do
					local lowername = v.Name:lower()
					if lowername:find("junk") or lowername:find("trash") or lowername:find("ignore") or lowername:find("particle") or lowername:find("spawn") or lowername:find("bullet") or lowername:find("debris") then
						table.insert(aimsmartab, v)
					end
				end
			else
				table.clear(aimsmartab)
				if aimsmartconnection then aimsmartconnection:Disconnect() end
			end
		end,
		["HoverText"] = "Ignores certain folders and what not with certain names"
	})
	aimignoredscripts = AimAssist.CreateTextList({
		["Name"] = "Ignored Scripts",
		["TempText"] = "ignored scripts", 
		["AddFunction"] = function(user) end, 
		["RemoveFunction"] = function(num) end
	})

	local function gettriggerbotplr()
		local rayparams = RaycastParams.new()
		rayparams.FilterDescendantsInstances = {lplr.Character, cam}
		local ray = workspace:Raycast(cam.CFrame.p, cam.CFrame.lookVector * 10000, rayparams)
		if ray and ray.Instance then
			for i,v in pairs(entity.entityList) do 
				if v.Targetable and v.Character then
					if ray.Instance:IsDescendantOf(v.Character) then
						return targetCheck(v) and v or nil
					end
				end
			end
		end
		return nil
	end

	local triggerbottick = tick()
	local triggerbotactivation = {["Value"] = 1}
	local triggerbot = {["Enabled"] = false}
	triggerbot = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "TriggerBot",
		["Function"] = function(callback)
			if callback then
				if mousefunctions then
					RunLoops:BindToStepped("TriggerBot", 1, function()
						local plr = gettriggerbotplr()
						if plr then
							if (isrbxactive or iswindowactive)() and shoottime <= tick() then
								if isNotHoveringOverGui() and GuiLibrary["MainGui"]:FindFirstChild("ScaledGui") and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false and uis:GetFocusedTextBox() == nil then
									if pressed then
										mouse1release()
									else
										mouse1press()
									end
									pressed = not pressed
									shoottime = tick() + 0.01
								else
									if pressed then
										mouse1release()
									end
									pressed = false
								end
							end
						else
							if (isrbxactive or iswindowactive)() and pressed then
								mouse1release()
							end
							pressed = false
						end
					end)
				else
					createwarning("TriggerBot", "Mouse functions missing", 5)
					if triggerbot["Enabled"] then
						triggerbot["ToggleButton"](false)
					end
				end
			else 
				if mousefunctions then 
					RunLoops:UnbindFromStepped("TriggerBot")
					if pressed then
						mouse1release()
					end
				end
				pressed = false
			end
		end
	})
end)

local autoclickercps = {["GetRandomValue"] = function() return 1 end}
local autoclicker = {["Enabled"] = false}
local autoclickermode = {["Value"] = "Sword"}
local autoclickertick = tick()
autoclicker = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "AutoClicker", 
	["Function"] = function(callback)
		if callback then
			RunLoops:BindToRenderStep("AutoClicker", 1, function() 
				if entity.isAlive and autoclickertick <= tick() then
					if autoclickermode["Value"] == "Tool" then
						local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
						if tool and uis:IsMouseButtonPressed(0) then
							tool:Activate()
							autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]()) * Random.new().NextNumber(Random.new(), 0.75, 1)
						end
					else
						if mousefunctions then
							if (isrbxactive or iswindowactive)() and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false then
								local clickfunc = (autoclickermode["Value"] == "Click" and mouse1click or mouse2click)
								clickfunc()
								autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]()) * Random.new().NextNumber(Random.new(), 0.75, 1)
							end
						else
							createwarning("AutoClicker", "Mouse functions missing", 5)
							if autoclicker["Enabled"] then
								autoclicker["ToggleButton"](false)
							end
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("AutoClicker")
		end
	end
})
autoclickermode = autoclicker.CreateDropdown({
	["Name"] = "Mode",
	["List"] = {"Tool", "Click", "RightClick"},
	["Function"] = function() end
})
autoclickercps = autoclicker.CreateTwoSlider({
	["Name"] = "CPS",
	["Min"] = 1,
	["Max"] = 20, 
	["Default"] = 8,
	["Default2"] = 12
})

runcode(function()
	local ClickTP = {["Enabled"] = false}
	local ClickTPMethod = {["Value"] = "Normal"}
	local ClickTPDelay = {["Value"] = 1}
	local ClickTPAmount = {["Value"] = 1}
	local ClickTPVertical = {["Enabled"] = true}
	local ClickTPVelocity = {["Enabled"] = false}
	ClickTP = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "MouseTP", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToHeartbeat("MouseTP", 1, function()
					if entity.isAlive and ClickTPVelocity["Enabled"] and ClickTPMethod["Value"] == "SlowTP" then 
						entity.character.HumanoidRootPart.Velocity = Vector3.new()
					end
				end)
				if entity.isAlive then 
					local rayparams = RaycastParams.new()
					rayparams.FilterDescendantsInstances = {lplr.Character, cam}
					rayparams.FilterType = Enum.RaycastFilterType.Blacklist
					local ray = workspace:Raycast(cam.CFrame.p, lplr:GetMouse().UnitRay.Direction * 10000, rayparams)
					local selectedpos = ray and ray.Position + Vector3.new(0, 2, 0)
					if selectedpos then 
						if ClickTPMethod["Value"] == "Normal" then
							entity.character.HumanoidRootPart.CFrame = CFrame.new(selectedpos)
							ClickTP["ToggleButton"](false)
						else
							spawn(function()
								repeat
									if entity.isAlive then 
										local newpos = (selectedpos - entity.character.HumanoidRootPart.CFrame.p).Unit
										newpos = newpos == newpos and newpos * (math.clamp((entity.character.HumanoidRootPart.CFrame.p - selectedpos).magnitude, 0, ClickTPAmount["Value"])) or Vector3.new()
										entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + Vector3.new(newpos.X, (ClickTPVertical["Enabled"] and newpos.Y or 0), newpos.Z)
										entity.character.HumanoidRootPart.Velocity = Vector3.new()
										if (entity.character.HumanoidRootPart.CFrame.p - selectedpos).magnitude <= 5 then 
											break
										end
									end
									task.wait(ClickTPDelay["Value"] / 100)
								until entity.isAlive and (entity.character.HumanoidRootPart.CFrame.p - selectedpos).magnitude <= 5 or (not ClickTP["Enabled"])
								if ClickTP["Enabled"] then 
									ClickTP["ToggleButton"](false)
								end
							end)
						end
					else
						ClickTP["ToggleButton"](false)
						createwarning("ClickTP", "No position found.", 1)
					end
				else
					if ClickTP["Enabled"] then 
						ClickTP["ToggleButton"](false)
					end
				end
			else
				RunLoops:UnbindFromHeartbeat("MouseTP")
			end
		end, 
		["HoverText"] = "Teleports to where your mouse is."
	})
	ClickTPMethod = ClickTP.CreateDropdown({
		["Name"] = "Method",
		["List"] = {"Normal", "SlowTP"},
		["Function"] = function(val)
			if ClickTPAmount["Object"] then
				ClickTPAmount["Object"].Visible = val == "SlowTP"
			end
			if ClickTPDelay["Object"] then
				ClickTPDelay["Object"].Visible = val == "SlowTP"
			end
			if ClickTPVertical["Object"] then 
				ClickTPVertical["Object"].Visible = val == "SlowTP"
			end
			if ClickTPVelocity["Object"] then 
				ClickTPVelocity["Object"].Visible = val == "SlowTP"
			end
		end
	})
	ClickTPAmount = ClickTP.CreateSlider({
		["Name"] = "Amount",
		["Min"] = 1,
		["Max"] = 50,
		["Function"] = function() end
	})
	ClickTPAmount["Object"].Visible = false
	ClickTPDelay = ClickTP.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 1,
		["Max"] = 50,
		["Function"] = function() end
	})
	ClickTPDelay["Object"].Visible = false
	ClickTPVertical = ClickTP.CreateToggle({
		["Name"] = "Vertical",
		["Default"] = true,
		["Function"] = function() end
	})
	ClickTPVertical["Object"].Visible = false
	ClickTPVelocity = ClickTP.CreateToggle({
		["Name"] = "No Velocity",
		["Default"] = true,
		["Function"] = function() end
	})
	ClickTPVelocity["Object"].Visible = false
end)
runcode(function()
	local flyspeed = {["Value"] = 1}
	local flyverticalspeed = {["Value"] = 1}
	local flytpoff = {["Value"] = 10}
	local flytpon = {["Value"] = 10}
	local flycframevelocity = {["Enabled"] = false}
	local flywall = {["Enabled"] = false}
	local flyupanddown = {["Enabled"] = false}
	local flymethod = {["Value"] = "Normal"}
	local flymovemethod = {["Value"] = "MoveDirection"}
	local flykeys = {["Value"] = "Space/LeftControl"}
	local flystate = {["Value"] = "Normal"}
	local flyplatformtoggle = {["Enabled"] = false}
	local flyplatformstanding = {["Enabled"] = false}
	local flyplatform
	local flyposy = 0
	local flyup = false
	local flydown = false
	local flypress
	local flyendpress
	local flyjumpcf = CFrame.new(0, 0, 0)
	local flyalivecheck = false
	local bodyvelofly
	local w = 0
	local s = 0
	local a = 0
	local d = 0
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B", "AntiCheat C"}
	local fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Fly", 
		["Function"] = function(callback)
			if callback then
				if entity.isAlive then
					flyposy = entity.character.HumanoidRootPart.CFrame.p.Y
					flyalivecheck = true
				end
				local changetick = tick() + 0.2
				w = uis:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = uis:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = uis:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = uis:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				flypress = uis.InputBegan:Connect(function(input1)
					if uis:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.W then
							w = -1
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = 1
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = -1
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = 1
						end
						if flyupanddown["Enabled"] then
							local divided = flykeys["Value"]:split("/")
							if input1.KeyCode == Enum.KeyCode[divided[1]] then
								flyup = true
							end
							if input1.KeyCode == Enum.KeyCode[divided[2]] then
								flydown = true
							end
						end
					end
				end)
				flyendpress = uis.InputEnded:Connect(function(input1)
					local divided = flykeys["Value"]:split("/")
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					end
					if input1.KeyCode == Enum.KeyCode.S then
						s = 0
					end
					if input1.KeyCode == Enum.KeyCode.A then
						a = 0
					end
					if input1.KeyCode == Enum.KeyCode.D then
						d = 0
					end
					if input1.KeyCode == Enum.KeyCode[divided[1]] then
						flyup = false
					end
					if input1.KeyCode == Enum.KeyCode[divided[2]] then
						flydown = false
					end
				end)
				if flymethod["Value"] == "Jump" and entity.isAlive then
					entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				local flytog = false
				local flytogtick = tick()
				local oldflypos
				RunLoops:BindToHeartbeat("Fly", 1, function(delta) 
					if entity.isAlive then
						entity.character.Humanoid.PlatformStand = flyplatformstanding["Enabled"]
						if flyalivecheck == false then
							flyposy = entity.character.HumanoidRootPart.CFrame.p.Y
							flyalivecheck = true
						end
						local movevec = (flymovemethod["Value"] == "Manual" and (CFrame.lookAt(cam.CFrame.p, cam.CFrame.p + Vector3.new(cam.CFrame.lookVector.X, 0, cam.CFrame.lookVector.Z))):VectorToWorldSpace(Vector3.new(a + d, 0, w + s)) or entity.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.new()
						if flystate["Value"] ~= "None" then 
							entity.character.Humanoid:ChangeState(Enum.HumanoidStateType[flystate["Value"]])
						end
						if flymethod["Value"] == "Normal" or flymethod["Value"] == "Bounce" then
							if flyplatformstanding["Enabled"] then
								entity.character.HumanoidRootPart.CFrame = CFrame.new(entity.character.HumanoidRootPart.CFrame.p, entity.character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector)
								entity.character.HumanoidRootPart.RotVelocity = Vector3.new()
							end
							local bounce = 0
							if flymethod["Value"] == "Bounce" then 
								bounce = tick() % 0.5 > 0.25 and -10 or 10
							end
							entity.character.HumanoidRootPart.Velocity = (movevec * flyspeed["Value"]) + Vector3.new(0, 0.85 + bounce + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0)
						else
							if flyup then
								flyposy = flyposy + (flyverticalspeed["Value"] * delta)
							end
							if flydown then
								flyposy = flyposy - (flyverticalspeed["Value"] * delta)
							end
							local flypos = (movevec * (math.clamp(flyspeed["Value"] - entity.character.Humanoid.WalkSpeed, 0, 1000000000000) * delta))
							flypos = Vector3.new(flypos.X, (flyposy - entity.character.HumanoidRootPart.CFrame.p.Y), flypos.Z)
							if flywall["Enabled"] then
								local raycastparameters = RaycastParams.new()
								raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
								raycastparameters.FilterDescendantsInstances = {lplr.Character, cam}
								local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, flypos, raycastparameters)
								if ray then flypos = (ray.Position - entity.character.HumanoidRootPart.Position) flyposy = entity.character.HumanoidRootPart.CFrame.p.Y end
							end
							local origvelo = entity.character.HumanoidRootPart.Velocity
							if flymethod["Value"] == "CFrame" then
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + flypos
								if flycframevelocity["Enabled"] then 
									entity.character.HumanoidRootPart.Velocity = Vector3.new(origvelo.X, 0, origvelo.Z)
								end
								if flyplatformstanding["Enabled"] then
									entity.character.HumanoidRootPart.CFrame = CFrame.new(entity.character.HumanoidRootPart.CFrame.p, entity.character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector)
								end
							elseif flymethod["Value"] == "Jump" then
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + Vector3.new(flypos.X, 0, flypos.Z)
								if entity.character.HumanoidRootPart.Velocity.Y < -(entity.character.Humanoid.JumpPower - ((flyup and flyverticalspeed["Value"] or 0) - (flydown and flyverticalspeed["Value"] or 0))) then
									flyjumpcf = entity.character.HumanoidRootPart.CFrame * CFrame.new(0, -entity.character.Humanoid.HipHeight, 0)
									entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							else
								if flytogtick <= tick() then 
									flytog = not flytog
									if flytog then
										if oldflypos then
											flyposy = oldflypos
										end
									else
										oldflypos = flyposy
										local raycastparameters = RaycastParams.new()
										raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
										raycastparameters.FilterDescendantsInstances = {lplr.Character, cam}
										local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, Vector3.new(0, -10000, 0), raycastparameters)
										if ray then flyposy = ray.Position.Y + 3 end
									end
									flytogtick = tick() + ((flytog and flytpon["Value"] or flytpoff["Value"]) / 10)
								end
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + flypos
								if flyplatformstanding["Enabled"] then
									entity.character.HumanoidRootPart.CFrame = CFrame.new(entity.character.HumanoidRootPart.CFrame.p, entity.character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector)
								end
							end
						end
						if flyplatform then
							flyplatform.CFrame = (flymethod["Value"] == "Jump" and flyjumpcf or entity.character.HumanoidRootPart.CFrame * CFrame.new(0, -entity.character.Humanoid.HipHeight - 1.52, 0))
							flyplatform.Parent = cam
							if flyup or changetick >= tick() then 
								entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							end
						end
					else
						flyalivecheck = false
					end
				end)
			else
				flyup = false
				flydown = false
				flyalivecheck = false
				flypress:Disconnect()
				flyendpress:Disconnect()
				RunLoops:UnbindFromHeartbeat("Fly")
				if entity.isAlive then
					entity.character.Humanoid.PlatformStand = false
				end
				if flyplatform then
					flyplatform.Parent = nil
					entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
				end
			end
		end,
		["ExtraText"] = function() 
			if GuiLibrary["ObjectsThatCanBeSaved"]["Text GUIAlternate TextToggle"]["Api"]["Enabled"] then 
				return alternatelist[table.find(flymethod["List"], flymethod["Value"])]
			end
			return flymethod["Value"] 
		end
	})
	flymethod = fly.CreateDropdown({
		["Name"] = "Mode", 
		["List"] = {"Normal", "CFrame", "Jump", "TP", "Bounce"},
		["Function"] = function(val)
			if entity.isAlive then
				flyposy = entity.character.HumanoidRootPart.CFrame.p.Y
			end
			if flytpon["Object"] then 
				flytpon["Object"].Visible = val == "TP"
			end
			if flytpoff["Object"] then 
				flytpoff["Object"].Visible = val == "TP"
			end
			if flywall["Object"] then 
				flywall["Object"].Visible = val == "CFrame" or val == "Jump"
			end
			if flycframevelocity["Object"] then 
				flycframevelocity["Object"].Visible = val == "CFrame"
			end
		end
	})
	flymovemethod = fly.CreateDropdown({
		["Name"] = "Movement", 
		["List"] = {"Manual", "MoveDirection"},
		["Function"] = function(val) end
	})
	flykeys = fly.CreateDropdown({
		["Name"] = "Keys", 
		["List"] = {"Space/LeftControl", "Space/LeftShift", "E/Q", "Space/Q"},
		["Function"] = function(val) end
	})
	local states = {"None"}
	for i,v in pairs(Enum.HumanoidStateType:GetEnumItems()) do if v.Name ~= "Dead" and v.Name ~= "None" then table.insert(states, v.Name) end end
	flystate = fly.CreateDropdown({
		["Name"] = "State", 
		["List"] = states,
		["Function"] = function(val) end
	})
	flyspeed = fly.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 150, 
		["Function"] = function(val) end
	})
	flyverticalspeed = fly.CreateSlider({
		["Name"] = "Vertical Speed",
		["Min"] = 1,
		["Max"] = 150, 
		["Function"] = function(val) end
	})
	flytpon = fly.CreateSlider({
		["Name"] = "TP Time Ground",
		["Min"] = 1,
		["Max"] = 100,
		["Default"] = 50,
		["Function"] = function() end,
		["Double"] = 10
	})
	flytpon["Object"].Visible = false
	flytpoff = fly.CreateSlider({
		["Name"] = "TP Time Air",
		["Min"] = 1,
		["Max"] = 30,
		["Default"] = 5,
		["Function"] = function() end,
		["Double"] = 10
	})
	flytpoff["Object"].Visible = false
	flyplatformtoggle = fly.CreateToggle({
		["Name"] = "FloorPlatform", 
		["Function"] = function(callback)
			if callback then
				flyplatform = Instance.new("Part")
				flyplatform.Anchored = true
				flyplatform.CanCollide = true
				flyplatform.Size = Vector3.new(2, 1, 2)
				flyplatform.Transparency = 1
			else
				if flyplatform then 
					flyplatform:Destroy()
					flyplatform = nil 
				end
			end
		end
	})
	flyplatformstanding = fly.CreateToggle({
		["Name"] = "PlatformStand",
		["Function"] = function() end
	})
	flyupanddown = fly.CreateToggle({
		["Name"] = "Y Level", 
		["Function"] = function() end
	})
	flywall = fly.CreateToggle({
		["Name"] = "Wall Check",
		["Function"] = function() end,
		["Default"] = true
	})
	flywall["Object"].Visible = false
	flycframevelocity = fly.CreateToggle({
		["Name"] = "No Velocity",
		["Function"] = function() end,
		["Default"] = true
	})
	flycframevelocity["Object"].Visible = false
end)

local hitboxexpand = {["Value"] = 1}
local hitboxoption = {["Value"] = "HumanoidRootPart"}
local Hitbox =  GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "HitBoxes", 
	["Function"] = function(callback)
		if callback then
			RunLoops:BindToRenderStep("HitBoxes", 1, function() 
				for i,plr in pairs(entity.entityList) do
					if plr.Targetable then
						if hitboxoption["Value"] == "HumanoidRootPart" then
							plr.RootPart.Size = Vector3.new(2 * (hitboxexpand["Value"] / 10), 2 * (hitboxexpand["Value"] / 10), 1 * (hitboxexpand["Value"] / 10))
						else
							plr.Head.Size = Vector3.new((hitboxexpand["Value"] / 10), (hitboxexpand["Value"] / 10), (hitboxexpand["Value"] / 10))
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("HitBoxes") 
			for i,plr in pairs(players:GetChildren()) do
				local aliveplr = isAlive(plr)
				if aliveplr then
					aliveplr.RootPart.Size = Vector3.new(2, 2, 1)
					aliveplr.Head.Size = Vector3.new(1, 1, 1)
				end
			end
		end
	end
})
hitboxexpand = Hitbox.CreateSlider({
	["Name"] = "Expand amount",
	["Min"] = 10,
	["Max"] = 50,
	["Function"] = function(val) end
})
hitboxoption = Hitbox.CreateDropdown({
	["Name"] = "Expand part",
	["List"] = {"HumanoidRootPart", "Head"},
	["Function"] = function()
		if Hitbox["Enabled"] then 
			for i,plr in pairs(players:GetChildren()) do
				local aliveplr = isAlive(plr)
				if aliveplr then
					aliveplr.RootPart.Size = Vector3.new(2, 2, 1)
					aliveplr.Head.Size = Vector3.new(1, 1, 1)
				end
			end
		end
	end
})

local killauranear = false
runcode(function()
	local ignorelist = OverlapParams.new()
	ignorelist.FilterType = Enum.RaycastFilterType.Whitelist

	local reachrange = {["Value"] = 1}
	local Reach = {["Enabled"] = false}
	Reach = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Reach", 
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
						if tool and entity.isAlive then
							local touch = findTouchInterest(tool)
							if touch then
								touch = touch.Parent
								local chars = {}
								for i,v in pairs(entity.entityList) do table.insert(chars, v.Character) end
								ignorelist.FilterDescendantsInstances = chars
								local parts = workspace:GetPartBoundsInBox(touch.CFrame, touch.Size + Vector3.new(reachrange["Value"], 0, reachrange["Value"]), ignorelist)
								for i,v in pairs(parts) do 
									firetouchinterest(touch, v, 1)
									firetouchinterest(touch, v, 0)
								end
							end
						end
					until (not Reach["Enabled"])
				end)
			end
		end
	})
	reachrange = Reach.CreateSlider({
		["Name"] = "Range", 
		["Min"] = 1,
		["Max"] = 20, 
		["Function"] = function(val) end,
	})

	local killauraboxes = {}
	local killauraaps = {["GetRandomValue"] = function() return 1 end}
	local killauramethod = {["Value"] = "Normal"}
	local killauratarget = {["Enabled"] = false}
	local killauratargethighlight = {["Enabled"] = false}
	local killaurarangecircle = {["Enabled"] = false}
	local killaurarangecirclepart
	local killauracolor = {["Value"] = 0.44}
	local killaurarange = {["Value"] = 1}
	local killauraangle = {["Value"] = 90}
	local killauramouse = {["Enabled"] = false}
	local killauratargetframe = {["Players"] = {["Enabled"] = false}}
	local killauracframe = {["Enabled"] = false}
	local Killaura = {["Enabled"] = false}
	local killauratick = tick()

	local function getclosestpart(v, tool)
		if entity.isAlive then
			local closest, closestmag = nil, 10000000
			for i,v2 in pairs(v.Character:GetChildren()) do 
				if v2:IsA("BasePart") then
					local mag = (v2.Position - tool.Position)
				end
			end
		end
	end

	Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Killaura", 
		["Function"] = function(callback)
			if callback then
				local targetedplayer
				RunLoops:BindToHeartbeat("Killaura", 1, function()
					for i,v in pairs(killauraboxes) do 
						if v:IsA("BoxHandleAdornment") and v.Adornee then
							local cf = v.Adornee and v.Adornee.CFrame
							local onex, oney, onez = cf:ToEulerAnglesXYZ() 
							v.CFrame = CFrame.new() * CFrame.Angles(-onex, -oney, -onez)
						end
					end
					if entity.isAlive then
						if killauraaimcirclepart then 
							killauraaimcirclepart.Position = targetedplayer and closestpos(targetedplayer.RootPart, entity.character.HumanoidRootPart.Position) or Vector3.zero
						end
						local Root = entity.character.HumanoidRootPart
						if Root then
							if killaurarangecirclepart then 
								killaurarangecirclepart.Position = Root.Position - Vector3.new(0, entity.character.Humanoid.HipHeight, 0)
							end
							local Neck = entity.character.Head:FindFirstChild("Neck")
							local LowerTorso = Root.Parent and Root.Parent:FindFirstChild("LowerTorso")
							local RootC0 = LowerTorso and LowerTorso:FindFirstChild("Root")
							if Neck and RootC0 then
								if orig == nil then
									orig = Neck.C0.p
								end
								if orig2 == nil then
									orig2 = RootC0.C0.p
								end
								if orig2 then
									if targetedplayer ~= nil and killauracframe["Enabled"] then
										local targetPos = targetedplayer.RootPart.Position + Vector3.new(0, 2, 0)
										local direction = (Vector3.new(targetPos.X, targetPos.Y, targetPos.Z) - entity.character.Head.Position).Unit
										local direction2 = (Vector3.new(targetPos.X, Root.Position.Y, targetPos.Z) - Root.Position).Unit
										local lookCFrame = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace(direction)))
										local lookCFrame2 = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace(direction2)))
										Neck.C0 = CFrame.new(orig) * CFrame.Angles(lookCFrame.LookVector.Unit.y, 0, 0)
										RootC0.C0 = lookCFrame2 + orig2
									else
										Neck.C0 = CFrame.new(orig)
										RootC0.C0 = CFrame.new(orig2)
									end
								end
							end
						end
					end
				end)
				task.spawn(function()
					repeat
						task.wait()
						if (not Killaura["Enabled"]) then break end
						local targettable = {}
						local targetsize = 0
						local attackedplayers = {}
						if entity.isAlive then
							local plrs = GetAllNearestHumanoidToPosition(killauratargetframe["Players"]["Enabled"], killaurarange["Value"], 100)
							if #plrs > 0 then
								local tool = lplr.Character:FindFirstChildWhichIsA("Tool")
								local touch = findTouchInterest(tool)
								if tool and touch then
									if (not killauramouse["Enabled"]) or uis:IsMouseButtonPressed(0) then 
										for i,v in pairs(plrs) do
											local localfacing = entity.character.HumanoidRootPart.CFrame.lookVector
											local vec = (v.RootPart.Position - entity.character.HumanoidRootPart.Position).unit
											local angle = math.acos(localfacing:Dot(vec))
											if angle <= math.rad(killauraangle["Value"]) then
												killauranear = true
												targettable[v.Player.Name] = {
													["UserId"] = v.Player.UserId,
													["Health"] = v.Character.Humanoid.Health,
													["MaxHealth"] = v.Character.Humanoid.MaxHealth
												}
												targetsize = targetsize + 1
												if killauratarget["Enabled"] then
													table.insert(attackedplayers, v)
												end
												if targetsize == 1 then 
													targetedplayer = v
												end
												local playertype, playerattackable = WhitelistFunctions:CheckPlayerType(v.Player)
												if not playerattackable then
													continue
												end
												if killauratick <= tick() then
													tool:Activate()
													killauratick = tick() + (1 / killauraaps["GetRandomValue"]())
												end
												if killauramethod["Value"] == "Bypass" then 
													ignorelist.FilterDescendantsInstances = {v.Character}
													local parts = workspace:GetPartBoundsInBox(v.RootPart.CFrame, v.Character:GetExtentsSize(), ignorelist)
													for i,v2 in pairs(parts) do 
														firetouchinterest(touch.Parent, v2, 1)
														firetouchinterest(touch.Parent, v2, 0)
													end
												elseif killauramethod["Value"] == "Normal" then
													for i,v2 in pairs(v.Character:GetChildren()) do 
														if v2:IsA("BasePart") then
															firetouchinterest(touch.Parent, v2, 1)
															firetouchinterest(touch.Parent, v2, 0)
														end
													end
												else
													firetouchinterest(touch.Parent, v.RootPart, 1)
													firetouchinterest(touch.Parent, v.RootPart, 0)
												end
											end
										end
									end
								end
							end
							for i,v in pairs(killauraboxes) do 
								local attacked = attackedplayers[i]
								v.Adornee = attacked and ((not killauratargethighlight["Enabled"]) and attacked.RootPart or (not GuiLibrary["ObjectsThatCanBeSaved"]["ChamsOptionsButton"]["Api"]["Enabled"]) and attacked.Character or nil)
							end
							if (#plrs <= 0) then
								lastplr = nil
								targetedplayer = nil
								killauranear = false
							end
						end
						targetinfo.UpdateInfo(targettable, targetsize)
					until (not Killaura["Enabled"])
				end)
			else
				RunLoops:UnbindFromHeartbeat("Killaura") 
                killauranear = false
				for i,v in pairs(killauraboxes) do 
					v.Adornee = nil
				end
				if killaurarangecirclepart then 
					killaurarangecirclepart.Parent = nil
				end
			end
		end,
		["HoverText"] = "Attack players around you\nwithout aiming at them."
	})
	killauratargetframe = Killaura.CreateTargetWindow({})
	killauramethod = Killaura.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Normal", "Bypass", "Root Only"},
		["Function"] = function() end
	})
	killauraaps = Killaura.CreateTwoSlider({
		["Name"] = "Attacks per second",
		["Min"] = 1,
		["Max"] = 20,
		["Default"] = 8,
		["Default2"] = 12
	})
	killaurarange = Killaura.CreateSlider({
		["Name"] = "Attack range",
		["Min"] = 1,
		["Max"] = 150, 
		["Function"] = function(val) 
			if killaurarangecirclepart then 
				killaurarangecirclepart.Size = Vector3.new(val * 0.7, 0.01, val * 0.7)
			end
		end
	})
	killauraangle = Killaura.CreateSlider({
		["Name"] = "Max angle",
		["Min"] = 1,
		["Max"] = 360, 
		["Function"] = function(val) end,
		["Default"] = 90
	})
	killauramouse = Killaura.CreateToggle({
		["Name"] = "Require mouse down", 
		["Function"] = function() end
	})
	killauratarget = Killaura.CreateToggle({
        ["Name"] = "Show target",
        ["Function"] = function(callback) 
			if killauratargethighlight["Object"] then 
				killauratargethighlight["Object"].Visible = callback
			end
		end,
		["HoverText"] = "Shows a red box over the opponent."
    })
	killauratargethighlight = Killaura.CreateToggle({
		["Name"] = "Use New Highlight",
		["Function"] = function(callback) 
			for i,v in pairs(killauraboxes) do 
				v:Remove()
			end
			for i = 1, 10 do 
				local killaurabox
				if callback then 
					killaurabox = Instance.new("Highlight")
					killaurabox.FillTransparency = 0.5
					killaurabox.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					killaurabox.OutlineTransparency = 1
					killaurabox.Parent = GuiLibrary["MainGui"]
				else
					killaurabox = Instance.new("BoxHandleAdornment")
					killaurabox.Transparency = 0.5
					killaurabox.Color3 = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor["Value"])
					killaurabox.Adornee = nil
					killaurabox.AlwaysOnTop = true
					killaurabox.Size = Vector3.new(3, 6, 3)
					killaurabox.ZIndex = 11
					killaurabox.Parent = GuiLibrary["MainGui"]
				end
				killauraboxes[i] = killaurabox
			end
		end
	})
	killauratargethighlight["Object"].BorderSizePixel = 0
	killauratargethighlight["Object"].BackgroundTransparency = 0
	killauratargethighlight["Object"].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	killauratargethighlight["Object"].Visible = false
	killauracolor = Killaura.CreateColorSlider({
		["Name"] = "Target Color",
		["Function"] = function(hue, sat, val) 
			for i,v in pairs(killauraboxes) do 
				v[(killauratargethighlight["Enabled"] and "FillColor" or "Color3")] = Color3.fromHSV(hue, sat, val)
			end
			if killauraaimcirclepart then 
				killauraaimcirclepart.Color = Color3.fromHSV(hue, sat, val)
			end
			if killaurarangecirclepart then 
				killaurarangecirclepart.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		["Default"] = 1
	})
	for i = 1, 10 do 
		local killaurabox = Instance.new("BoxHandleAdornment")
		killaurabox.Transparency = 0.5
		killaurabox.Color3 = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor["Value"])
		killaurabox.Adornee = nil
		killaurabox.AlwaysOnTop = true
		killaurabox.Size = Vector3.new(3, 6, 3)
		killaurabox.ZIndex = 11
		killaurabox.Parent = GuiLibrary["MainGui"]
		killauraboxes[i] = killaurabox
	end
    killauracframe = Killaura.CreateToggle({
        ["Name"] = "Face target",
        ["Function"] = function() end,
		["HoverText"] = "Makes your character face the opponent."
    })
	killaurarangecircle = Killaura.CreateToggle({
		["Name"] = "Range Visualizer",
		["Function"] = function(callback)
			if callback then 
				killaurarangecirclepart = Instance.new("MeshPart")
				killaurarangecirclepart.MeshId = "rbxassetid://3726303797"
				killaurarangecirclepart.Color = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor["Value"])
				killaurarangecirclepart.CanCollide = false
				killaurarangecirclepart.Anchored = true
				killaurarangecirclepart.Material = Enum.Material.Neon
				killaurarangecirclepart.Size = Vector3.new(killaurarange["Value"] * 0.7, 0.01, killaurarange["Value"] * 0.7)
				killaurarangecirclepart.Parent = cam
			else
				if killaurarangecirclepart then 
					killaurarangecirclepart:Destroy()
					killaurarangecirclepart = nil
				end
			end
		end
	})
end)

local longjumpboost = {["Value"] = 1}
local longjump = {["Enabled"] = false}
local longjumpchange = true
longjump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "LongJump", 
	["Function"] = function(callback)
		if callback then
			if entity.isAlive and entity.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
				entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
			RunLoops:BindToHeartbeat("LongJump", 1, function() 
				if entity.isAlive then
					if (entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall or entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping) and entity.character.Humanoid.MoveDirection ~= Vector3.new() then
						local velo = entity.character.Humanoid.MoveDirection * longjumpboost["Value"]
						entity.character.HumanoidRootPart.Velocity = Vector3.new(velo.X, entity.character.HumanoidRootPart.Velocity.Y, velo.Z)
					end
					local check = entity.character.Humanoid.FloorMaterial ~= Enum.Material.Air
					if longjumpchange ~= check then 
						if check then 
							longjump["ToggleButton"](true)
						end
						longjumpchange = check
					end
				end
			end)
		else
			RunLoops:UnbindFromHeartbeat("LongJump")
			longjumpchange = true
		end
	end
})
longjumpboost = longjump.CreateSlider({
	["Name"] = "Boost",
	["Min"] = 1,
	["Max"] = 150, 
	["Function"] = function(val) end
})

local HighJumpMethod = {["Value"] = "Toggle"}
local HighJumpBoost = {["Value"] = 1}
local HighJumpDelay = {["Value"] = 20}
local HighJumpTick = tick()
local highjumpbound = true
local HighJump = {["Enabled"] = false}
HighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "HighJump", 
	["Function"] = function(callback)
		if callback then
			highjumpbound = false
			if HighJumpMethod["Value"] == "Toggle" then
				if HighJumpTick > tick()  then
					createwarning("LongJump", "Wait "..math.round(HighJumpTick - tick()).." before retoggling.", 1)
				end
				if HighJumpTick <= tick() and entity.isAlive and (entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Running or entity.character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) then
					HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
					entity.character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
				end
				HighJump["ToggleButton"](false)
			else
				highjumpbound = true
				RunLoops:BindToRenderStep("HighJump", 1, function()
					if HighJumpTick <= tick() and entity.isAlive and (entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Running or entity.character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) and uis:IsKeyDown(Enum.KeyCode.Space) then
						HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
						entity.character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
					end
				end)
			end
		else
			if highjumpbound then
				RunLoops:UnbindFromRenderStep("HighJump")
			end
		end
	end,
	["HoverText"] = "Lets you jump higher"
})
HighJumpMethod = HighJump.CreateDropdown({
	["Name"] = "Mode", 
	["List"] = {"Toggle", "Normal"},
	["Function"] = function(val) end
})
HighJumpBoost = HighJump.CreateSlider({
	["Name"] = "Boost",
	["Min"] = 1,
	["Max"] = 150, 
	["Function"] = function(val) end,
	["Default"] = 100
})
HighJumpDelay = HighJump.CreateSlider({
	["Name"] = "Delay",
	["Min"] = 0,
	["Max"] = 50, 
	["Function"] = function(val) end,
})


local phase = {["Enabled"] = false}
local spidergoinup = false
local holdingshift = false
local phasemode = {["Value"] = "Normal"}
local phaselimit = {["Value"] = 1}
local phaseparts = {}

phase = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Phase", 
	["Function"] = function(callback)
		if callback then
			RunLoops:BindToStepped("Phase", 1, function() -- has to be ran on stepped idk why
				if entity.isAlive then
					if phasemode["Value"] == "Normal" then
						for i, part in pairs(lplr.Character:GetDescendants()) do
							if part:IsA("BasePart") and part.CanCollide == true then
								phaseparts[part] = true
								part.CanCollide = (GuiLibrary["ObjectsThatCanBeSaved"]["SpiderOptionsButton"]["Api"]["Enabled"] and (not holdingshift))
							end
						end
					else
						local chars = {cam}
						for i,v in pairs(players:GetChildren()) do
							table.insert(chars, v.Character)
						end
						local pos = entity.character.HumanoidRootPart.CFrame.p - Vector3.new(0, 1, 0)
						local pos2 = entity.character.HumanoidRootPart.CFrame.p + Vector3.new(0, 1, 0)
						local pos3 = entity.character.Head.CFrame.p
						local raycastparameters = RaycastParams.new()
						raycastparameters.FilterDescendantsInstances = chars
						raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
						local newray = workspace:Raycast(pos3, entity.character.Humanoid.MoveDirection, raycastparameters)
						if newray and (GuiLibrary["ObjectsThatCanBeSaved"]["SpiderOptionsButton"]["Api"]["Enabled"] and holdingshift or GuiLibrary["ObjectsThatCanBeSaved"]["SpiderOptionsButton"]["Api"]["Enabled"] == false) then
							local dir = newray.Normal.Z ~= 0 and "Z" or "X"
							if newray.Instance.Size[dir] <= phaselimit["Value"] and newray.Instance.CanCollide then
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + (newray.Normal * (-(newray.Instance.Size[dir]) - 2))
							end
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromStepped("Phase")
			for i,v in pairs(phaseparts) do
				if i then
					i.CanCollide = true
				end
			end
			table.clear(phaseparts)
		end
	end,
	["HoverText"] = "Lets you Phase/Clip through walls. (Hold shift to use phase over spider)"
})
phasemode = phase.CreateDropdown({
	["Name"] = "Mode",
	["List"] = {"Normal", "AntiCheat"},
	["Function"] = function(val) 
		if phaselimit["Object"] then
			phaselimit["Object"].Visible = val == "AntiCheat"
		end
	end
})
phaselimit = phase.CreateSlider({
	["Name"] = "Studs",
	["Function"] = function() end,
	["Min"] = 1,
	["Max"] = 20,
	["Default"] = 5,
})
phaselimit["Object"].Visible = phasemode["Value"] == "AntiCheat"


runcode(function()
	local spiderspeed = {["Value"] = 0}
	local spiderstate = {["Enabled"] = false}
	Spider = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Spider",
		["Function"] = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("Spider", 1, function()
					if entity.isAlive then
						local chars = {cam}
						for i,v in pairs(players:GetChildren()) do
							table.insert(chars, v.Character)
						end
						local vec = (entity.character.Humanoid.MoveDirection ~= Vector3.new() and entity.character.Humanoid.MoveDirection.Unit * 2 or Vector3.new())
						local raycastparameters = RaycastParams.new()
						raycastparameters.FilterDescendantsInstances = chars
						raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
						local newray = workspace:Raycast(entity.character.HumanoidRootPart.Position, vec + Vector3.new(0, 0.1, 0), raycastparameters)
						local newray2 = workspace:Raycast(entity.character.HumanoidRootPart.Position, vec - Vector3.new(0, entity.character.Humanoid.HipHeight, 0), raycastparameters)
						if spidergoinup and (not newray) and (not newray2) then
							entity.character.HumanoidRootPart.Velocity = Vector3.new(entity.character.HumanoidRootPart.Velocity.X, 0, entity.character.HumanoidRootPart.Velocity.Z)
						end
						spidergoinup = ((newray or newray2) and true or false)
						holdingshift = uis:IsKeyDown(Enum.KeyCode.LeftShift)
						if (newray or newray2) and (newray or newray2).Normal.Y == 0 then
							if (newray or newray2) and (GuiLibrary["ObjectsThatCanBeSaved"]["PhaseOptionsButton"]["Api"]["Enabled"] and holdingshift == false or GuiLibrary["ObjectsThatCanBeSaved"]["PhaseOptionsButton"]["Api"]["Enabled"] == false) then
								if spiderstate["Enabled"] then 
									entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
								end
								entity.character.HumanoidRootPart.Velocity = Vector3.new(entity.character.HumanoidRootPart.Velocity.X - (entity.character.HumanoidRootPart.CFrame.lookVector.X / 2), spiderspeed["Value"], entity.character.HumanoidRootPart.Velocity.Z - (entity.character.HumanoidRootPart.CFrame.lookVector.Z / 2))
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("Spider")
			end
		end,
		["HoverText"] = "Lets you climb up walls"
	})
	spiderspeed = Spider.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 0,
		["Max"] = 100,
		["Function"] = function() end,
		["Default"] = 30
	})
	spiderstate = Spider.CreateToggle({
		["Name"] = "Climb State",
		["Function"] = function() end
	})
end)

runcode(function()
	local speedval = {["Value"] = 1}
	local speedmethod = {["Value"] = "AntiCheat A"}
	local speedmovemethod = {["Value"] = "MoveDirection"}
	local speeddelay = {["Value"] = 0.7}
	local speedpulseduration = {["Value"] = 100}
	local speedwallcheck = {["Enabled"] = true}
	local speedjump = {["Enabled"] = false}
	local speedjumpheight = {["Value"] = 20}
	local speedjumpvanilla = {["Enabled"] = false}
	local speedjumpalways = {["Enabled"] = false}
	local speedup
	local speeddown
	local oldwalkspeed
	local w = 0
	local s = 0
	local a = 0
	local d = 0
	local bodyvelo
	local speeddelayval = tick()

	local speed = {["Enabled"] = false}
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B", "AntiCheat C", "AntiCheat D"}
	speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed", 
		["Function"] = function(callback)
			if callback then
				w = uis:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = uis:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = uis:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = uis:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				speeddown = uis.InputBegan:Connect(function(input1)
					if uis:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.W then
							w = -1
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = 1
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = -1
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = 1
						end
					end
				end)
				speedup = uis.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					end
					if input1.KeyCode == Enum.KeyCode.S then
						s = 0
					end
					if input1.KeyCode == Enum.KeyCode.A then
						a = 0
					end
					if input1.KeyCode == Enum.KeyCode.D then
						d = 0
					end
				end)
				local pulsetick = tick()
				task.spawn(function()
					repeat
						pulsetick = tick() + (speedpulseduration["Value"] / 100)
						task.wait((speeddelay["Value"] / 10) + (speedpulseduration["Value"] / 100))
					until (not speed["Enabled"])
				end)
				RunLoops:BindToHeartbeat("Speed", 1, function(delta)
					if entity.isAlive then
						local movevec = (speedmovemethod["Value"] == "Manual" and (CFrame.lookAt(cam.CFrame.p, cam.CFrame.p + Vector3.new(cam.CFrame.lookVector.X, 0, cam.CFrame.lookVector.Z))):VectorToWorldSpace(Vector3.new(a + d, 0, w + s)) or entity.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.new()
						if speedmethod["Value"] == "Velocity" then
							local newvelo = movevec * speedval["Value"]
							entity.character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, entity.character.HumanoidRootPart.Velocity.Y, newvelo.Z)
						elseif speedmethod["Value"] == "CFrame" then
							local newpos = (movevec * (math.clamp(speedval["Value"] - entity.character.Humanoid.WalkSpeed, 0, 1000000000) * delta))
							if speedwallcheck["Enabled"] then
								local raycastparameters = RaycastParams.new()
								raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
								raycastparameters.FilterDescendantsInstances = {lplr.Character, cam}
								local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, newpos, raycastparameters)
								if ray then newpos = (ray.Position - entity.character.HumanoidRootPart.Position) end
							end
							entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + newpos
						elseif speedmethod["Value"] == "TP" then
							if speeddelayval <= tick() then
								speeddelayval = tick() + (speeddelay["Value"] / 10)
								local newpos = (movevec * speedval["Value"])
								if speedwallcheck["Enabled"] then
									local raycastparameters = RaycastParams.new()
									raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
									raycastparameters.FilterDescendantsInstances = {lplr.Character, cam}
									local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, newpos, raycastparameters)
									if ray then newpos = (ray.Position - entity.character.HumanoidRootPart.Position) end
								end
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + newpos
							end
						elseif speedmethod["Value"] == "Pulse" then 
							local pulsenum = (speedpulseduration["Value"] / 100)
							local newvelo = movevec * (speedval["Value"] + (entity.character.Humanoid.WalkSpeed - speedval["Value"]) * (1 - (math.max(pulsetick - tick(), 0)) / pulsenum))
							entity.character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, entity.character.HumanoidRootPart.Velocity.Y, newvelo.Z)
						elseif speedmethod["Value"] == "WalkSpeed" then 
							if oldwalkspeed == nil then
								oldwalkspeed = entity.character.Humanoid.WalkSpeed
							end
							entity.character.Humanoid.WalkSpeed = speedval["Value"]
						end
						if speedjump["Enabled"] and (speedjumpalways["Enabled"] or killauranear) then
							if (entity.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entity.character.Humanoid.MoveDirection ~= Vector3.new() then
								if speedjumpvanilla["Enabled"] then 
									entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								else
									entity.character.HumanoidRootPart.Velocity = Vector3.new(entity.character.HumanoidRootPart.Velocity.X, speedjumpheight["Value"], entity.character.HumanoidRootPart.Velocity.Z)
								end
							end
						end
					end
				end)
			else
				speeddelayval = 0
				if speedup then
					speedup:Disconnect()
				end
				if speeddown then
					speeddown:Disconnect()
				end
				if bodyvelo then
					bodyvelo:Remove()
				end
				if oldwalkspeed then
					entity.character.Humanoid.WalkSpeed = oldwalkspeed
					oldwalkspeed = nil
				end
				RunLoops:UnbindFromHeartbeat("Speed")
			end
		end,
		["ExtraText"] = function() 
			if GuiLibrary["ObjectsThatCanBeSaved"]["Text GUIAlternate TextToggle"]["Api"]["Enabled"] then 
				return alternatelist[table.find(speedmethod["List"], speedmethod["Value"])]
			end
			return speedmethod["Value"] 
		end
	})
	speedmethod = speed.CreateDropdown({
		["Name"] = "Mode", 
		["List"] = {"Velocity", "CFrame", "TP", "Pulse", "WalkSpeed"},
		["Function"] = function(val)
			if oldwalkspeed then
				entity.character.Humanoid.WalkSpeed = oldwalkspeed
				oldwalkspeed = nil
			end
			speeddelay["Object"].Visible = val == "TP" or val == "Pulse"
			speedwallcheck["Object"].Visible = val == "CFrame" or val == "TP"
			speedpulseduration["Object"].Visible = val == "Pulse"
		end
	})
	speedmovemethod = speed.CreateDropdown({
		["Name"] = "Movement", 
		["List"] = {"Manual", "MoveDirection"},
		["Function"] = function(val) end
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed", 
		["Min"] = 1,
		["Max"] = 150, 
		["Function"] = function(val) end
	})
	speeddelay = speed.CreateSlider({
		["Name"] = "Delay", 
		["Min"] = 1,
		["Max"] = 50, 
		["Function"] = function(val)
			speeddelayval = tick() + (val / 10)
		end,
		["Default"] = 7,
		["Double"] = 10
	})
	speedpulseduration = speed.CreateSlider({
		["Name"] = "Pulse Duration",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function() end,
		["Default"] = 50,
		["Double"] = 100
	})
	speedpulseduration["Object"].Visible = false
	speedjump = speed.CreateToggle({
		["Name"] = "AutoJump", 
		["Function"] = function(callback) 
			if speedjumpheight["Object"] then 
				speedjumpheight["Object"].Visible = callback
			end
			if speedjumpalways["Object"] then
				speedjump["Object"].ToggleArrow.Visible = callback
				speedjumpalways["Object"].Visible = callback
			end
			if speedjumpvanilla["Object"] then
				speedjumpvanilla["Object"].Visible = callback
			end
		end,
		["Default"] = true
	})
	speedjumpheight = speed.CreateSlider({
		["Name"] = "Jump Height",
		["Min"] = 0,
		["Max"] = 30,
		["Default"] = 25,
		["Function"] = function() end
	})
	speedjumpheight["Object"].Visible = false
	speedjumpalways = speed.CreateToggle({
		["Name"] = "Always Jump",
		["Function"] = function() end
	})
	speedjumpvanilla = speed.CreateToggle({
		["Name"] = "Real Jump",
		["Function"] = function() end
	})
	speedwallcheck = speed.CreateToggle({
		["Name"] = "Wall Check",
		["Function"] = function() end,
		["Default"] = true
	})
	speedwallcheck["Object"].Visible = false
end)

runcode(function()
	local bodyspin
	local spinbotspeed = {["Value"] = 1}
	local spinbotx = {["Enabled"] = false}
	local spinboty = {["Enabled"] = false}
	local spinbotz = {["Enabled"] = false}
	local spinbot = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SpinBot",
		["Function"] = function(callback)
			if callback then
				RunLoops:BindToRenderStep("SpinBot", 1, function()
					if entity.isAlive then
						if (bodyspin == nil or bodyspin ~= nil and bodyspin.Parent ~= entity.character.HumanoidRootPart) then
							bodyspin = Instance.new("BodyAngularVelocity")
							bodyspin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
							bodyspin.AngularVelocity = Vector3.new(spinbotspeed["Value"], spinbotspeed["Value"], spinbotspeed["Value"])
							bodyspin.Parent = entity.character.HumanoidRootPart
						else
							bodyspin.MaxTorque = Vector3.new(spinbotx["Enabled"] and math.huge or 0, spinboty["Enabled"] and math.huge or 0, spinbotz["Enabled"] and math.huge or 0)
							bodyspin.AngularVelocity = Vector3.new(spinbotspeed["Value"], spinbotspeed["Value"], spinbotspeed["Value"])
						end
					end
				end)
			else
				if bodyspin then
					bodyspin:Remove()
				end
				RunLoops:UnbindFromRenderStep("SpinBot")
			end
		end,
		["HoverText"] = "Makes your character spin around in circles (does not work in first person)"
	})
	spinbotspeed = spinbot.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 100,
		["Default"] = 40,
		["Function"] = function() end
	})
	spinbotx = spinbot.CreateToggle({
		["Name"] = "Spin X",
		["Function"] = function() end
	})
	spinboty = spinbot.CreateToggle({
		["Name"] = "Spin Y",
		["Function"] = function() end,
		["Default"] = true
	})
	spinbotz = spinbot.CreateToggle({
		["Name"] = "Spin Z",
		["Function"] = function() end
	})
end)

runcode(function()
	local oldgrav
	local grav = {["Enabled"] = false}
	local gravslider = {["Value"] = 100}
	grav = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Gravity",
		["Function"] = function(callback)
			if callback then
				oldgrav = workspace.Gravity
				workspace.Gravity = gravslider["Value"]
			else
				workspace.Gravity = oldgrav
			end
		end,
		["HoverText"] = "Changes workspace gravity"
	})
	gravslider = grav.CreateSlider({
		["Name"] = "Gravity",
		["Min"] = 0,
		["Max"] = 192,
		["Function"] = function(val) 
			if grav["Enabled"] then
				gravchanged = true
				workspace.Gravity = val
			end
		end,
		["Default"] = 192
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

local ArrowsFolder = Instance.new("Folder")
ArrowsFolder.Name = "ArrowsFolder"
ArrowsFolder.Parent = GuiLibrary["MainGui"]
players.PlayerRemoving:Connect(function(plr)
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
					if aliveplr and plr ~= lplr and (ArrowsTeammate["Enabled"] or aliveplr.Targetable) then
						local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position)
						local camcframeflat = CFrame.new(cam.CFrame.p, cam.CFrame.p + cam.CFrame.lookVector * Vector3.new(1, 0, 1))
						local pointRelativeToCamera = camcframeflat:pointToObjectSpace(aliveplr.RootPart.Position)
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


runcode(function()
	local Disguise = {["Enabled"] = false}
	local DisguiseId = {["Value"] = ""}
	local desc
	
	local function disguisechar(char)
		task.spawn(function()
			if not char then return end
			local hum = char:WaitForChild("Humanoid")
			char:WaitForChild("Head")
			local desc
			if desc == nil then
				local suc = false
				repeat
					suc = pcall(function()
						desc = players:GetHumanoidDescriptionFromUserId(DisguiseId["Value"] == "" and 239702688 or tonumber(DisguiseId["Value"]))
					end)
					task.wait(1)
				until suc or (not Disguise["Enabled"])
			end
			if (not Disguise["Enabled"]) then return end
			desc.HeightScale = hum:WaitForChild("HumanoidDescription").HeightScale
			char.Archivable = true
			local disguiseclone = char:Clone()
			disguiseclone.Name = "disguisechar"
			disguiseclone.Parent = workspace
			for i,v in pairs(disguiseclone:GetChildren()) do 
				if v:IsA("Accessory") or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") then  
					v:Destroy()
				end
			end
			disguiseclone.Humanoid:ApplyDescriptionClientServer(desc)
			for i,v in pairs(char:GetChildren()) do 
				if (v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then 
					v.Parent = game
				end
			end
			char.ChildAdded:Connect(function(v)
				if ((v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors")) and v:GetAttribute("Disguise") == nil then 
					repeat task.wait() v.Parent = game until v.Parent == game
				end
			end)
			for i,v in pairs(disguiseclone:WaitForChild("Animate"):GetChildren()) do 
				v:SetAttribute("Disguise", true)
				local real = char.Animate:FindFirstChild(v.Name)
				if v:IsA("StringValue") and real then 
					real.Parent = game
					v.Parent = char.Animate
				end
			end
			for i,v in pairs(disguiseclone:GetChildren()) do 
				v:SetAttribute("Disguise", true)
				if v:IsA("Accessory") then  
					for i2,v2 in pairs(v:GetDescendants()) do 
						if v2:IsA("Weld") and v2.Part1 then 
							v2.Part1 = char[v2.Part1.Name]
						end
					end
					v.Parent = char
				elseif v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then  
					v.Parent = char
				elseif v.Name == "Head" and char.Head:IsA("MeshPart") then 
					char.Head.MeshId = v.MeshId
				end
			end
			local localface = char:FindFirstChild("face", true)
			local cloneface = disguiseclone:FindFirstChild("face", true)
			if localface and cloneface then localface.Parent = game cloneface.Parent = char.Head end
			char.Humanoid.HumanoidDescription:SetEmotes(desc:GetEmotes())
			char.Humanoid.HumanoidDescription:SetEquippedEmotes(desc:GetEquippedEmotes())
			disguiseclone:Destroy()
		end)
	end

	local disguiseconnection
	Disguise = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Disguise",
		["Function"] = function(callback)
			if callback then 
				disguiseconnection = lplr.CharacterAdded:Connect(disguisechar)
				disguisechar(lplr.Character)
			else
				if disguiseconnection then 
					disguiseconnection:Disconnect()
				end
			end
		end
	})
	DisguiseId = Disguise.CreateTextBox({
		["Name"] = "Disguise",
		["TempText"] = "Disguise User Id",
		["FocusLost"] = function(enter) 
			if Disguise["Enabled"] then 
				Disguise["ToggleButton"](false)
				Disguise["ToggleButton"](false)
			end
		end
	})
end)

runcode(function()
	local espfolderdrawing = {}
	local methodused
	local espfolder = Instance.new("Folder")
	espfolder.Parent = GuiLibrary["MainGui"]

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local ESPColor = {["Value"] = 0.44}
	local ESPHealthBar = {["Enabled"] = false}
	local ESPBoundingBox = {["Enabled"] = true}
	local ESPName = {["Enabled"] = true}
	local ESPMethod = {["Value"] = "2D"}
	local ESPTeammates = {["Enabled"] = true}
	local espconnections = {}
	local addedconnection
	local removedconnection
	local updatedconnection
	local colorconnection

	local function CalculateObjectPosition(pos)
		local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
		return Vector2.new(newpos.X, newpos.Y)
	end

	local espfuncs1 = {
		Drawing2D = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Quad1 = Drawing.new("Square")
			thing.Quad1.Transparency = ESPBoundingBox["Enabled"] and 1 or 0
			thing.Quad1.ZIndex = 2
			thing.Quad1.Filled = false
			thing.Quad1.Thickness = 1
			thing.Quad1.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			thing.QuadLine2 = Drawing.new("Square")
			thing.QuadLine2.Transparency = ESPBoundingBox["Enabled"] and 0.5 or 0
			thing.QuadLine2.ZIndex = 1
			thing.QuadLine2.Thickness = 1
			thing.QuadLine2.Filled = false
			thing.QuadLine2.Color = Color3.new(0, 0, 0)
			thing.QuadLine3 = Drawing.new("Square")
			thing.QuadLine3.Transparency = ESPBoundingBox["Enabled"] and 0.5 or 0
			thing.QuadLine3.ZIndex = 1
			thing.QuadLine3.Thickness = 1
			thing.QuadLine3.Filled = false
			thing.QuadLine3.Color = Color3.new(0, 0, 0)
			if ESPHealthBar["Enabled"] then 
				thing.Quad3 = Drawing.new("Line")
				thing.Quad3.Thickness = 1
				thing.Quad3.ZIndex = 2
				thing.Quad3.Color = Color3.new(0, 1, 0)
				thing.Quad4 = Drawing.new("Line")
				thing.Quad4.Thickness = 3
				thing.Quad4.Transparency = 0.5
				thing.Quad4.ZIndex = 1
				thing.Quad4.Color = Color3.new(0, 0, 0)
			end
			if ESPName["Enabled"] then 
				thing.Text = Drawing.new("Text")
				thing.Text.Text = WhitelistFunctions:GetTag(plr.Player)..(plr.Player.DisplayName or plr.Player.Name)
				thing.Text.ZIndex = 2
				thing.Text.Color = thing.Quad1.Color
				thing.Text.Center = true
				thing.Text.Size = 20
				thing.Drop = Drawing.new("Text")
				thing.Drop.Color = Color3.new()
				thing.Drop.Text = thing.Text.Text
				thing.Drop.ZIndex = 1
				thing.Drop.Center = true
				thing.Drop.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing2DV3 = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local toppoint = PointInstance.new(plr.RootPart, CFrame.new(2, 3, 0))
			local bottompoint = PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0))
			local newobj = RectDynamic.new(toppoint)
			newobj.BottomRight = bottompoint
			newobj.Outlined = ESPBoundingBox["Enabled"]
			newobj.Opacity = ESPBoundingBox["Enabled"] and 1 or 0
			newobj.OutlineOpacity = 0.5
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			local newobj2 = {}
			local newobj3 = {}
			if ESPHealthBar["Enabled"] then 
				local topoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, 3, 0)), Vector2.new(-5, -1))
				local bottomoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0)), Vector2.new(-3, 1))
				local healthoffset = PointOffset.new(bottomoffset, Vector2.new(-1, -1))
				local healthoffset2 = PointOffset.new(bottomoffset, Vector2.new(-1, -((bottomoffset.ScreenPos.Y - topoffset.ScreenPos.Y) - 1)))
				newobj2.Bkg = RectDynamic.new(topoffset)
				newobj2.Bkg.Filled = true
				newobj2.Bkg.Opacity = 0.5
				newobj2.Bkg.BottomRight = bottomoffset
				newobj2.Line = RectDynamic.new(healthoffset)
				newobj2.Line.Filled = true
				newobj2.Line.YAlignment = YAlignment.Bottom
				newobj2.Line.BottomRight = healthoffset2
				newobj2.Line.Color = HealthbarColorTransferFunction(plr.Humanoid.Health / plr.Humanoid.MaxHealth)
				newobj2.Offset = healthoffset2
				newobj2.TopOffset = topoffset
				newobj2.BottomOffset = bottomoffset
			end
			if ESPName["Enabled"] then 
				local nameoffset1 = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(0, 3, 0)), Vector2.new(0, -15))
				local nameoffset2 = PointOffset.new(nameoffset1, Vector2.new(1, 1))
				newobj3.Text = TextDynamic.new(nameoffset1)
				newobj3.Text.Text = WhitelistFunctions:GetTag(plr.Player)..(plr.Player.DisplayName or plr.Player.Name)
				newobj3.Text.Color = newobj.Color
				newobj3.Text.ZIndex = 2
				newobj3.Text.Size = 20
				newobj3.Drop = TextDynamic.new(nameoffset2)
				newobj3.Drop.Text = newobj3.Text.Text
				newobj3.Drop.Color = Color3.new()
				newobj3.Drop.ZIndex = 1
				newobj3.Drop.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = newobj, HealthBar = newobj2, Name = newobj3}
		end,
		DrawingSkeleton = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Head = Drawing.new("Line")
			thing.Head2 = Drawing.new("Line")
			thing.Torso = Drawing.new("Line")
			thing.Torso2 = Drawing.new("Line")
			thing.Torso3 = Drawing.new("Line")
			thing.LeftArm = Drawing.new("Line")
			thing.RightArm = Drawing.new("Line")
			thing.LeftLeg = Drawing.new("Line")
			thing.RightLeg = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		DrawingSkeletonV3 = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {Main = {}, entity = plr}
			local rigcheck = plr.Humanoid.RigType == Enum.HumanoidRigType.R6
			local head = PointInstance.new(plr.Head)
			head.RotationType = CFrameRotationType.TargetRelative
			local headfront = PointInstance.new(plr.Head, CFrame.new(0, 0, -0.5))
			headfront.RotationType = CFrameRotationType.TargetRelative
			local toplefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-1.5, 0.8, 0))
			toplefttorso.RotationType = CFrameRotationType.TargetRelative
			local toprighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(1.5, 0.8, 0))
			toprighttorso.RotationType = CFrameRotationType.TargetRelative
			local toptorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, 0.8, 0))
			toptorso.RotationType = CFrameRotationType.TargetRelative
			local bottomtorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, -0.8, 0))
			bottomtorso.RotationType = CFrameRotationType.TargetRelative
			local bottomlefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-0.5, -0.8, 0))
			bottomlefttorso.RotationType = CFrameRotationType.TargetRelative
			local bottomrighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0.5, -0.8, 0))
			bottomrighttorso.RotationType = CFrameRotationType.TargetRelative
			local leftarm = PointInstance.new(plr.Character[(rigcheck and "Left Arm" or "LeftHand")], CFrame.new(0, -0.8, 0))
			leftarm.RotationType = CFrameRotationType.TargetRelative
			local rightarm = PointInstance.new(plr.Character[(rigcheck and "Right Arm" or "RightHand")], CFrame.new(0, -0.8, 0))
			rightarm.RotationType = CFrameRotationType.TargetRelative
			local leftleg = PointInstance.new(plr.Character[(rigcheck and "Left Leg" or "LeftFoot")], CFrame.new(0, -0.8, 0))
			leftleg.RotationType = CFrameRotationType.TargetRelative
			local rightleg = PointInstance.new(plr.Character[(rigcheck and "Right Leg" or "RightFoot")], CFrame.new(0, -0.8, 0))
			rightleg.RotationType = CFrameRotationType.TargetRelative
			thing.Main.Head = LineDynamic.new(toptorso, head)
			thing.Main.Head2 = LineDynamic.new(head, headfront)
			thing.Main.Torso = LineDynamic.new(toplefttorso, toprighttorso)
			thing.Main.Torso2 = LineDynamic.new(toptorso, bottomtorso)
			thing.Main.Torso3 = LineDynamic.new(bottomlefttorso, bottomrighttorso)
			thing.Main.LeftArm = LineDynamic.new(toplefttorso, leftarm)
			thing.Main.RightArm = LineDynamic.new(toprighttorso, rightarm)
			thing.Main.LeftLeg = LineDynamic.new(bottomlefttorso, leftleg)
			thing.Main.RightLeg = LineDynamic.new(bottomrighttorso, rightleg)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing.Main) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = thing
		end,
		Drawing3D = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Line1 = Drawing.new("Line")
			thing.Line2 = Drawing.new("Line")
			thing.Line3 = Drawing.new("Line")
			thing.Line4 = Drawing.new("Line")
			thing.Line5 = Drawing.new("Line")
			thing.Line6 = Drawing.new("Line")
			thing.Line7 = Drawing.new("Line")
			thing.Line8 = Drawing.new("Line")
			thing.Line9 = Drawing.new("Line")
			thing.Line10 = Drawing.new("Line")
			thing.Line11 = Drawing.new("Line")
			thing.Line12 = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing3DV3 = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			local point1 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, 1.5))
			point1.RotationType = CFrameRotationType.Ignore
			local point2 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, 1.5))
			point2.RotationType = CFrameRotationType.Ignore
			local point3 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, 1.5))
			point3.RotationType = CFrameRotationType.Ignore
			local point4 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, 1.5))
			point4.RotationType = CFrameRotationType.Ignore
			local point5 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, -1.5))
			point5.RotationType = CFrameRotationType.Ignore
			local point6 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, -1.5))
			point6.RotationType = CFrameRotationType.Ignore
			local point7 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, -1.5))
			point7.RotationType = CFrameRotationType.Ignore
			local point8 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, -1.5))
			point8.RotationType = CFrameRotationType.Ignore
			thing.Line1 = LineDynamic.new(point1, point2)
			thing.Line2 = LineDynamic.new(point3, point4)
			thing.Line3 = LineDynamic.new(point5, point6)
			thing.Line4 = LineDynamic.new(point7, point8)
			thing.Line5 = LineDynamic.new(point1, point3)
			thing.Line6 = LineDynamic.new(point1, point5)
			thing.Line7 = LineDynamic.new(point5, point7)
			thing.Line8 = LineDynamic.new(point7, point3)
			thing.Line9 = LineDynamic.new(point2, point4)
			thing.Line10 = LineDynamic.new(point2, point6)
			thing.Line11 = LineDynamic.new(point6, point8)
			thing.Line12 = LineDynamic.new(point8, point4)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end
	}
	local espfuncs2 = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				v.Main.Visible = false
				for i2,v2 in pairs(v.HealthBar) do
					if typeof(v2):find("Point") == nil then 
						v2.Visible = false
					end
				end
				for i2,v2 in pairs(v.Name) do
					if typeof(v2):find("Point") == nil then 
						v2.Visible = false
					end
				end
			end
		end,
		Drawing3D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing3DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Visible = false
					end
				end
			end
		end,
		DrawingSkeleton = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		DrawingSkeletonV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Visible = false
					end
				end
			end
		end
	}
	local espupdatefuncs = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.Main.Quad3 then 
				local color = HealthbarColorTransferFunction(ent.Humanoid.Health / ent.Humanoid.MaxHealth)
				v.Main.Quad3.Color = color
			end
			if v and v.Text then 
				v.Text.Text = WhitelistFunctions:GetTag(ent.Player)..(ent.Player.DisplayName or ent.Player.Name)
				v.Drop.Text = v.Text.Text
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.HealthBar.Line then 
				local health = ent.Humanoid.Health / ent.Humanoid.MaxHealth
				local color = HealthbarColorTransferFunction(health)
				v.HealthBar.Line.Color = color
			end
			if v and v.Name and v.Name.Text then 
				v.Name.Text.Text = WhitelistFunctions:GetTag(ent.Player)..(ent.Player.DisplayName or ent.Player.Name)
				v.Name.Drop.Text = v.Name.Text.Text
			end
		end
	}
	local espcolorfuncs = {
		Drawing2D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				v.Main.Quad1.Color = getPlayerColor(v.entity.Player) or color
				if v.Main.Text then 
					v.Main.Text.Color = v.Main.Quad1.Color
				end
			end
		end,
		Drawing2DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				v.Main.Color = getPlayerColor(v.entity.Player) or color
				if v.Name.Text then 
					v.Name.Text.Color = v.Main.Color
				end
			end
		end,
		Drawing3D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					v2.Color = getPlayerColor(v.entity.Player) or color
				end
			end
		end,
		Drawing3DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Color = getPlayerColor(v.entity.Player) or color
					end
				end
			end
		end,
		DrawingSkeleton = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					v2.Color = getPlayerColor(v.entity.Player) or color
				end
			end
		end,
		DrawingSkeletonV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Color = getPlayerColor(v.entity.Player) or color
					end
				end
			end
		end,
	}
	local esploop = {
		Drawing2D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity.RootPart.Position)
				if not rootVis then 
					v.Main.Quad1.Visible = false
					v.Main.QuadLine2.Visible = false
					v.Main.QuadLine3.Visible = false
					if v.Main.Quad3 then 
						v.Main.Quad3.Visible = false
						v.Main.Quad4.Visible = false
					end
					if v.Main.Text then 
						v.Main.Text.Visible = false
						v.Main.Drop.Visible = false
					end
					continue 
				end
				local topPos, topVis = cam:WorldToViewportPoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + cam.CFrame.lookVector) * CFrame.new(2, 3, 0)).p)
				local bottomPos, bottomVis = cam:WorldToViewportPoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + cam.CFrame.lookVector) * CFrame.new(-2, -3.5, 0)).p)
				local sizex, sizey = topPos.X - bottomPos.X, topPos.Y - bottomPos.Y
				local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
				v.Main.Quad1.Position = floorpos(Vector2.new(posx, posy))
				v.Main.Quad1.Size = floorpos(Vector2.new(sizex, sizey))
				v.Main.Quad1.Visible = true
				v.Main.QuadLine2.Position = floorpos(Vector2.new(posx - 1, posy + 1))
				v.Main.QuadLine2.Size = floorpos(Vector2.new(sizex + 2, sizey - 2))
				v.Main.QuadLine2.Visible = true
				v.Main.QuadLine3.Position = floorpos(Vector2.new(posx + 1, posy - 1))
				v.Main.QuadLine3.Size = floorpos(Vector2.new(sizex - 2, sizey + 2))
				v.Main.QuadLine3.Visible = true
				if v.Main.Quad3 then 
					local healthposy = sizey * math.clamp(v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth, 0, 1)
					v.Main.Quad3.Visible = v.entity.Humanoid.Health > 0
					v.Main.Quad3.From = floorpos(Vector2.new(posx - 4, posy + (sizey - (sizey - healthposy))))
					v.Main.Quad3.To = floorpos(Vector2.new(posx - 4, posy))
					v.Main.Quad4.Visible = true
					v.Main.Quad4.From = floorpos(Vector2.new(posx - 4, posy))
					v.Main.Quad4.To = floorpos(Vector2.new(posx - 4, (posy + sizey)))
				end
				if v.Main.Text then 
					v.Main.Text.Visible = true
					v.Main.Drop.Visible = true
					v.Main.Text.Position = floorpos(Vector2.new(posx + (sizex / 2), posy + (sizey - 25)))
					v.Main.Drop.Position = v.Main.Text.Position + Vector2.new(1, 1)
				end
			end
		end,
		Drawing2DV3 = function()
			for i,v in pairs(espfolderdrawing) do 
				if v.HealthBar.Offset then 
					v.HealthBar.Offset.Offset = Vector2.new(-1, -(((v.HealthBar.BottomOffset.ScreenPos.Y - v.HealthBar.TopOffset.ScreenPos.Y) - 1) * (v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth)))
					v.HealthBar.Line.Visible = v.entity.Humanoid.Health > 0
				end
			end
		end,
		Drawing3D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity.RootPart.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local point1 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, 3, 1.5))
				local point2 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, -3, 1.5))
				local point3 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, 3, 1.5))
				local point4 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, -3, 1.5))
				local point5 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, 3, -1.5))
				local point6 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, -3, -1.5))
				local point7 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, 3, -1.5))
				local point8 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, -3, -1.5))
				v.Main.Line1.From = point1
				v.Main.Line1.To = point2
				v.Main.Line2.From = point3
				v.Main.Line2.To = point4
				v.Main.Line3.From = point5
				v.Main.Line3.To = point6
				v.Main.Line4.From = point7
				v.Main.Line4.To = point8
				v.Main.Line5.From = point1
				v.Main.Line5.To = point3
				v.Main.Line6.From = point1
				v.Main.Line6.To = point5
				v.Main.Line7.From = point5
				v.Main.Line7.To = point7
				v.Main.Line8.From = point7
				v.Main.Line8.To = point3
				v.Main.Line9.From = point2
				v.Main.Line9.To = point4
				v.Main.Line10.From = point2
				v.Main.Line10.To = point6
				v.Main.Line11.From = point6
				v.Main.Line11.To = point8
				v.Main.Line12.From = point8
				v.Main.Line12.To = point4
			end
		end,
		DrawingSkeleton = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity.RootPart.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local rigcheck = v.entity.Humanoid.RigType == Enum.HumanoidRigType.R6
				local head = CalculateObjectPosition((v.entity.Head.CFrame).p)
				local headfront = CalculateObjectPosition((v.entity.Head.CFrame * CFrame.new(0, 0, -0.5)).p)
				local toplefttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
				local toprighttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
				local toptorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
				local bottomtorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local bottomlefttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
				local bottomrighttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
				local leftarm = CalculateObjectPosition((v.entity.Character[(rigcheck and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightarm = CalculateObjectPosition((v.entity.Character[(rigcheck and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local leftleg = CalculateObjectPosition((v.entity.Character[(rigcheck and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightleg = CalculateObjectPosition((v.entity.Character[(rigcheck and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				v.Main.Torso.From = toplefttorso
				v.Main.Torso.To = toprighttorso
				v.Main.Torso2.From = toptorso
				v.Main.Torso2.To = bottomtorso
				v.Main.Torso3.From = bottomlefttorso
				v.Main.Torso3.To = bottomrighttorso
				v.Main.LeftArm.From = toplefttorso
				v.Main.LeftArm.To = leftarm
				v.Main.RightArm.From = toprighttorso
				v.Main.RightArm.To = rightarm
				v.Main.LeftLeg.From = bottomlefttorso
				v.Main.LeftLeg.To = leftleg
				v.Main.RightLeg.From = bottomrighttorso
				v.Main.RightLeg.To = rightleg
				v.Main.Head.From = toptorso
				v.Main.Head.To = head
				v.Main.Head2.From = head
				v.Main.Head2.To = headfront
			end
		end
	}

	local ESP = {Enabled = false}
	ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ESP", 
		["Function"] = function(callback) 
			if callback then
				methodused = "Drawing"..ESPMethod["Value"]
				if espfuncs2[methodused] then
					removedconnection = entity.entityRemovedEvent:Connect(espfuncs2[methodused])
				end
				if espfuncs1[methodused] then
					local addfunc = espfuncs1[methodused]
					for i,v in pairs(entity.entityList) do 
						if espfolderdrawing[v.Player] then espfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					addedconnection = entity.entityAddedEvent:Connect(function(ent)
						if espfolderdrawing[ent.Player] then espfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end)
				end
				if espupdatefuncs[methodused] then
					updatedconnection = entity.entityUpdatedEvent:Connect(espupdatefuncs[methodused])
					for i,v in pairs(entity.entityList) do 
						espupdatefuncs[methodused](v)
					end
				end
				if espcolorfuncs[methodused] then 
					colorconnection = GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendColorRefresh.Event:Connect(function()
						espcolorfuncs[methodused](ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
					end)
				end
				if esploop[methodused] then 
					RunLoops:BindToRenderStep("ESP", 1, esploop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("ESP")
				if addedconnection then 
					addedconnection:Disconnect()
				end
				if updatedconnection then 
					updatedconnection:Disconnect()
				end
				if removedconnection then 
					removedconnection:Disconnect()
				end
				if colorconnection then 
					colorconnection:Disconnect()
				end
				if espfuncs2[methodused] then
					for i,v in pairs(entity.entityList) do 
						if espfolderdrawing[v.Player] then
							espfuncs2[methodused](v.Player)
						end
					end
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPColor = ESP.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(hue, sat, val) 
			if ESP["Enabled"] and espcolorfuncs[methodused] then 
				espcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	ESPMethod = ESP.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"2D", "3D", "Skeleton"},
		["Function"] = function(val)
			if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end
			ESPBoundingBox["Object"].Visible = (val == "2D")
			ESPHealthBar["Object"].Visible = (val == "2D")
			ESPName["Object"].Visible = (val == "2D")
		end,
	})
	ESPBoundingBox = ESP.CreateToggle({
		["Name"] = "Bounding Box",
		["Function"] = function() if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end,
		["Default"] = true
	})
	ESPTeammates = ESP.CreateToggle({
		["Name"] = "Priority Only",
		["Function"] = function() if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end,
		["Default"] = true
	})
	ESPHealthBar = ESP.CreateToggle({
		["Name"] = "Health Bar", 
		["Function"] = function(callback) if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end
	})
	ESPName = ESP.CreateToggle({
		["Name"] = "Name", 
		["Function"] = function(callback) if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end
	})
end)

runcode(function()
	local ChamsFolder = Instance.new("Folder")
	ChamsFolder.Name = "ChamsFolder"
	ChamsFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:Connect(function(plr)
		if ChamsFolder:FindFirstChild(plr.Name) then
			ChamsFolder[plr.Name]:Remove()
		end
	end)
	local ChamsColor = {["Value"] = 0.44}
	local ChamsOutlineColor = {["Value"] = 0.44}
	local ChamsBetter = {["Enabled"] = false}
	local ChamsTransparency = {["Value"] = 1}
	local ChamsOutlineTransparency = {["Value"] = 1}
	local ChamsOnTop = {["Enabled"] = true}
	local chamobjects = {["Head"] = true, ["Torso"] = true, ["UpperTorso"] = true, ["LowerTorso"] = true, ["Left Arm"] = true, ["Left Leg"] = true, ["Right Arm"] = true, ["Right Leg"] = true, ["LeftLowerLeg"] = true, ["RightLowerLeg"] = true, ["LeftUpperLeg"] = true, ["RightUpperLeg"] = true, ["LeftFoot"] = true, ["RightFoot"] = true, ["LeftLowerArm"] = true, ["RightLowerArm"] = true, ["LeftUpperArm"] = true, ["RightUpperArm"] = true, ["LeftHand"] = true, ["RightHand"] = true}
	local ChamsTeammates = {["Enabled"] = true}
	local ChamsAlive = {["Enabled"] = false}
	local Chams = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Chams", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("Chams", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if ChamsFolder:FindFirstChild(plr.Name) then
							thing = ChamsFolder[plr.Name]
							thing.Enabled = false
							thing.FillColor = getPlayerColor(plr) or Color3.fromHSV(ChamsColor["Hue"], ChamsColor["Sat"], ChamsColor["Value"])
							thing.OutlineColor = getPlayerColor(plr) or Color3.fromHSV(ChamsOutlineColor["Hue"], ChamsOutlineColor["Sat"], ChamsOutlineColor["Value"])
						end

						local aliveplr = isAlive(plr, ChamsAlive["Enabled"])
						if aliveplr and plr ~= lplr and (ChamsTeammates["Enabled"] or aliveplr.Targetable) then
							if ChamsFolder:FindFirstChild(plr.Name) == nil then
								local chamfolder = Instance.new("Highlight")
								chamfolder.Name = plr.Name
								chamfolder.Parent = ChamsFolder
								thing = chamfolder
							end
							thing.Enabled = true
							thing.Adornee = aliveplr.Character
							thing.OutlineTransparency = ChamsOutlineTransparency["Value"] / 100
							thing.DepthMode = Enum.HighlightDepthMode[(ChamsOnTop["Enabled"] and "AlwaysOnTop" or "Occluded")]
							thing.FillTransparency = ChamsTransparency["Value"] / 100
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("Chams")
				ChamsFolder:ClearAllChildren()
			end
		end,
		["HoverText"] = "Render players through walls"
	})
	ChamsColor = Chams.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	ChamsOutlineColor = Chams.CreateColorSlider({
		["Name"] = "Outline Player Color", 
		["Function"] = function(val) end
	})
	ChamsTransparency = Chams.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 50
	})
	ChamsOutlineTransparency = Chams.CreateSlider({
		["Name"] = "Outline Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 1
	})
	ChamsTeammates = Chams.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	ChamsOnTop = Chams.CreateToggle({
		["Name"] = "Bypass Walls", 
		["Function"] = function() end
	})
	ChamsAlive = Chams.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)

local lightingsettings = {}
local lightingconnection
local lightingchanged = false
GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Fullbright",
	["Function"] = function(callback)
		if callback then 
			lightingsettings["Brightness"] = lighting.Brightness
			lightingsettings["ClockTime"] = lighting.ClockTime
			lightingsettings["FogEnd"] = lighting.FogEnd
			lightingsettings["GlobalShadows"] = lighting.GlobalShadows
			lightingsettings["OutdoorAmbient"] = lighting.OutdoorAmbient
			lightingchanged = false
			lighting.Brightness = 2
			lighting.ClockTime = 14
			lighting.FogEnd = 100000
			lighting.GlobalShadows = false
			lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
			lightingchanged = true
			lightingconnection = lighting.Changed:Connect(function()
				if not lightingchanged then
					lightingsettings["Brightness"] = lighting.Brightness
					lightingsettings["ClockTime"] = lighting.ClockTime
					lightingsettings["FogEnd"] = lighting.FogEnd
					lightingsettings["GlobalShadows"] = lighting.GlobalShadows
					lightingsettings["OutdoorAmbient"] = lighting.OutdoorAmbient
					lightingchanged = true
					lighting.Brightness = 2
					lighting.ClockTime = 14
					lighting.FogEnd = 100000
					lighting.GlobalShadows = false
					lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
					lightingchanged = false
				end
			end)
		else
			for name,thing in pairs(lightingsettings) do 
				lighting[name] = thing 
			end
			lightingconnection:Disconnect()  
		end
	end
})

local HealthText = Instance.new("TextLabel")
HealthText.Font = Enum.Font.SourceSans
HealthText.TextSize = 20
HealthText.Text = "100❤"
HealthText.Position = UDim2.new(0.5, 0, 0.5, 70)
HealthText.BackgroundTransparency = 1
HealthText.TextColor3 = Color3.fromRGB(255, 0, 0)
HealthText.Size = UDim2.new(0, 0, 0, 0)
HealthText.Visible = false
HealthText.Parent = GuiLibrary["MainGui"]
local Health = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Health", 
	["Function"] = function(callback) 
		if callback then
			HealthText.Visible = true
			RunLoops:BindToRenderStep("Health", 1, function()
				if entity.isAlive then
					HealthText.Text = tostring(math.round(entity.character.Humanoid.Health)).."❤"
				end
			end)
		else
			HealthText.Visible = false
			RunLoops:UnbindFromRenderStep("Health")
		end
	end,
	["HoverText"] = "Displays your health in the center of your screen."
})


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
	players.PlayerRemoving:Connect(function(plr)
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
							if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or aliveplr.Targetable) then
								local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
								
								if headVis then
									local displaynamestr = WhitelistFunctions:GetTag(plr)..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									local blocksaway = math.floor(((entity.isAlive and entity.character.HumanoidRootPart.Position or Vector3.new(0,0,0)) - aliveplr.RootPart.Position).magnitude / 3)
									local color = HealthbarColorTransferFunction(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth)
									thing.Text.Text = (NameTagsDistance["Enabled"] and entity.isAlive and '['..blocksaway..'] ' or '')..displaynamestr..(NameTagsHealth["Enabled"] and ' '..math.floor(aliveplr.Humanoid.Health).."" or '')
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
								if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
									local rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									if NameTagsHealth["Enabled"] then
										rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name).." "..math.floor(plr.Character.Humanoid.Health)
									end
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									local modifiedText = (NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((entity.character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
									local nametagSize = textservice:GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = modifiedText
								else
									local nametagSize = textservice:GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = plr.Name
								end
								thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
								thing.Parent = NameTagsFolder
							end
								
							local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
							if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or aliveplr.Targetable) then
								local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
								headPos = headPos
								
								if headVis then
									local rawText = (NameTagsDistance["Enabled"] and entity.isAlive and "["..math.floor((entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude).."] " or "")..WhitelistFunctions:GetTag(plr)..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(aliveplr.Humanoid.Health) or "")
									local color = HealthbarColorTransferFunction(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth)
									local modifiedText = (NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor((entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..WhitelistFunctions:GetTag(plr)..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(aliveplr.Humanoid.Health).."</font>" or '')
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

local SearchTextList = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local searchColor = {["Value"] = 0.44}
local searchModule = {["Enabled"] = false}
local searchNewHighlight = {["Enabled"] = false}
local searchFolder = Instance.new("Folder")
searchFolder.Name = "SearchFolder"
searchFolder.Parent = GuiLibrary["MainGui"]
local function searchFindBoxHandle(part)
	for i,v in pairs(searchFolder:GetChildren()) do
		if v.Adornee == part then
			return v
		end
	end
	return nil
end
local searchAdd
local searchRemove
local searchRefresh = function()
	searchFolder:ClearAllChildren()
	if searchModule["Enabled"] then
		for i,v in pairs(workspace:GetDescendants()) do
			if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList["ObjectList"], v.Name) and searchFindBoxHandle(v) == nil then
				local highlight = Instance.new("Highlight")
				highlight.Name = v.Name
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillColor = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
				highlight.Adornee = v
				highlight.Parent = searchFolder
			end
		end
	end
end
searchModule = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Search", 
	["Function"] = function(callback) 
		if callback then
			searchRefresh()
			searchAdd = workspace.DescendantAdded:Connect(function(v)
				if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList["ObjectList"], v.Name) and searchFindBoxHandle(v) == nil then
					local highlight = Instance.new("Highlight")
					highlight.Name = v.Name
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillColor = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
					highlight.Adornee = v
					highlight.Parent = searchFolder
				end
			end)
			searchRemove = workspace.DescendantRemoving:Connect(function(v)
				if v:IsA("BasePart") or v:IsA("Model") then
					local boxhandle = searchFindBoxHandle(v)
					if boxhandle then
						boxhandle:Remove()
					end
				end
			end)
		else
			pcall(function()
				searchFolder:ClearAllChildren()
				searchAdd:Disconnect()
				searchRemove:Disconnect()
			end)
		end
	end,
	["HoverText"] = "Draws a box around selected parts\nAdd parts in Search frame"
})
searchColor = searchModule.CreateColorSlider({
	["Name"] = "new part color", 
	["Function"] = function(hue, sat, val)
		for i,v in pairs(searchFolder:GetChildren()) do
			v.FillColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
SearchTextList = searchModule.CreateTextList({
	["Name"] = "SearchList",
	["TempText"] = "part name", 
	["AddFunction"] = function(user)
		searchRefresh()
	end, 
	["RemoveFunction"] = function(num) 
		searchRefresh()
	end
})


local XrayAdd
local Xray = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Xray", 
	["Function"] = function(callback) 
		if callback then
			XrayAdd = workspace.DescendantAdded:Connect(function(v)
				if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
					v.LocalTransparencyModifier = 0.5
				end
			end)
			for i, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
					v.LocalTransparencyModifier = 0.5
				end
			end
		else
			for i, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
					v.LocalTransparencyModifier = 0
				end
			end
			XrayAdd:Disconnect()
		end
	end
})

runcode(function()
	local tracersfolderdrawing = {}
	local methodused

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local TracersColor = {["Value"] = 0.44}
	local TracersTransparency = {["Value"] = 1}
	local TracersStartPosition = {["Value"] = "Middle"}
	local TracersEndPosition = {["Value"] = "Head"}
	local TracersTeammates = {["Enabled"] = true}
	local tracersconnections = {}
	local addedconnection
	local removedconnection
	local updatedconnection

	local tracersfuncs1 = {
		Drawing = function(plr)
			if TracersTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local newobj = Drawing.new("Line")
			newobj.Thickness = 1
			newobj.Transparency = 1 - (TracersTransparency["Value"] / 100)
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
		DrawingV3 = function(plr)
			if TracersTeammates["Enabled"] and (not plr.Targetable) and (not plr.Friend) then return end
			local toppoint = PointInstance.new(plr[TracersEndPosition["Value"] == "Torso" and "RootPart" or "Head"])
			local bottompoint = TracersStartPosition["Value"] == "Mouse" and PointMouse.new() or Point2D.new(UDim2.new(0.5, 0, TracersStartPosition["Value"] == "Middle" and 0.5 or 1, 0))
			local newobj = LineDynamic.new(toppoint, bottompoint)
			newobj.Opacity = 1 - (TracersTransparency["Value"] / 100)
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
	}
	local tracersfuncs2 = {
		Drawing = function(ent)
			local v = tracersfolderdrawing[ent]
			tracersfolderdrawing[ent] = nil
			if v then 
				pcall(function() v.Main.Visible = false v.Main:Remove() end)
			end
		end,
	}
	local tracerscolorfuncs = {
		Drawing = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(tracersfolderdrawing) do 
				v.Main.Color = getPlayerColor(v.entity.Player) or color
			end
		end
	}
	tracerscolorfuncs.DrawingV3 = tracerscolorfuncs.Drawing
	tracersfuncs2.DrawingV3 = tracersfuncs2.Drawing
	local tracersloop = {
		Drawing = function()
			for i,v in pairs(tracersfolderdrawing) do 
				local rootPart = v.entity[TracersEndPosition["Value"] == "Torso" and "RootPart" or "Head"].Position
				local rootPos, rootVis = cam:WorldToViewportPoint(rootPart)
				local screensize = cam.ViewportSize
				local startVector = TracersStartPosition["Value"] == "Mouse" and uis:GetMouseLocation() or Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
				local endVector = Vector2.new(rootPos.X, rootPos.Y)
				v.Main.Visible = rootVis
				v.Main.From = startVector
				v.Main.To = endVector
			end
		end,
	}

	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				methodused = "Drawing"..v3check
				if tracersfuncs2[methodused] then
					removedconnection = entity.entityRemovedEvent:Connect(tracersfuncs2[methodused])
				end
				if tracersfuncs1[methodused] then
					local addfunc = tracersfuncs1[methodused]
					for i,v in pairs(entity.entityList) do 
						addfunc(v)
					end
					addedconnection = entity.entityAddedEvent:Connect(function(ent)
						if tracersfolderdrawing[ent] then 
							tracersfuncs2[methodused](ent)
						end
						addfunc(ent)
					end)
				end
				if tracerscolorfuncs[methodused] then 
					colorconnection = GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendColorRefresh.Event:Connect(function()
						tracerscolorfuncs[methodused](TracersColor.Hue, TracersColor.Sat, TracersColor.Value)
					end)
				end
				if tracersloop[methodused] then 
					RunLoops:BindToRenderStep("Tracers", 1, tracersloop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("Tracers")
				if addedconnection then 
					addedconnection:Disconnect()
				end
				if updatedconnection then 
					updatedconnection:Disconnect()
				end
				if removedconnection then 
					removedconnection:Disconnect()
				end
				if colorconnection then 
					colorconnection:Disconnect()
				end
				for i,v in pairs(entity.entityList) do 
					if tracersfuncs2[methodused] and tracersfolderdrawing[v.Player] then
						tracersfuncs2[methodused](v.Player)
					end
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an Tracers on players."
	})
	TracersStartPosition = Tracers.CreateDropdown({
		["Name"] = "Start Position",
		["List"] = {"Middle", "Bottom", "Mouse"},
		["Function"] = function() if Tracers["Enabled"] then Tracers["ToggleButton"](true) Tracers["ToggleButton"](true) end end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		["Name"] = "End Position",
		["List"] = {"Head", "Torso"},
		["Function"] = function() if Tracers["Enabled"] then Tracers["ToggleButton"](true) Tracers["ToggleButton"](true) end end
	})
	TracersColor = Tracers.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(hue, sat, val) 
			if Tracers["Enabled"] and tracerscolorfuncs[methodused] then 
				tracerscolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	TracersTransparency = Tracers.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) 
			for i,v in pairs(tracersfolderdrawing) do 
				if v.Main then 
					v.Main[methodused == "DrawingV3" and "Opacity" or "Transparency"] = 1 - (val / 100)
				end
			end
		end,
		["Default"] = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		["Name"] = "Priority Only",
		["Function"] = function() if Tracers["Enabled"] then Tracers["ToggleButton"](true) Tracers["ToggleButton"](true) end end,
		["Default"] = true
	})
end)

Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*math.pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = math.exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local velSpring = Spring.new(5, Vector3.new())
local panSpring = Spring.new(5, Vector2.new())

Input = {} do

	keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
	}

	mouse = {
		Delta = Vector2.new(),
	}

	NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	PAN_MOUSE_SPEED = Vector2.new(3, 3)*(math.pi/64)
	NAV_ADJ_SPEED = 0.75
	NAV_SHIFT_MUL = 0.25

	navSpeed = 1

	function Input.Vel(dt)
		navSpeed = math.clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A,
			keyboard.E - keyboard.Q,
			keyboard.S - keyboard.W
		)*NAV_KEYBOARD_SPEED

		local shift = uis:IsKeyDown(Enum.KeyCode.LeftShift)

		return (kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kMouse
	end

	do
		function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamKeyboard",Keypress,false,Enum.ContextActionPriority.High.Value,
			Enum.KeyCode.W,
			Enum.KeyCode.A,
			Enum.KeyCode.S,
			Enum.KeyCode.D,
			Enum.KeyCode.E,
			Enum.KeyCode.Q,
			Enum.KeyCode.Up,
			Enum.KeyCode.Down
			)
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamMousePan",MousePan,false,Enum.ContextActionPriority.High.Value,Enum.UserInputType.MouseMovement)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(keyboard)
			Zero(mouse)
			game:GetService("ContextActionService"):UnbindAction("FreecamKeyboard")
			game:GetService("ContextActionService"):UnbindAction("FreecamMousePan")
		end
	end
end

local function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = cam.ViewportSize
	local projy = 2*math.tan(cameraFov/2)
	local projx = viewport.x/viewport.y*projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5)*projx
			local cy = (y - 0.5)*projy
			local offset = fx*cx - fy*cy + fz
			local origin = cameraFrame.p + offset*znear
			local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect)*minDist
end

local PlayerState = {} do
	mouseBehavior = ""
	mouseIconEnabled = ""
	cameraType = ""
	cameraFocus = ""
	cameraCFrame = ""
	cameraFieldOfView = ""

	function PlayerState.Push()
		cameraFieldOfView = cam.FieldOfView
		cam.FieldOfView = 70

		cameraType = cam.CameraType
		cam.CameraType = Enum.CameraType.Custom

		cameraCFrame = cam.CFrame
		cameraFocus = cam.Focus

		mouseBehavior = uis.MouseBehavior
		uis.MouseBehavior = Enum.MouseBehavior.Default

		mouseIconEnabled = uis.MouseIconEnabled
		uis.MouseIconEnabled = true
	end

	function PlayerState.Pop()
		cam.FieldOfView = cameraFieldOfView
        cameraFieldOfView = nil

		cam.CameraType = cameraType
		cameraType = nil

		cam.CFrame = cameraCFrame
		cameraCFrame = nil

		cam.Focus = cameraFocus
		cameraFocus = nil

		uis.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil

		uis.MouseBehavior = mouseBehavior
		mouseBehavior = nil
	end
end

local Freecam = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Freecam", 
	["Function"] = function(callback)
		if callback then
			local cameraCFrame = cam.CFrame
			local pitch, yaw, roll = cameraCFrame:ToEulerAnglesYXZ()
			cameraRot = Vector2.new(pitch, yaw)
			cameraPos = cameraCFrame.p
			cameraFov = cam.FieldOfView

			velSpring:Reset(Vector3.new())
			panSpring:Reset(Vector2.new())

			PlayerState.Push()
			RunLoops:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, function(dt)
				local vel = velSpring:Update(dt, Input.Vel(dt))
				local pan = panSpring:Update(dt, Input.Pan(dt))

				local zoomFactor = math.sqrt(math.tan(math.rad(70/2))/math.tan(math.rad(cameraFov/2)))

				cameraRot = cameraRot + pan*Vector2.new(0.75, 1)*8*(dt/zoomFactor)
				cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2*math.pi))

				local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Vector3.new(1, 1, 1)*64*dt)
				cameraPos = cameraCFrame.p

				cam.CFrame = cameraCFrame
				cam.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
				cam.FieldOfView = cameraFov
			end)
			Input.StartCapture()
		else
			Input.StopCapture()
			RunLoops:UnbindFromRenderStep("Freecam")
			PlayerState.Pop()
		end
	end,
	["HoverText"] = "Lets you fly and clip through walls freely\nwithout moving your player server-sided."
})
freecamspeed = Freecam.CreateSlider({
	["Name"] = "Speed",
	["Min"] = 1,
	["Max"] = 150,
	["Function"] = function(val) NAV_KEYBOARD_SPEED = Vector3.new(val / 75,  val / 75, val / 75) end,
	["Default"] = 75
})

local Panic = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Panic", 
	["Function"] = function(callback)
		if callback then
			for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
				if v["Type"] == "Button" or v["Type"] == "OptionsButton" then
					if v["Api"]["Enabled"] then
						v["Api"]["ToggleButton"]()
					end
				end
			end
		end
	end
}) 
runcode(function()
	local ChatSpammer = {["Enabled"] = false}
	local ChatSpammerDelay = {["Value"] = 10}
	local ChatSpammerHideWait = {["Enabled"] = true}
	local ChatSpammerMessages = {["ObjectList"] = {}}
	local chatspammerfirstexecute = true
	local chatspammerhook = false
	local oldchanneltab
	local oldchannelfunc
	local oldchanneltabs = {}
	local waitnum = 0
	ChatSpammer = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ChatSpammer",
		["Function"] = function(callback)
			if callback then
				if chatspammerfirstexecute then
					lplr.PlayerGui:WaitForChild("Chat", 10)
				end
				if lplr.PlayerGui:FindFirstChild("Chat") and lplr.PlayerGui.Chat:FindFirstChild("Frame") and lplr.PlayerGui.Chat.Frame:FindFirstChild("ChatChannelParentFrame") and repstorage:FindFirstChild("DefaultChatSystemChatEvents") then
					if chatspammerhook == false then
						spawn(function()
							chatspammerhook = true
							for i,v in pairs(getconnections(repstorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
								if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
									oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
									oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
									getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
										local tab = oldchannelfunc(Self, Name)
										if tab and tab.AddMessageToChannel then
											local addmessage = tab.AddMessageToChannel
											if oldchanneltabs[tab] == nil then
												oldchanneltabs[tab] = tab.AddMessageToChannel
											end
											tab.AddMessageToChannel = function(Self2, MessageData)
												if MessageData.MessageType == "System" then
													if MessageData.Message:find("You must wait") and ChatSpammer["Enabled"] then
														return nil
													end
												end
												return addmessage(Self2, MessageData)
											end
										end
										return tab
									end
								end
							end
						end)
					end
					spawn(function()
						repeat
							if ChatSpammer["Enabled"] then
								pcall(function()
									repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer((#ChatSpammerMessages["ObjectList"] > 0 and ChatSpammerMessages["ObjectList"][math.random(1, #ChatSpammerMessages["ObjectList"])] or "vxpe on top"), "All")
								end)
							end
							if waitnum ~= 0 then
								wait(waitnum)
								waitnum = 0
							else
								wait(ChatSpammerDelay["Value"] / 10)
							end
						until ChatSpammer["Enabled"] == false
					end)				
				else
					createwarning("ChatSpammer", "Default chat not found.", 3)
					if ChatSpammer["Enabled"] then
						ChatSpammer["ToggleButton"](false)
					end
				end
			else
				waitnum = 0
			end
		end,
		["HoverText"] = "Spams chat with text of your choice (Default Chat Only)"
	})
	ChatSpammerDelay = ChatSpammer.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 1,
		["Max"] = 50,
		["Default"] = 10,
		["Function"] = function() end
	})
	ChatSpammerHideWait = ChatSpammer.CreateToggle({
		["Name"] = "Hide Wait Message",
		["Function"] = function() end,
		["Default"] = true
	})
	ChatSpammerMessages = ChatSpammer.CreateTextList({
		["Name"] = "Message",
		["TempText"] = "message to spam",
		["Function"] = function() end
	})
end)

runcode(function()
	local controlmodule = {}
	pcall(function()
		controlmodule = require(lplr.PlayerScripts.PlayerModule).controls
	end)
	local oldmove
	local SafeWalk = {["Enabled"] = false}
	SafeWalk = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SafeWalk",
		["Function"] = function(callback)
			if callback then
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam)
					if entity.isAlive then
						local raycastparameters = RaycastParams.new()
						raycastparameters.FilterDescendantsInstances = {lplr.Character}
						raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
						local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position + (vec * 0.5), Vector3.new(0, -1000, 0), raycastparameters)
						local hipheight = (entity.character.Humanoid.AutomaticScalingEnabled and 2 or entity.character.Humanoid.HipHeight)
						local ray2 = workspace:Raycast(entity.character.HumanoidRootPart.Position, Vector3.new(0, -hipheight * 2, 0), raycastparameters)
						if (ray == nil or ray.Instance.CanCollide == false) and ray2 then
							vec = Vector3.zero
						end
					end
					return oldmove(Self, vec, facecam)
				end
			else
				controlmodule.moveFunction = oldmove
			end
		end,
		["HoverText"] = "lets you not walk off because you are bad"
	})
end)

runcode(function()
	local vapecapeconnection
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Cape",
		["Function"] = function(callback)
			if callback then
				vapecapeconnection = lplr.CharacterAdded:Connect(function(char)
					spawn(function()
						pcall(function() 
							Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
						end)
					end)
				end)
				if lplr.Character then
					spawn(function()
						pcall(function() 
							Cape(lplr.Character, getcustomassetfunc("vape/assets/VapeCape.png"))
						end)
					end)
				end
			else
				if vapecapeconnection then
					vapecapeconnection:Disconnect()
				end
				if lplr.Character then
					for i,v in pairs(lplr.Character:GetDescendants()) do
						if v.Name == "Cape" then
							v:Remove()
						end
					end
				end
			end
		end
	})
end)

runcode(function()
	local Swim = {["Enabled"] = false}
	local swimspeed = {["Value"] = 1}
	local swimconnection
	local oldgravity

	Swim = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Swim",
		["Function"] = function(callback)
			if callback then
				oldgravity = workspace.Gravity
				if entity.isAlive then
					workspace.Gravity = 0
					local enums = Enum.HumanoidStateType:GetEnumItems()
					table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
					for i,v in pairs(enums) do
						entity.character.Humanoid:SetStateEnabled(v, false)
					end
					entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
					RunLoops:BindToHeartbeat("Swim", 1, function()
						local rootvelo = entity.character.HumanoidRootPart.Velocity
						local moving = entity.character.Humanoid.MoveDirection ~= Vector3.new()
						entity.character.HumanoidRootPart.Velocity = ((moving or uis:IsKeyDown(Enum.KeyCode.Space)) and Vector3.new(moving and rootvelo.X or 0, uis:IsKeyDown(Enum.KeyCode.Space) and swimspeed["Value"] or rootvelo.Y, moving and rootvelo.Z or 0) or Vector3.new())
					end)
				end
			else 
				workspace.Gravity = oldgravity
				RunLoops:UnbindFromHeartbeat("Swim")
				if entity.isAlive then
					local enums = Enum.HumanoidStateType:GetEnumItems()
					table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
					for i,v in pairs(enums) do
						entity.character.Humanoid:SetStateEnabled(v, true)
					end
				end
			end
		end
	})
	swimspeed = Swim.CreateSlider({
		["Name"] = "Y Speed",
		["Min"] = 1,
		["Max"] = 50,
		["Default"] = 50,
		["Function"] = function() end
	})
end)


runcode(function()
	local Breadcrumbs = {["Enabled"] = false}
	local BreadcrumbsLifetime = {["Value"] = 20}
	local BreadcrumbsThickness = {["Value"] = 7}
	local BreadcrumbsFadeIn = {["Value"] = 0.44}
	local BreadcrumbsFadeOut = {["Value"] = 0.44}
	local breadcrumbtrail
	local breadcrumbattachment
	local breadcrumbattachment2
	Breadcrumbs = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Breadcrumbs",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.3)
						if (not Breadcrumbs["Enabled"]) then return end
						if entity.isAlive then
							if breadcrumbtrail == nil then
								breadcrumbattachment = Instance.new("Attachment")
								breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
								breadcrumbattachment2 = Instance.new("Attachment")
								breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
								breadcrumbtrail = Instance.new("Trail")
								breadcrumbtrail.Attachment0 = breadcrumbattachment 
								breadcrumbtrail.Attachment1 = breadcrumbattachment2
								breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn["Hue"], BreadcrumbsFadeIn["Sat"], BreadcrumbsFadeIn["Value"]), Color3.fromHSV(BreadcrumbsFadeOut["Hue"], BreadcrumbsFadeOut["Sat"], BreadcrumbsFadeOut["Value"]))
								breadcrumbtrail.FaceCamera = true
								breadcrumbtrail.Lifetime = BreadcrumbsLifetime["Value"] / 10
								breadcrumbtrail.Enabled = true
							else
								pcall(function()
									breadcrumbattachment.Parent = entity.character.HumanoidRootPart
									breadcrumbattachment2.Parent = entity.character.HumanoidRootPart
									breadcrumbtrail.Parent = cam
								end)
							end
						end
					until (not Breadcrumbs["Enabled"])
				end)
			else
				if breadcrumbtrail then
					breadcrumbtrail:Remove()
					breadcrumbtrail = nil
				end
			end
		end,
		["HoverText"] = "Shows a trail behind your character"
	})
	BreadcrumbsFadeIn = Breadcrumbs.CreateColorSlider({
		["Name"] = "Fade In",
		["Function"] = function(hue, sat, val)
			if breadcrumbtrail then 
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(hue, sat, val), Color3.fromHSV(BreadcrumbsFadeOut["Hue"], BreadcrumbsFadeOut["Sat"], BreadcrumbsFadeOut["Value"]))
			end
		end
	})
	BreadcrumbsFadeOut = Breadcrumbs.CreateColorSlider({
		["Name"] = "Fade Out",
		["Function"] = function(hue, sat, val)
			if breadcrumbtrail then 
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn["Hue"], BreadcrumbsFadeIn["Sat"], BreadcrumbsFadeIn["Value"]), Color3.fromHSV(hue, sat, val))
			end
		end
	})
	BreadcrumbsLifetime = Breadcrumbs.CreateSlider({
		["Name"] = "Lifetime",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) 
			if breadcrumbtrail then 
				breadcrumbtrail.Lifetime = val / 10
			end
		end,
		["Default"] = 20,
		["Double"] = 10
	})
	BreadcrumbsThickness = Breadcrumbs.CreateSlider({
		["Name"] = "Thickness",
		["Min"] = 1,
		["Max"] = 30,
		["Function"] = function(val) 
			if breadcrumbattachment then 
				breadcrumbattachment.Position = Vector3.new(0, (val / 100) - 2.7, 0)
			end
			if breadcrumbattachment2 then 
				breadcrumbattachment2.Position = Vector3.new(0, -(val / 100) - 2.7, 0)
			end
		end,
		["Default"] = 7,
		["Double"] = 10
	})
end)

runcode(function()
	local AutoReport = {["Enabled"] = false}
	local reporttable = {
		["gay"] = "Bullying",
		["gae"] = "Bullying",
		["gey"] = "Bullying",
		["hack"] = "Scamming",
		["exploit"] = "Scamming",
		["cheat"] = "Scamming",
		["hecker"] = "Scamming",
		["haxker"] = "Scamming",
		["hacer"] = "Scamming",
		["report"] = "Bullying",
		["fat"] = "Bullying",
		["black"] = "Bullying",
		["getalife"] = "Bullying",
		["fatherless"] = "Bullying",
		["report"] = "Bullying",
		["fatherless"] = "Bullying",
		["disco"] = "Offsite Links",
		["yt"] = "Offsite Links",
		["dizcourde"] = "Offsite Links",
		["retard"] = "Swearing",
		["bad"] = "Bullying",
		["trash"] = "Bullying",
		["nolife"] = "Bullying",
		["nolife"] = "Bullying",
		["loser"] = "Bullying",
		["killyour"] = "Bullying",
		["kys"] = "Bullying",
		["hacktowin"] = "Bullying",
		["bozo"] = "Bullying",
		["kid"] = "Bullying",
		["adopted"] = "Bullying",
		["linlife"] = "Bullying",
		["commitnotalive"] = "Bullying",
		["vape"] = "Offsite Links",
		["futureclient"] = "Offsite Links",
		["download"] = "Offsite Links",
		["youtube"] = "Offsite Links",
		["die"] = "Bullying",
		["lobby"] = "Bullying",
		["ban"] = "Bullying",
		["wizard"] = "Bullying",
		["wisard"] = "Bullying",
		["witch"] = "Bullying",
		["magic"] = "Bullying",
	}

	local function removerepeat(str)
		local newstr = ""
		local lastlet = ""
		for i,v in pairs(str:split("")) do 
			if v ~= lastlet then
				newstr = newstr..v 
				lastlet = v
			end
		end
		return newstr
	end

	local reporttableexact = {
		["L"] = "Bullying",
	}

	local alreadyreported = {}
	local AutoReportList = {["ObjectList"] = {}}

	local function findreport(msg)
		local checkstr = removerepeat(msg:gsub("%W+", ""):lower())
		for i,v in pairs(reporttable) do 
			if checkstr:find(i) then 
				return v, i
			end
		end
		for i,v in pairs(reporttableexact) do 
			if checkstr == i then 
				return v, i
			end
		end
		for i,v in pairs(AutoReportList["ObjectList"]) do 
			if checkstr:find(v) then 
				return "Bullying", v
			end
		end
		return nil
	end

	local AutoReportNotify = {["Enabled"] = false}
	local chatconnection
	AutoReport = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoReport",
		["Function"] = function(callback) 
			if callback then 
				if repstorage:FindFirstChild("DefaultChatSystemChatEvents") then
					chatconnection = repstorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(tab, channel)
						local plr = players:FindFirstChild(tab["FromSpeaker"])
						local args = tab.Message:split(" ")
						if AutoReport["Enabled"] and plr and plr ~= lplr and WhitelistFunctions:CheckPlayerType(plr) == "DEFAULT" then
							local reportreason, reportedmatch = findreport(tab.Message)
							if reportreason then 
								if alreadyreported[plr] == nil then
									task.spawn(function()
										if syn == nil or reportplayer then
											if reportplayer then
												reportplayer(plr, reportreason, "he said a bad word")
											else
												players:ReportAbuse(plr, reportreason, "he said a bad word")
											end
										end
									end)
									if AutoReportNotify["Enabled"] then 
										local warning = createwarning("AutoReport", "Reported "..plr.Name.." for\n"..reportreason..' ('..reportedmatch..')', 15)
										pcall(function()
											warning:GetChildren()[5].Position = UDim2.new(0, 46, 0, 38)
										end)
									end
									alreadyreported[plr] = true
								end
							end
						end
					end)
				else
					createwarning("AutoReport", "Default chat not found.", 5)
					AutoReport["ToggleButton"](false)
				end
			else
				if chatconnection then 
					chatconnection:Disconnect()
				end
			end
		end
	})
	AutoReportNotify = AutoReport.CreateToggle({
		["Name"] = "Notify",
		["Function"] = function() end
	})
	AutoReportList = AutoReport.CreateTextList({
		["Name"] = "Report Words",
		["TempText"] = "phrase (to report)"
	})
end)

runcode(function()
	local AutoLeave = {["Enabled"] = false}
	local AutoLeaveMode = {["Value"] = "UnInject"}
	local AutoLeaveGroupId = {["Value"] = "0"}
	local AutoLeaveRank = {["Value"] = "1"}
	local autoleaveconnection

	local getrandomserver
	local alreadyjoining = false
	getrandomserver = function(pointer)
		alreadyjoining = true
		local data = requestfunc({
			Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"..(pointer and "&cursor="..pointer or ""),
			Method = "GET"
		}).Body
		local decodeddata = game:GetService("HttpService"):JSONDecode(data)
		local chosenServer
		for i, v in pairs(decodeddata.data) do
			if (tonumber(v.playing) < tonumber(players.MaxPlayers)) and tonumber(v.ping) < 300 and v.id ~= game.JobId then 
				chosenServer = v.id
				break
			end
		end
		if chosenServer then 
			alreadyjoining = false
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chosenServer, lplr)
		else
			if decodeddata.nextPageCursor then
				getrandomserver(decodeddata.nextPageCursor)
			else
				alreadyjoining = false
			end
		end
	end

	local function autoleaveplradded(plr)
		task.spawn(function()
			pcall(function()
				if AutoLeaveGroupId["Value"] == "" or AutoLeaveRank["Value"] == "" then return end
				if plr:GetRankInGroup(tonumber(AutoLeaveGroupId["Value"]) or 0) >= (tonumber(AutoLeaveRank["Value"]) or 1) then
					WhitelistFunctions.CustomTags[plr] = "[GAME STAFF] "
					local _, ent = entity.getEntityFromPlayer(plr)
					if ent then 
						entity.entityUpdatedEvent:Fire(ent)
					end
					if AutoLeaveMode["Value"] == "UnInject" then 
						task.spawn(function()
							if not shared.VapeFullyLoaded then
								repeat task.wait() until shared.VapeFullyLoaded
								task.wait(1)
							end
							GuiLibrary.SelfDestruct()
						end)
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "AutoLeave",
							Text = "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name),
							Duration = 60,
						})
					elseif AutoLeaveMode["Value"] == "Rejoin" then 
						getrandomserver()
					else
						local warning = createwarning("AutoLeave", "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name), 60)
						local warningtext = warning:GetChildren()[5]
						warningtext.TextSize = 12
						warningtext.TextLabel.TextSize = 12
						warningtext.Position = warningtext.Position - UDim2.new(0, 0, 0, 4)
					end
				end
			end)
		end)
	end

	local function autodetect(roles)
		local highest = 9e9
		for i,v in pairs(roles) do 
			local low = v.Name:lower()
			if (low:find("admin") or low:find("mod") or low:find("dev")) and v.Rank < highest then 
				highest = v.Rank
			end
		end
		return highest
	end

	AutoLeave = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoLeave",
		["Function"] = function(callback)
			if callback then 
				autoleaveconnection = players.PlayerAdded:Connect(autoleaveplradded)
				for i, plr in pairs(players:GetPlayers()) do 
					autoleaveplradded(plr)
				end
				if AutoLeaveGroupId["Value"] == "" or AutoLeaveRank["Value"] == "" then 
					task.spawn(function()
						local placeinfo = {Creator = {CreatorTargetId = tonumber(AutoLeaveGroupId["Value"])}}
						if AutoLeaveGroupId["Value"] == "" then
							placeinfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
							if placeinfo.Creator.CreatorType ~= "Group" then 
								local desc = placeinfo.Description:split("\n")
								for i, str in pairs(desc) do 
									local _, begin = str:find("roblox.com/groups/")
									if begin then 
										local endof = str:find("/", begin + 1)
										placeinfo = {Creator = {CreatorType = "Group", CreatorTargetId = str:sub(begin + 1, endof - 1)}}
									end
								end
							end
							if placeinfo.Creator.CreatorType ~= "Group" then 
								local warning = createwarning("AutoLeave", "Automatic Setup Failed\n(no group detected)", 60)
								local warningtext = warning:GetChildren()[5]
								warningtext.TextSize = 12
								warningtext.TextLabel.TextSize = 12
								warningtext.Position = warningtext.Position - UDim2.new(0, 0, 0, 4)
								return
							end
						end
						local groupinfo = game:GetService("GroupService"):GetGroupInfoAsync(placeinfo.Creator.CreatorTargetId)
						AutoLeaveGroupId["SetValue"](placeinfo.Creator.CreatorTargetId)
						AutoLeaveRank["SetValue"](autodetect(groupinfo.Roles))
						for i, plr in pairs(players:GetPlayers()) do 
							autoleaveplradded(plr)
						end
					end)
				end
			else
				if autoleaveconnection then autoleaveconnection:Disconnect() end
				for i,v in pairs(WhitelistFunctions.CustomTags) do 
					if v == "[GAME STAFF] " then 
						WhitelistFunctions.CustomTags[i] = nil
						local _, ent = entity.getEntityFromPlayer(i)
						if ent then 
							entity.entityUpdatedEvent:Fire(ent)
						end
					end
				end
			end
		end,
		["HoverText"] = "Leaves if a staff member joins your game."
	})
	AutoLeaveMode = AutoLeave.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"UnInject", "Rejoin", "Notify"},
		["Function"] = function() end
	})
	AutoLeaveGroupId = AutoLeave.CreateTextBox({
		["Name"] = "Group Id",
		["TempText"] = "0 (group id)",
		["Function"] = function() end
	})
	AutoLeaveRank = AutoLeave.CreateTextBox({
		["Name"] = "Rank Id",
		["TempText"] = "1 (rank id)",
		["Function"] = function() end
	})
end)

runcode(function()
	local Blink = {["Enabled"] = false}
	Blink = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Blink",
		["Function"] = function(callback)
			if callback then 
				if sethiddenproperty then
					RunLoops:BindToHeartbeat("Blink", 1, function()
						if entity.isAlive then 
							sethiddenproperty(entity.character.HumanoidRootPart, "NetworkIsSleeping", true)
						end
					end)
				else
					createwarning("Blink", "missing function", 5)
					Blink["ToggleButton"](false)
				end
			else
				RunLoops:UnbindFromHeartbeat("Blink")
			end
		end
	})
end)

runcode(function()
	local Disabler = {["Enabled"] = false}
	local DisablerAntiKick = {["Enabled"] = false}
	local disablerhooked = false

	local hookmethods = {
		Kick = function(self)
			if (not Disabler["Enabled"]) then return end
			if type(self) == "userdata" and self == lplr then 
				return true
			end
		end
	}
	hookmethods.kick = hookmethods.Kick

	Disabler = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ClientKickDisabler",
		["Function"] = function(callback)
			if callback then 
				if not disablerhooked then 
					disablerhooked = true
					local oldnamecall
					oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
						if (not Disabler["Enabled"]) then
							return oldnamecall(self, ...)
						end
						local method = getnamecallmethod()
						for i,v in pairs(hookmethods) do 
							if i == method and v(self, ...) then 
								return
							end
						end
						return oldnamecall(self, ...)
					end)
					local antikick
					antikick = hookfunction(lplr.Kick, function(self, ...)
						if (not Disabler["Enabled"]) then return antikick(self, ...) end
						if type(self) == "userdata" and self == lplr then 
							return
						end
						return antikick(self, ...)
					end)
				end
			end
		end
	})
end)
