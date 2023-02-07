--[[ 
	Credits
	mickeydev - Bypass for the actor garbage (thanks exploit developers, very cool) - https://v3rmillion.net/showthread.php?tid=1195926
]]
local bypassScript = [[
	shared.VapeWaiting = true
	-- variables
	local runService = game:GetService("RunService");
	local replicatedFirst = game:GetService("ReplicatedFirst");
	local insertService = game:GetService("InsertService");

	-- detection bypass
	insertService.DescendantAdded:Connect(function(instance)
		if instance:IsA("Actor") then
			instance:Destroy()
		end
	end);
	
	-- actor bypass
	replicatedFirst.ChildAdded:Connect(function(instance)
		if instance:IsA("Actor") then
			replicatedFirst.ChildAdded:Wait();
			for _, child in next, instance:GetChildren() do
				child.Parent = replicatedFirst;
			end
		end
	end);
	
	-- connect parallel bypass
	local old;
	old = hookmetamethod(runService.Stepped, "__index", function(self, index)
		local indexed = old(self, index);
		if index == "ConnectParallel" and not checkcaller() then
			hookfunction(indexed, newcclosure(function(signal, callback)
				return old(self, "Connect")(signal, function()
					return self:Wait() and callback();
				end);
			end));
		end
		return indexed;
	end);
	
	-- module destroy bypass
	task.spawn(function()
		local shared = getrenv().shared;

		repeat task.wait() until shared.close;

		getgenv().shared.RequireTable = shared.require
	end);			
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local textchatservice = game:GetService("TextChatService")
local httpservice = game:GetService("HttpService")
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
local alreadyjoined = shared.scriptalreadyjoinedservers and httpservice:JSONDecode(shared.scriptalreadyjoinedservers) or {}
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
if shared.VapeWaiting then repeat task.wait() until shared.RequireTable end
if shared.RequireTable == nil then 
	if shared.RequireTable == nil then
		if queueteleport then
			queueteleport(bypassScript)
			game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, lplr)
			task.wait(9e9)
        else
            local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
            local prompt = ErrorPrompt.new("Default")
            prompt._hideErrorCode = true
            local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
            prompt:setParent(gui)
            prompt:setErrorTitle("Vape")
            prompt:updateButtons({{
                Text = "OK",
                Callback = function() prompt:_close() end,
                Primary = true
            }}, 'Default')
            prompt:_open("Your exploit is unsupported by Phantom Forces Vape.")
            task.wait(9e9)
		end
	end
end
local pf = {}
local votekicked = 0
local votekickedsuccess = 0
local kills = 0
local tpstring
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

local WhitelistFunctions = shared.vapewhitelist
local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function friendCheck(plr, recolor)
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"].Enabled then
		local friend = table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)
		friend = friend and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][friend] and true or nil
		if recolor then
			friend = friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"].Enabled or nil
		end
		return friend
	end
	return nil
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"].Value) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local cachedassets = {}
local function getcustomassetfunc(path)
	if not betterisfile(path) then
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
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat task.wait() until betterisfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	if cachedassets[path] == nil then
		cachedassets[path] = getasset(path) 
	end
	return cachedassets[path]
end

local function targetCheck(plr)
	local ForceField = not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
	local state = plr.Humanoid.GetState(plr.Humanoid)
	return state ~= Enum.HumanoidStateType.Dead and state ~= Enum.HumanoidStateType.Physics and plr.Humanoid.Health > 0 and ForceField
end

local function isAlive(plr, alivecheck)
	if plr then
		local ind, tab = entity.getEntityFromPlayer(plr)
		return ((not alivecheck) or tab and tab.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) and tab
	end
	return entity.isAlive
end

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

local vischeckobj = RaycastParams.new()
local function vischeck(part, checktable, v)
	local bulspeed = checktable.Gun:getWeaponStat("bulletspeed")
	local grav = math.abs(pf.PublicSettings.bulletAcceleration.Y)
	local calculated = LaunchDirection(checktable.Origin, FindLeadShot(part.Position, v._velspring._v0 or Vector3.zero, bulspeed, checktable.Origin, Vector3.zero, grav), bulspeed, grav, false)
	if calculated then 
		return pf.BulletCheck(checktable.Origin, part.Position, calculated, pf.PublicSettings.bulletAcceleration, checktable.Gun:getWeaponStat("penetrationdepth"), 0.022222222222222223)
	end
	return false
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, pos)
	local returnedplayer = {}
	local currentamount = 0
	checktab = checktab or {}
	for i, v in pairs(pf.getEntities()) do -- loop through players
		if not v._alive then continue end
		if v._player.TeamColor ~= lplr.TeamColor then -- checks
			local mag = (pos - v._thirdPersonObject._torso.Position).magnitude
			if mag <= distance then -- mag check
				table.insert(returnedplayer, v)
				currentamount = currentamount + 1
			end
		end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance, checktab)
	local closest, returnedplayer, targetpart = distance, nil, nil
	checktab = checktab or {}
	if lplr.Character and lplr.Character.PrimaryPart then
		for i, v in pairs(pf.getEntities()) do -- loop through players
			if not v._alive then continue end
			if v._player.TeamColor ~= lplr.TeamColor then -- checks
				local mag = (lplr.Character.PrimaryPart.Position - v._thirdPersonObject[checktab.AimPart].Position).magnitude
				if mag <= closest then -- mag check
					if checktab.WallCheck then
						if not vischeck(v._thirdPersonObject._head, checktab, v) then continue end
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
    local mousepos = uis.GetMouseLocation(uis)
	for i, v in pairs(pf.getEntities()) do -- loop through players
		if not v._alive then continue end
		if v._player.TeamColor ~= lplr.TeamColor then -- checks
			local vec, vis = worldtoscreenpoint(v._thirdPersonObject[checktab.AimPart].Position)
			local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
			if vis and mag <= closest then -- mag check
				if checktab.WallCheck then
					if not vischeck(v._thirdPersonObject._head, checktab, v) then continue end
				end
				closest = mag
				returnedplayer = v
			end
		end
	end
    return returnedplayer
end

local finished = false
local uninject = false
local seeable = {}
local actuallyseeable = {}	
local NoFall = {Enabled = false}
runcode(function()
	local function getModule(name)
		return debug.getupvalue(shared.RequireTable, 1)._cache[name].module
	end
	local checkmodules = {
		"BulletCheck",
		"GameRoundInterface",
		"HudScopeInterface",
		"HudNotificationInterface",
		"MenuScreenGui",
		"network",
		"particle",
		"PlayerStatusEvents",
		"PublicSettings",
		"ReplicationInterface",
		"VoteKickInterface",
		"WeaponControllerInterface",
		"HudSpottingInterface",
		"sound",
		"CameraInterface"
	}
	repeat 
		task.wait() 
		local done = true
		for i,v in pairs(checkmodules) do 
			if not getModule(v) then
				done = false
				break
			end
		end
		if done then 
			break
		end
	until false
	local enttable = debug.getupvalue(getModule("ReplicationInterface").getEntry, 1)
	pf = {
		BulletCheck = getModule("BulletCheck"),
		CameraInterface = getModule("CameraInterface"),
		GameRoundInterface = getModule("GameRoundInterface"),
		getEntities = function() return enttable end,
		HudScopeInterface = getModule("HudScopeInterface"),
		HudSpottingInterface = getModule("HudSpottingInterface"),
		HudNotificationInterface = getModule("HudNotificationInterface"),
		MenuScreenGui = getModule("MenuScreenGui"),
		Network = getModule("network"),
		Particles = getModule("particle"),
		PlayerStatusEvents = getModule("PlayerStatusEvents"),
		PublicSettings = getModule("PublicSettings"),
		ReplicationInterface = getModule("ReplicationInterface"),
		Sound = getModule("sound"),
		VoteKickInterface = getModule("VoteKickInterface"),
		WeaponControllerInterface = getModule("WeaponControllerInterface")
	}
	RunLoops:BindToRenderStep("LegitRender", 1, function()
		local allowed = GuiLibrary["ObjectsThatCanBeSaved"]["ESPOptionsButton"]["Api"].Enabled or GuiLibrary["ObjectsThatCanBeSaved"]["TracersOptionsButton"]["Api"].Enabled
		if not allowed then return end
		for i,plr in pairs(enttable) do
			if plr._alive and plr._player.TeamColor ~= lplr.TeamColor then 
				actuallyseeable[plr._player.Name] = false
				if seeable[plr._player.Name] and seeable[plr._player.Name] >= tick() then
					actuallyseeable[plr._player.Name] = true
				else
					actuallyseeable[plr._player.Name] = pf.HudSpottingInterface.isSpotted(plr._player)
					if (not actuallyseeable[plr._player.Name]) then
						local char = plr._thirdPersonObject._character
						local ray = workspace:FindPartOnRayWithWhitelist(Ray.new(cam.CFrame.p, CFrame.lookAt(cam.CFrame.p, plr._thirdPersonObject._head.Position + Vector3.new(0, 0.5, 0)).LookVector * 1000), {table.unpack(pf.GameRoundInterface.raycastWhiteList), char})
						if ray and ray.Parent == char then
							actuallyseeable[plr._player.Name] = true
						end
					end
				end
			end
		end
	end)
end)

GuiLibrary.RemoveObject("NameTagsOptionsButton")
GuiLibrary.RemoveObject("BlinkOptionsButton")
GuiLibrary.RemoveObject("CapeOptionsButton")
GuiLibrary.RemoveObject("ChamsOptionsButton")
GuiLibrary.RemoveObject("DisguiseOptionsButton")
GuiLibrary.RemoveObject("HealthOptionsButton")
GuiLibrary.RemoveObject("ArrowsOptionsButton")
GuiLibrary.RemoveObject("BreadcrumbsOptionsButton")
GuiLibrary.RemoveObject("FOVChangerOptionsButton")
GuiLibrary.RemoveObject("FullbrightOptionsButton")
GuiLibrary.RemoveObject("ChatSpammerOptionsButton")
GuiLibrary.RemoveObject("AutoReportOptionsButton")
GuiLibrary.RemoveObject("MouseTPOptionsButton")
GuiLibrary.RemoveObject("PhaseOptionsButton")
GuiLibrary.RemoveObject("SpiderOptionsButton")
GuiLibrary.RemoveObject("SpinBotOptionsButton")
GuiLibrary.RemoveObject("SwimOptionsButton")
GuiLibrary.RemoveObject("AutoClickerOptionsButton")
GuiLibrary.RemoveObject("TriggerBotOptionsButton")
GuiLibrary.RemoveObject("FlyOptionsButton")
GuiLibrary.RemoveObject("GravityOptionsButton")
GuiLibrary.RemoveObject("HighJumpOptionsButton")
GuiLibrary.RemoveObject("FreecamOptionsButton")
GuiLibrary.RemoveObject("SafeWalkOptionsButton")
GuiLibrary.RemoveObject("KillauraOptionsButton")
GuiLibrary.RemoveObject("HitBoxesOptionsButton")
GuiLibrary.RemoveObject("SilentAimOptionsButton")
GuiLibrary.RemoveObject("ReachOptionsButton")
GuiLibrary.RemoveObject("ESPOptionsButton")
GuiLibrary.RemoveObject("TracersOptionsButton")

local teleported = false
local teleportfunc = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
	if (not teleported) and (not shared.VapeIndependent) then
		teleported = true
		local finaltp = (tpstring and 'shared.vapeoverlay = "'..tpstring..'"\n' or "").."shared.scriptalreadyjoinedservers = '"..httpservice:JSONEncode(alreadyjoined).."'\n"..bypassScript
		queueteleport(finaltp)
	end
end)
local oldnetwork = pf.Network.send
local oldbullet = pf.Particles.new
local oldaward = pf.HudNotificationInterface.bigAward
local oldsound = pf.Sound.PlaySound
local anglex = 0
local angley = 0
local AntiAim = {Enabled = false}
local AntiAimStance = {Value = "Stand"}
pf.Network.send = function(self, method, ...)
	if checkcaller() then return oldnetwork(self, method, ...) end
	if not method then return oldnetwork(self, method, ...) end
	local args = {...}

	if method == "logmessage" then
		return
	end

	if method == "repupdate" and AntiAim.Enabled then 

	end

	if NoFall.Enabled and method == "falldamage" then
		return
	end

	return oldnetwork(self, method, unpack(args))
end
pf.HudNotificationInterface.bigAward = function(awardtype, ...)
	if awardtype == "kill" then 
		kills = kills + 1
	end
	return oldaward(awardtype, ...)
end
pf.Sound.PlaySound = function(...)
	local args = {...}
	if args[1]:find("enemy") then
		local mag = (args[7].position - cam.CFrame.p).magnitude
		if mag <= 30 then
			local playersnear = GetAllNearestHumanoidToPosition(true, 5, args[7].Position)
			for i,v in pairs(playersnear) do
				seeable[v._player.Name] = tick() + 1.5
			end
		end
	end
	return oldsound(unpack(args))
end
runcode(function()
	local GunTracers = {Enabled = false}
	local GunTracersColor = {Hue = 0.44, Sat = 1, Value = 1}
	local GunTracersDelay = {Value = 10}
	local GunTracersFade = {Enabled = false}
	setreadonly(pf.Particles, false)
	pf.Particles.new = function(tab, ...)
		if tab.thirdperson and tab.penetrationdepth then
			local mag = (tab.position - cam.CFrame.p).magnitude
			if mag <= 60 then
				local playersnear = GetAllNearestHumanoidToPosition(true, 5, tab.position)
				for i,v in pairs(playersnear) do
					seeable[v._player.Name] = tick() + 1.5
				end
			end
		end
		if GunTracers.Enabled then
			if (not tab.thirdperson) and tab.penetrationdepth then
				local origin = tab.position
				local position = (origin + (tab.velocity.unit * 100))
				local distance = (origin - position).Magnitude
				local p = Instance.new("Part")
				p.Anchored = true
				p.CanCollide = false
				p.Transparency = 0.5
				p.Color = Color3.fromHSV(GunTracersColor.Hue, GunTracersColor.Sat, GunTracersColor.Value)
				p.Parent = workspace.Ignore
				p.Material = Enum.Material.Neon
				p.Size = Vector3.new(0.01, 0.01, distance)
				p.CFrame = CFrame.lookAt(origin, position) * CFrame.new(0, 0, -distance/2)
				game:GetService("Debris"):AddItem(p, GunTracersDelay.Value / 10)
			end
		end
		return oldbullet(tab)
	end
	setreadonly(pf.Particles, true)
	GunTracers =  GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "GunTracers",
		["Function"] = function(callback) end
	})
	GunTracersColor = GunTracers.CreateColorSlider({
		["Name"] = "Tracer Color",
		["Function"] = function() end
	})
	GunTracersDelay = GunTracers.CreateSlider({
		["Name"] = "Remove Delay",
		["Min"] = 1,
		["Max"] = 30,
		["Default"] = 10,
		["Function"] = function() end,
	})
end)
GuiLibrary["SelfDestructEvent"].Event:Connect(function()
	uninject = true
	if teleportfunc then teleportfunc:Disconnect() end
	pf.Network.send = oldnetwork
	setreadonly(pf.Particles, false)
	pf.Particles.new = oldbullet
	setreadonly(pf.Particles, true)
	pf.HudNotificationInterface.bigAward = oldaward
	pf.Sound.PlaySound = oldsound
	RunLoops:UnbindFromRenderStep("LegitRender")
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

local SilentAimPart
local SilentAimPart2
local SilentAimGun
local SilentAim = {Enabled = false}
local SilentAimAutoFire = {Enabled = false}
local SilentAimMode = {Enabled = false}
local SilentAimFOV = {Value = 1000}
local SilentAimHead = {Value = 100}
local ReachValue = {Value = 1000}
local Reach = {Enabled = false}
local KnifePart
local hook
local aimbound = false
local lastTarget
local lastTargetTick = tick()
local updateScope
hook = hookmetamethod(game, "__index", function(self, ind, val, ...)
	if ind ~= "CFrame" then return hook(self, ind, val, ...) end
	local realcf = hook(self, ind, val, ...)
	if self == KnifePart and Reach.Enabled then 
		return CFrame.new(realcf.Position + (cam.CFrame.lookVector * ReachValue.Value))
	end
	if (self == SilentAimPart or self == SilentAimPart2) and SilentAim.Enabled then
		local realcf = hook(self, ind, val, ...)
		local tar = (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHead.Value and "_head" or "_torso"
		local plr 
		local hit, pos, dir = workspace:FindPartOnRayWithIgnoreList(Ray.new(cam.CFrame.p, realcf.p - cam.CFrame.p), {
			workspace.Players:FindFirstChild(lplr.TeamColor.Name),
			workspace.Terrain,
			workspace.Ignore,
			workspace.CurrentCamera
		})
		local realAimPos = pos + (0.01 * dir)
		if SilentAimMode.Value == "Legit" then
			plr = GetNearestHumanoidToMouse(true, SilentAimFOV.Value, {
				AimPart = tar,
				Gun = SilentAimGun,
				Origin = realAimPos,
				WallCheck = true
			})
		else
			plr = GetNearestHumanoidToPosition(true, SilentAimFOV.Value, {
				AimPart = tar,
				Gun = SilentAimGun,
				Origin = realAimPos,
				WallCheck = true
			})
		end
		if plr then 
			local aimpos = plr._thirdPersonObject[tar].Position
			local bulspeed = SilentAimGun:getWeaponStat("bulletspeed")
			local grav = math.abs(pf.PublicSettings.bulletAcceleration.Y)
			local calculated = LaunchDirection(realAimPos, FindLeadShot(aimpos, plr._velspring._v0 or Vector3.zero, bulspeed, realAimPos, Vector3.zero, grav), bulspeed, grav, false)
			if calculated then 
				lastTargetTick = tick() + 1
				lastTarget = plr
				return CFrame.new(realcf.p, realcf.p + calculated)
			end
		end
	end
	return realcf
end)

runcode(function()
	local shooting = false
	SilentAim = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SilentAim", 
		["Function"] = function(callback) 
			if callback then 
				task.spawn(function()
					repeat
						targetinfo.Targets.SilentAim = nil
						if lastTargetTick <= tick() and lastTarget then
							lastTarget = nil
						end
						if lastTarget then
							targetinfo.Targets.SilentAim = {
								Player = lastTarget._player,
								Humanoid = {
									Health = lastTarget._healthstate.health0,
									MaxHealth = 100
								}
							}
						end
						local controller = pf.WeaponControllerInterface:getController()
						SilentAimGun = controller and controller:getActiveWeapon()
						if SilentAimGun and SilentAimGun:getWeaponType() == "Firearm" then 
							SilentAimPart = SilentAimGun._barrelPart
							SilentAimPart2 = SilentAimGun:getActiveAimStat("sightpart")
							if SilentAimAutoFire.Enabled then
								local tar = (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHead.Value and "_head" or "_torso"
								local plr 
								local hit, pos, dir = workspace:FindPartOnRayWithIgnoreList(Ray.new(cam.CFrame.p, SilentAimPart.Position - cam.CFrame.p), {
									workspace.Players:FindFirstChild(lplr.TeamColor.Name),
									workspace.Terrain,
									workspace.Ignore,
									workspace.CurrentCamera
								})
								local realAimPos = pos + (0.01 * dir)
								if SilentAimMode.Value == "Legit" then
									plr = GetNearestHumanoidToMouse(true, SilentAimFOV.Value, {
										AimPart = tar,
										Gun = SilentAimGun,
										Origin = realAimPos,
										WallCheck = true
									})
								else
									plr = GetNearestHumanoidToPosition(true, SilentAimFOV.Value, {
										AimPart = tar,
										Gun = SilentAimGun,
										Origin = realAimPos,
										WallCheck = true
									})
								end
								SilentAimGun:shoot(plr and true or false)
							end
						end
						task.wait()
					until (not SilentAim.Enabled)
				end)
				updateScope = pf.HudScopeInterface.updateScope
				pf.HudScopeInterface.updateScope = function(pos1, pos2, size1, size2)
					if lastTargetTick > tick() then 
						pos1 = UDim2.new(0, cam.ViewportSize.X / 2, 0, cam.ViewportSize.Y / 2)
						pos2 = UDim2.new(0, cam.ViewportSize.X / 2, 4.439627332431e-09, cam.ViewportSize.Y / 2)
						size1 = UDim2.new(1.12, 0, 1.12, 0)
						size2 = UDim2.new(0.9, 0, 0.9, 0)
					end
					return updateScope(pos1, pos2, size1, size2)
				end
			else
				pf.HudScopeInterface.updateScope = updateScope
				updateScope = nil
				SilentAimGun = nil
				SilentAimPart = nil
				SilentAimPart2 = nil
			end
		end
	})
	SilentAimMode = SilentAim.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Legit", "Blatant"},
		["Function"] = function() end
	})
	SilentAimFOV = SilentAim.CreateSlider({
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
	SilentAimHead = SilentAim.CreateSlider({
		["Name"] = "Headshot Chance", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 25
	})
	SilentAimAutoFire = SilentAim.CreateToggle({
		["Name"] = "AutoFire",
		["Function"] = function() end
	})
end)

runcode(function()
	local aimbound = false
	local lastTarget
	local lastTargetTick = tick()
	local updateScope
	Reach = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Reach", 
		["Function"] = function(callback) 
			if callback then 
				local part
				local gun
				task.spawn(function()
					repeat
						task.wait()
						local controller = pf.WeaponControllerInterface:getController()
						local Knife = controller and controller:getActiveWeapon()
						if Knife and Knife:getWeaponType() == "Melee" then 
							KnifePart = Knife._tipPart
						end
					until (not Reach.Enabled)
				end)
			else
				Knife = nil
			end
		end
	})
	ReachValue = Reach.CreateSlider({
		["Name"] = "Reach", 
		["Min"] = 1, 
		["Max"] = 18, 
		["Function"] = function(val) end,
		["Default"] = 18
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

	local ESPColor = {Value = 0.44}
	local ESPHealthBar = {Enabled = false}
	local ESPBoundingBox = {Enabled = true}
	local ESPName = {Enabled = true}
	local ESPMethod = {Value = "2D"}
	local ESPTeammates = {Enabled = true}
	local ESPMode = {Value = "Legit"}
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
			if ESPTeammates.Enabled and plr._player.TeamColor == lplr.TeamColor then return end
			local thing = {}
			thing.Quad1 = Drawing.new("Square")
			thing.Quad1.Transparency = ESPBoundingBox.Enabled and 1 or 0
			thing.Quad1.ZIndex = 2
			thing.Quad1.Filled = false
			thing.Quad1.Thickness = 1
			thing.Quad1.Color = getPlayerColor(plr._player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor.Value)
			thing.QuadLine2 = Drawing.new("Square")
			thing.QuadLine2.Transparency = ESPBoundingBox.Enabled and 0.5 or 0
			thing.QuadLine2.ZIndex = 1
			thing.QuadLine2.Thickness = 1
			thing.QuadLine2.Filled = false
			thing.QuadLine2.Color = Color3.new(0, 0, 0)
			thing.QuadLine3 = Drawing.new("Square")
			thing.QuadLine3.Transparency = ESPBoundingBox.Enabled and 0.5 or 0
			thing.QuadLine3.ZIndex = 1
			thing.QuadLine3.Thickness = 1
			thing.QuadLine3.Filled = false
			thing.QuadLine3.Color = Color3.new(0, 0, 0)
			if ESPHealthBar.Enabled then 
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
			if ESPName.Enabled then 
				thing.Text = Drawing.new("Text")
				thing.Text.Text = WhitelistFunctions:GetTag(plr._player)..(plr._player.DisplayName or plr._player.Name)
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
			espfolderdrawing[plr._player] = {entity = plr, Main = thing}
		end,
		DrawingSkeleton = function(plr)
			if ESPTeammates.Enabled and plr._player.TeamColor == lplr.TeamColor then return end
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
			local color = getPlayerColor(plr._player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr._player] = {entity = plr, Main = thing}
		end,
		Drawing3D = function(plr)
			if ESPTeammates.Enabled and plr._player.TeamColor == lplr.TeamColor then return end
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
			local color = getPlayerColor(plr._player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr._player] = {entity = plr, Main = thing}
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
	local espcolorfuncs = {
		Drawing2D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				v.Main.Quad1.Color = getPlayerColor(v.entity._player) or color
				if v.Main.Text then 
					v.Main.Text.Color = v.Main.Quad1.Color
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
		DrawingSkeleton = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					v2.Color = getPlayerColor(v.entity.Player) or color
				end
			end
		end
	}
	local esploop = {
		Drawing2D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity._thirdPersonObject._torso.Position)
				if rootVis then 
					if ESPMode.Value == "Legit" then 
						rootVis = actuallyseeable[v.entity._player.Name] or v.entity._player.TeamColor == lplr.TeamColor
					end
				end
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
				local topPos, topVis = cam:WorldToViewportPoint((CFrame.new(v.entity._thirdPersonObject._torso.Position, v.entity._thirdPersonObject._torso.Position + cam.CFrame.lookVector) * CFrame.new(2, 3, 0)).p)
				local bottomPos, bottomVis = cam:WorldToViewportPoint((CFrame.new(v.entity._thirdPersonObject._torso.Position, v.entity._thirdPersonObject._torso.Position + cam.CFrame.lookVector) * CFrame.new(-2, -3.5, 0)).p)
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
					local healthposy = sizey * math.clamp(v.entity._healthstate.health0 / v.entity._healthstate.maxhealth, 0, 1)
					v.Main.Quad3.Visible = v.entity._healthstate.health0 > 0
					v.Main.Quad3.From = floorpos(Vector2.new(posx - 4, posy + (sizey - (sizey - healthposy))))
					v.Main.Quad3.To = floorpos(Vector2.new(posx - 4, posy))
					local color = HealthbarColorTransferFunction(v.entity._healthstate.health0 / v.entity._healthstate.maxhealth)
					v.Main.Quad3.Color = color
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
		Drawing3D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity._thirdPersonObject._torso.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local point1 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(1.5, 3, 1.5))
				local point2 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(1.5, -3, 1.5))
				local point3 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(-1.5, 3, 1.5))
				local point4 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(-1.5, -3, 1.5))
				local point5 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(1.5, 3, -1.5))
				local point6 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(1.5, -3, -1.5))
				local point7 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(-1.5, 3, -1.5))
				local point8 = CalculateObjectPosition(v.entity._thirdPersonObject._torso.Position + Vector3.new(-1.5, -3, -1.5))
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
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity._thirdPersonObject._torso.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local head = CalculateObjectPosition((v.entity._thirdPersonObject._head.CFrame).p)
				local headfront = CalculateObjectPosition((v.entity._thirdPersonObject._head.CFrame * CFrame.new(0, 0, -0.5)).p)
				local toplefttorso = CalculateObjectPosition((v.entity._thirdPersonObject._torso.CFrame * CFrame.new(-1.5, 0.8, 0)).p)
				local toprighttorso = CalculateObjectPosition((v.entity._thirdPersonObject._torso.CFrame * CFrame.new(1.5, 0.8, 0)).p)
				local toptorso = CalculateObjectPosition((v.entity._thirdPersonObject._torso.CFrame * CFrame.new(0, 0.8, 0)).p)
				local bottomtorso = CalculateObjectPosition((v.entity._thirdPersonObject._torso.CFrame * CFrame.new(0, -0.8, 0)).p)
				local bottomlefttorso = CalculateObjectPosition((v.entity._thirdPersonObject._torso.CFrame * CFrame.new(-0.5, -0.8, 0)).p)
				local bottomrighttorso = CalculateObjectPosition((v.entity._thirdPersonObject._torso.CFrame * CFrame.new(0.5, -0.8, 0)).p)
				local leftarm = CalculateObjectPosition((v.entity._thirdPersonObject._lsh.Part1.CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightarm = CalculateObjectPosition((v.entity._thirdPersonObject._rsh.Part1.CFrame * CFrame.new(0, -0.8, 0)).p)
				local leftleg = CalculateObjectPosition((v.entity._thirdPersonObject._lhip.Part1.CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightleg = CalculateObjectPosition((v.entity._thirdPersonObject._rhip.Part1.CFrame * CFrame.new(0, -0.8, 0)).p)
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
				methodused = "Drawing"..ESPMethod.Value
				if espfuncs2[methodused] then
					local removefunc = espfuncs2[methodused]
					removedconnection = pf.PlayerStatusEvents.onPlayerDied:Connect(function(plr, pos, tab)
						removefunc(plr)
					end)
				end
				if espfuncs1[methodused] then
					local addfunc = espfuncs1[methodused]
					for i,v in pairs(pf.getEntities()) do 
						if espfolderdrawing[v._player] then espfuncs2[methodused](v._player) end
						if v._alive then
							addfunc(v)
						end
					end
					addedconnection = pf.PlayerStatusEvents.onPlayerSpawned:Connect(function(plr, pos, tab)
						local ent = pf.ReplicationInterface.getEntry(plr)
						if espfolderdrawing[plr] then espfuncs2[methodused](plr) end
						addfunc(ent)
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
					for i,v in pairs(espfolderdrawing) do 
						espfuncs2[methodused](i)
					end
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPColor = ESP.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(hue, sat, val) 
			if ESP.Enabled and espcolorfuncs[methodused] then 
				espcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	ESPMode = ESP.CreateDropdown({
		["Name"] = "Visible",
		["List"] = {"Blatant", "Legit"},
		["Function"] = function() end
	})
	ESPMethod = ESP.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"2D", "3D", "Skeleton"},
		["Function"] = function(val)
			if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end
			ESPBoundingBox["Object"].Visible = (val == "2D")
			ESPHealthBar["Object"].Visible = (val == "2D")
			ESPName["Object"].Visible = (val == "2D")
		end,
	})
	ESPBoundingBox = ESP.CreateToggle({
		["Name"] = "Bounding Box",
		["Function"] = function() if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end,
		["Default"] = true
	})
	ESPTeammates = ESP.CreateToggle({
		["Name"] = "Priority Only",
		["Function"] = function() if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end,
		["Default"] = true
	})
	ESPHealthBar = ESP.CreateToggle({
		["Name"] = "Health Bar", 
		["Function"] = function(callback) if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end
	})
	ESPName = ESP.CreateToggle({
		["Name"] = "Name", 
		["Function"] = function(callback) if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end
	})
end)

runcode(function()
	
	local killauraboxes = {}
	local killauraaps = {["GetRandomValue"] = function() return 1 end}
	local killauramethod = {Value = "Normal"}
	local killauratarget = {Enabled = false}
	local killauratargethighlight = {Enabled = false}
	local killaurarangecircle = {Enabled = false}
	local killaurarangecirclepart
	local killauracolor = {Value = 0.44}
	local killaurarange = {Value = 1}
	local killauraangle = {Value = 90}
	local killauramouse = {Enabled = false}
	local killauratargetframe = {["Players"] = {Enabled = false}}
	local killauracframe = {Enabled = false}
	local Killaura = {Enabled = false}
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
					if lplr.Character and lplr.Character.PrimaryPart then
						if killauraaimcirclepart then 
							killauraaimcirclepart.Position = targetedplayer and closestpos(targetedplayer._thirdPersonObject._torso, lplr.Character.PrimaryPart.Position) or Vector3.zero
						end
						local Root = lplr.Character.PrimaryPart
						if Root then
							if killaurarangecirclepart then 
								killaurarangecirclepart.Position = Root.Position - Vector3.new(0, lplr.Character.Humanoid.HipHeight, 0)
							end
						end
					end
				end)
				task.spawn(function()
					repeat
						local attackedplayers = {}
						targetinfo.Targets.Killaura = nil
						if lplr.Character and lplr.Character.PrimaryPart then
							local plr = GetNearestHumanoidToPosition(killauratargetframe["Players"].Enabled, killaurarange.Value, {
								AimPart = "_head",
								WallCheck = false
							})
							if plr then
								local localfacing = lplr.Character.PrimaryPart.CFrame.lookVector
								local vec = (plr._thirdPersonObject._torso.Position - lplr.Character.PrimaryPart.Position).unit
								local angle = math.acos(localfacing:Dot(vec))
								if angle >= (math.rad(killauraangle.Value) / 2) then continue end
								killauranear = true
								targetinfo.Targets.Killaura = {
									Player = plr._player,
									Humanoid = {
										Health = plr._healthstate.health0,
										MaxHealth = 100
									}
								}
								if killauratarget.Enabled then
									table.insert(attackedplayers, plr)
								end
								targetedplayer = plr
								local playertype, playerattackable = WhitelistFunctions:CheckPlayerType(plr._player)
								if not playerattackable then
									continue
								end
								pf.Network:send("knifehit", plr._player, "Head")
							end
							for i,v in pairs(killauraboxes) do 
								local attacked = attackedplayers[i]
								v.Adornee = attacked and ((not killauratargethighlight.Enabled) and attacked._thirdPersonObject._torso or (not GuiLibrary["ObjectsThatCanBeSaved"]["ChamsOptionsButton"]["Api"].Enabled) and attacked.Character or nil)
							end
							if not plr then
								lastplr = nil
								targetedplayer = nil
								killauranear = false
							end
						end
						task.wait()
					until (not Killaura.Enabled)
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
	killaurarange = Killaura.CreateSlider({
		["Name"] = "Attack range",
		["Min"] = 1,
		["Max"] = 30, 
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
					killaurabox.Color3 = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
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
				v[(killauratargethighlight.Enabled and "FillColor" or "Color3")] = Color3.fromHSV(hue, sat, val)
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
		killaurabox.Color3 = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
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
				killaurarangecirclepart.Color = Color3.fromHSV(killauracolor["Hue"], killauracolor["Sat"], killauracolor.Value)
				killaurarangecirclepart.CanCollide = false
				killaurarangecirclepart.Anchored = true
				killaurarangecirclepart.Material = Enum.Material.Neon
				killaurarangecirclepart.Size = Vector3.new(killaurarange.Value * 0.7, 0.01, killaurarange.Value * 0.7)
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

runcode(function()
	local tracersfolderdrawing = {}
	local methodused

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local TracersMode = {Value = "Blatant"}
	local TracersColor = {Value = 0.44}
	local TracersTransparency = {Value = 1}
	local TracersStartPosition = {Value = "Middle"}
	local TracersEndPosition = {Value = "Head"}
	local TracersTeammates = {Enabled = true}
	local tracersconnections = {}
	local addedconnection
	local removedconnection
	local updatedconnection

	local tracersfuncs1 = {
		Drawing = function(plr)
			if TracersTeammates.Enabled and plr._player.TeamColor == lplr.TeamColor then return end
			local newobj = Drawing.new("Line")
			newobj.Thickness = 1
			newobj.Transparency = 1 - (TracersTransparency.Value / 100)
			newobj.Color = getPlayerColor(plr._player) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor.Value)
			tracersfolderdrawing[plr._player] = {entity = plr, Main = newobj}
		end
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
				local rootPart = v.entity._thirdPersonObject[TracersEndPosition.Value == "Torso" and "_torso" or "_head"].Position
				local rootPos, rootVis = cam:WorldToViewportPoint(rootPart)
				local screensize = cam.ViewportSize
				local startVector = TracersStartPosition.Value == "Mouse" and uis:GetMouseLocation() or Vector2.new(screensize.X / 2, (TracersStartPosition.Value == "Middle" and screensize.Y / 2 or screensize.Y))
				local endVector = Vector2.new(rootPos.X, rootPos.Y)
				v.Main.Visible = rootVis
				v.Main.From = startVector
				v.Main.To = endVector
				if TracersMode.Value == "Legit" then 
					v.Main.Visible = actuallyseeable[v.entity._player.Name] or v.entity._player.TeamColor == lplr.TeamColor
				else
					v.Main.Visible = true
				end
			end
		end,
	}

	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				methodused = "Drawing"
				if tracersfuncs2[methodused] then
					local removefunc = tracersfuncs2[methodused]
					removedconnection = pf.PlayerStatusEvents.onPlayerDied:Connect(function(plr, pos, tab)
						removefunc(plr)
					end)
				end
				if tracersfuncs1[methodused] then
					local addfunc = tracersfuncs1[methodused]
					for i,v in pairs(pf.getEntities()) do 
						if tracersfolderdrawing[v._player] then tracersfuncs2[methodused](v._player) end
						if v._alive then
							addfunc(v)
						end
					end
					addedconnection = pf.PlayerStatusEvents.onPlayerSpawned:Connect(function(plr, pos, tab)
						local ent = pf.ReplicationInterface.getEntry(plr)
						if tracersfolderdrawing[plr] then tracersfuncs2[methodused](plr) end
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
				for i,v in pairs(tracersfolderdrawing) do 
					if tracersfuncs2[methodused] then
						tracersfuncs2[methodused](i)
					end
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an Tracers on players."
	})
	TracersMode = Tracers.CreateDropdown({
		["Name"] = "Visible",
		["List"] = {"Blatant", "Legit"},
		["Function"] = function() end
	})
	TracersStartPosition = Tracers.CreateDropdown({
		["Name"] = "Start Position",
		["List"] = {"Middle", "Bottom", "Mouse"},
		["Function"] = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		["Name"] = "End Position",
		["List"] = {"Head", "Torso"},
		["Function"] = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end
	})
	TracersColor = Tracers.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(hue, sat, val) 
			if Tracers.Enabled and tracerscolorfuncs[methodused] then 
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
					v.Main.Transparency = 1 - (val / 100)
				end
			end
		end,
		["Default"] = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		["Name"] = "Priority Only",
		["Function"] = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end,
		["Default"] = true
	})
end)

local AutoVotekick = {Enabled = false}
local AutoVotekickAnswer = {Value = "Yes"}
local onreport
local onrejoin
task.spawn(function()
	local title = lplr.PlayerGui.ChatScreenGui:WaitForChild("Main"):WaitForChild("DisplayVoteKick"):WaitForChild("TextTitle")
	onreport = title.Parent:GetPropertyChangedSignal("Visible"):connect(function()
		if title.Parent.Visible then
			task.wait(1)
			local str = title.Text:sub(10, title.Text:len() - 19)
			if str == lplr.Name then
				votekicked = votekicked + 1
				if AutoVotekick.Enabled then
					pf.VoteKickInterface.vote("no")
				end
			else
				if AutoVotekick.Enabled then
					pf.VoteKickInterface.vote(AutoVotekickAnswer.Value:lower())
				end
			end
		end
	end)

	local getrandomserver
	local alreadyjoining = false
	local placeid = game.PlaceId
	local maxplayers = tonumber(players.MaxPlayers)
	local getrandomserver
	local alreadyjoining = false
	getrandomserver = function(pointer)
		alreadyjoining = true
		local data = requestfunc({
			Url = "https://games.roblox.com/v1/games/"..placeid.."/servers/Public?sortOrder=Desc&limit=100"..(pointer and "&cursor="..pointer or ""),
			Method = "GET"
		}).Body
		local decodeddata = game:GetService("HttpService"):JSONDecode(data)
		local chosenServer
		if decodeddata.data == nil then alreadyjoining = false return end
		for i, v in pairs(decodeddata.data) do
			if (tonumber(v.playing) < maxplayers) and tonumber(v.ping) < 300 and v.id ~= game.JobId and table.find(alreadyjoined, v.id) == nil then 
				chosenServer = v.id
				break
			end
		end
		if chosenServer then 
			table.insert(alreadyjoined, game.JobId)
			alreadyjoining = false
			game:GetService("TeleportService"):TeleportToPlaceInstance(placeid, chosenServer, lplr)
		else
			if decodeddata.nextPageCursor then
				getrandomserver(decodeddata.nextPageCursor)
			else
				alreadyjoining = false
			end
		end
	end
	local overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
	onrejoin = overlay.DescendantAdded:Connect(function(obj)
		if obj.Name == "ErrorMessage" then
			obj:GetPropertyChangedSignal("Text"):Connect(function()
				if obj.Text:find("votekicked") and AutoRejoin.Enabled then
					votekickedsuccess = votekickedsuccess + 1
					getrandomserver()
				end
			end)
		end
	end)
end)

runcode(function()
	NoFall = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NoFall", 
		["Function"] = function(callback) end,
		["HoverText"] = "Removes Fall Damage"
	})
	AutoRejoin = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoRejoin", 
		["Function"] = function(callback) end,
		["HoverText"] = "Rejoins when you get kicked."
	})
	AutoVotekick = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoVote", 
		["Function"] = function(callback) end,
		["HoverText"] = "Automatically votes on kick requests."
	})
	AutoVotekickAnswer = AutoVotekick.CreateDropdown({
		["Name"] = "Vote",
		["List"] = {"Yes", "Dismiss", "No"},
		["Function"] = function() end
	})
end)

runcode(function()
	local AutoRespawn
	GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoRespawn", 
		["Function"] = function(callback) 
			if callback then 
				AutoRespawn = pf.MenuScreenGui.onEnabled:connect(function()
					if not lplr.PlayerGui:FindFirstChild("Loadscreen") then
						pf.Network:send("spawn")
					end
				end)
			else
				if AutoRespawn then AutoRespawn:Disconnect() end
			end
		end
	})
end)

runcode(function()
	local GrenadeESP = {Enabled = false}
	local grenadefolder = Instance.new("Folder")
	grenadefolder.Name = "GrenadeFolder"
	grenadefolder.Parent = GuiLibrary["MainGui"]
	local grenadeconnection
	GrenadeESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "GrenadeESP", 
		["Function"] = function(callback) 
			if callback then
				grenadeconnection = workspace.Ignore.Misc.ChildAdded:connect(function(part)
					if part.Name == "Trigger" then
						local partframe = Instance.new("Frame")
						partframe.Size = UDim2.new(0, 40, 0, 40)
						partframe.AnchorPoint = Vector2.new(0.5, 0.5)
						partframe.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
						partframe.Parent = grenadefolder
						local partdistance = Instance.new("TextLabel")
						partdistance.Font = Enum.Font.SourceSans
						partdistance.TextColor3 = Color3.fromRGB(100, 100, 100)
						partdistance.TextSize = 10
						partdistance.BackgroundTransparency = 1
						partdistance.Size = UDim2.new(1, 0, 0, 10)
						partdistance.Position = UDim2.new(0, 0, 1, -15)
						partdistance.Parent = partframe
						local partdamage = Instance.new("TextLabel")
						partdamage.Font = Enum.Font.SourceSans
						partdamage.TextColor3 = Color3.fromRGB(220, 220, 220)
						partdamage.TextSize = 15
						partdamage.BackgroundTransparency = 1
						partdamage.Size = UDim2.new(1, 0, 0, 35)
						partdamage.Position = UDim2.new(0, 0, 0, 0)
						partdamage.Parent = partframe
						local partcorner = Instance.new("UICorner")
						partcorner.CornerRadius = UDim.new(0, 64)
						partcorner.Parent = partframe
						local partconnection; partconnection = game:GetService("RunService").RenderStepped:connect(function()
							if part == nil or part.Parent == nil or partframe == nil or partframe.Parent == nil then
								if partconnection then
									partconnection:Disconnect()
								end
								if partframe then
									partframe:Remove()
								end
								return
							end
							local localroot = lplr.Character and lplr.Character.PrimaryPart
							if localroot then
								local mag = (part.Position - localroot.Position).magnitude
								local rootPos, rootVis = cam:WorldToViewportPoint(part.Position)
								partframe.Visible = mag <= 50 and rootVis
								partframe.Position = UDim2.new(0, rootPos.X, 0, rootPos.Y - 36)
								partdistance.Text = math.floor(mag / 5).."m"
								local damagetext = "Safe"
								if mag < 30 then
									if not workspace:FindPartOnRayWithWhitelist(Ray.new(part.Position, (localroot.Position - part.Position)), pf.GameRoundInterface.raycastWhiteList, true) then
										local damage = (mag < 8 and 250 or (mag < 30 and (15 - 250) / (30 - 8) * (mag - 8) + 250 or 15))
										damagetext = (damage > 100 and "Fatal" or "-"..math.floor(damage))
									end
								end
								partdamage.Text = damagetext
							else
								partframe.Visible = false
							end
						end)
					end
				end)
			else
				if grenadeconnection then
					grenadeconnection:Disconnect()
				end
				grenadefolder:ClearAllChildren()
			end
		end
	})
end)

runcode(function()
	local CameraModification = {Enabled = false}
	local CameraRecoil = {Value = 100}
	local CameraSway = {Value = 100}
	local old1
	local old2
	local old3
	local old4
	CameraModification = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "CameraModification",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if (not CameraModification.Enabled) then break end
						task.wait(0.1)
						local newcam = pf.CameraInterface.getActiveCamera("MainCamera")
						if newcam then
							if not old1 then 
								old1 = newcam._publicSprings.shakespring.s
								old2 = newcam._publicSprings.swayspeed.s
							end
							newcam._publicSprings.shakespring.s = old1 * (100 / CameraRecoil.Value)
							newcam._publicSprings.zanglespring.s = 100
						end
						if (not CameraModification.Enabled) then break end
					until (not CameraModification.Enabled)
				end)
			else
				local newcam = pf.CameraInterface.getActiveCamera("MainCamera")
				if newcam then
					newcam._publicSprings.shakespring.s = old1
					newcam._publicSprings.swayspeed.s = old2
				end
			end
		end
	})
	CameraRecoil = CameraModification.CreateSlider({
		["Name"] = "Recoil Percent",
		["Min"] = 1,
		["Max"] = 100,
		["Default"] = 100,
		["Function"] = function(val) 
		end
	})
end)

runcode(function()
	tpstring = shared.vapeoverlay or nil
	local origtpstring = tpstring
	local Overlay = GuiLibrary.CreateCustomWindow({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png",
		["IconSize"] = 16
	})
	local overlayframe = Instance.new("Frame")
	overlayframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe.Size = UDim2.new(0, 200, 0, 120)
	overlayframe.Position = UDim2.new(0, 0, 0, 5)
	overlayframe.Parent = Overlay.GetCustomChildren()
	local overlayframe2 = Instance.new("Frame")
	overlayframe2.Size = UDim2.new(1, 0, 0, 10)
	overlayframe2.Position = UDim2.new(0, 0, 0, -5)
	overlayframe2.Parent = overlayframe
	local overlayframe3 = Instance.new("Frame")
	overlayframe3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe3.Size = UDim2.new(1, 0, 0, 6)
	overlayframe3.Position = UDim2.new(0, 0, 0, 6)
	overlayframe3.BorderSizePixel = 0
	overlayframe3.Parent = overlayframe2
	local oldguiupdate = GuiLibrary["UpdateUI"]
	GuiLibrary["UpdateUI"] = function(h, s, v, ...)
		overlayframe2.BackgroundColor3 = Color3.fromHSV(h, s, v)
		return oldguiupdate(h, s, v, ...)
	end
	local framecorner1 = Instance.new("UICorner")
	framecorner1.CornerRadius = UDim.new(0, 5)
	framecorner1.Parent = overlayframe
	local framecorner2 = Instance.new("UICorner")
	framecorner2.CornerRadius = UDim.new(0, 5)
	framecorner2.Parent = overlayframe2
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -7, 1, -5)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.GothamBold
	label.LineHeight = 1.2
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextSize = 16
	label.Text = ""
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Position = UDim2.new(0, 7, 0, 5)
	label.Parent = overlayframe
	Overlay["Bypass"] = true
	GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png", 
		["Function"] = function(callback)
			Overlay.SetVisible(callback) 
			if callback then
				task.spawn(function()
					repeat
						wait(1)
						if not tpstring then
							tpstring = tick().."/0/0/0"
							origtpstring = tpstring
						end
						local splitted = origtpstring:split("/")
						label.Text = string.format([[
Session Info
Time Played : %s
Kills : %s
VK Attempts : %s
VK : %s]], os.date("!%X",math.floor(tick() - splitted[1])), (splitted[2] + kills), (splitted[3] + votekicked), (splitted[4] + votekickedsuccess))
						local textsize = textservice:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(100000, 100000))
						overlayframe.Size = UDim2.new(0, math.max(textsize.X + 19, 200), 0, (textsize.Y * 1.2) + 10)
						tpstring = splitted[1].."/"..(splitted[2] + kills).."/"..(splitted[3] + votekicked).."/"..(splitted[4] + votekickedsuccess)
					until (Overlay and Overlay.GetCustomChildren() and Overlay.GetCustomChildren().Parent and Overlay.GetCustomChildren().Parent.Visible == false)
				end)
			end
		end, 
		["Priority"] = 2
	})
end)
