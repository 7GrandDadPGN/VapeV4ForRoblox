--[[ 
	Credits
	Herett - Silent Aim, slightly modified
	whoever made the thirdperson, tried making my own by hooking the bulkplayerupdate but failed
	pf 2013 leak even tho I could have just used math.rad
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local realreq = (getrenv and getrenv().require or require)
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset
local teleportfunc
local phantomforces = {}
local vec3 = Vector3.new
local vec2 = Vector2.new
local col3 = Color3.new
local ThirdPerson = {["Enabled"] = false}

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
			textlabel.TextColor3 = col3(1, 1, 1)
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
	local char = phantomforces["GetCharacter"](plr)
	return char and char:FindFirstChild("Torso") and true or false
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and shared.vapeteamcheck(plr)
end

local function raycast(ray, ignore, callback)
	local ignore = ignore or {}

	local hit, pos, normal, material = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
	while hit and callback do
		local Continue, _ignore = callback(hit)
		if not Continue then
			break
		end
		if _ignore then
			table.insert(ignore, _ignore)
		else
			table.insert(ignore, hit)
		end
		hit, pos, normal, material = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
	end
	return hit, pos, normal, material
end

local function oldvischeck(pos, ignored) -- 1 ray > 1 obscuringthing | 100 rays < 1 obscuring thing
	local parts = cam:GetPartsObscuringTarget({pos}, ignored or {})
	return parts
end

local function vischeck(localchar, char, root, max, ...)
	local pos = root.Position
    if max > 4 then
        local parts = oldvischeck(pos, {localchar, ..., cam, char, root, workspace:FindFirstChild("Ignore"), })
            
        return parts <= max
    else
        local camp = cam.CFrame.p
        local dist = (camp - pos).Magnitude

        local hitt = 0
        local hit = raycast(Ray.new(camp, (pos - camp).unit * dist), {localchar, ..., cam}, function(hit)
            if hit.Name == "Window" then
                return true
            end

            if hit.CanCollide == true then-- hit.Transparency ~= 1 then
                hitt = hitt + 1
                return hitt < max
            end
            
            if hit:IsDescendantOf(char) then
                return
            end

            return true
        end)

        return hit == nil or hit:IsDescendantOf(char) or hitt <= max, hitt
    end
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(pos, distance)
    local closestplayers = {}
	for i, v in pairs(players:GetChildren()) do
		local char = phantomforces["GetCharacter"](v)
		if char then
			local root = char and char:FindFirstChild("Head")
			if root then
				if (root.Position - pos).magnitude <= distance then
					table.insert(closestplayers, v)
				end
			end
		end
	end
	return closestplayers
end

local function GetNearestHumanoidToPosition(player, distance, wall)
    local closest, returnedplayer, part = distance, nil, nil
	local localchar = phantomforces["GetCharacter"](lplr)
	local localroot = localchar and localchar:FindFirstChild("Torso")
    for i, v in pairs(players:GetChildren()) do
		local char = phantomforces["GetCharacter"](v)
		if char then
			local root = char and char:FindFirstChild("Head")
			if root then
				local active = true
				if active then
					if not isPlayerTargetable((player and v or nil), true, true) then
						active = false
					end
				end
				if active and wall then
					if not vischeck(localchar, char, root, 0) then
						active = false
					end
				end
				if active then
					local mag = (localroot.Position - root.Position).magnitude
					if mag <= closest then
						closest = mag
						returnedplayer = v
						part = root
					end
				end
			end
		end
    end
    return returnedplayer, part, closest
end

local function GetNearestHumanoidToPosition2(pos, distance, wall)
    local closest, returnedplayer, part = distance, nil, nil
	local localchar = phantomforces["GetCharacter"](lplr)
	local localroot = localchar and localchar:FindFirstChild("Torso")
    for i, v in pairs(players:GetChildren()) do
		local char = phantomforces["GetCharacter"](v)
		if char then
			local root = char and char:FindFirstChild("Head")
			if root then
				local active = true
				if active then
					if not isPlayerTargetable(v, true, true) then
						active = false
					end
				end
				if active and wall then
					if not vischeck(localchar, char, {Position = pos}, 0) then
						active = false
					end
				end
				if active then
					local mag = (pos - root.Position).magnitude
					if mag <= closest then
						closest = mag
						returnedplayer = v
						part = root
					end
				end
			end
		end
    end
    return returnedplayer, part, closest
end

local function GetNearestHumanoidToMouse(player, distance, wall)
    local closest, returnedplayer, part = distance, nil, nil
	local localchar = phantomforces["GetCharacter"](lplr)
	local localroot = localchar and localchar:FindFirstChild("Torso")
    for i, v in pairs(players:GetChildren()) do
		local char = phantomforces["GetCharacter"](v)
		if char then
			local root = char and char:FindFirstChild("Head")
			if root then
				local active = true
				if active then
					if not isPlayerTargetable((player and v or nil), true, true) then
						active = false
					end
				end
				if active and wall then
					if not vischeck(localchar, char, root, 0) then
						active = false
					end
				end
				if active then
					local vec, vis = cam:WorldToScreenPoint(root.Position)
					if vis then
						local mag = (uis:GetMouseLocation() - vec2(vec.X, vec.Y)).magnitude
						if mag <= closest then
							closest = mag
							returnedplayer = v
							part = root
						end
					end
				end
			end
		end
    end
    return returnedplayer, part, closest
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "send" then 
			return tab[i - 1]
		end
	end
	return nil
end

local function getremoteknife(tab)
	for i,v in pairs(tab) do
		if v == "tick" then 
			return tab[i - 1]
		end
	end
	return nil
end

local getfunctions
getfunctions = function()
	for i,v in pairs(getgc(true)) do
		if type(v) == "table" then
			if rawget(v, "setsprintdisable") then
				phantomforces["GameLogic"] = v
			end
			if rawget(v, "send") then
				phantomforces["Network"] = v
			end
			if rawget(v, "setmenucf") then
				phantomforces["Camera"] = v
			end
			if rawget(v, "name") and rawget(v, "task") and v.name == "camera" then
				phantomforces["CameraTask"] = v
			end
			if rawget(v, "isspotted") then
				phantomforces["Hud"] = v
				phantomforces["SpotRemote"] = getremote(debug.getconstants(v.spotstep))
			end
			if rawget(v, "getstate") then
				phantomforces["Character"] = v
				phantomforces["StateRemote"] = getremote(debug.getconstants(v.setmovementmode))
				v.humanoid = debug.getupvalue(v.getstate, 1)
			end
			if rawget(v, "PlaySound") then
				phantomforces["Sound"] = v
			end
			if rawget(v, "swapknife") then
				phantomforces["KnifeRemote"] = getremoteknife(debug.getconstants(debug.getprotos(debug.getupvalues(v.swapknife)[4])[9]))
			end
			if rawget(v, "onkeydown") then 
				for i2,v2 in pairs(v.onkeydown._funcs) do 
					phantomforces["KeyPressFunc"] = i2
					break
				end
			end
			if rawget(v, "getTime") then 
				phantomforces["GameClock"] = v
			end
			if rawget(v, "isdeployed") then
				phantomforces["Menu"] = v
			end
			if rawget(v, "raycastwhitelist") and type(v.raycastwhitelist) == "table" then
				phantomforces["Ray"] = v
			end
			if rawget(v, "newReader") then
				phantomforces["BitReader"] = v
			end
			if rawget(v, "breakwindow") then
				phantomforces["Effects"] = v
				if v["bullethit"] then
					phantomforces["Particles"] = debug.getupvalues(v["bullethit"])[4]
				end
			end
			if rawget(v, "getplayerhit") then
				phantomforces["Replication"] = v
				phantomforces["GetCharacter"] = function(plr)
					if plr == lplr then
						return phantomforces["Character"].rootpart and phantomforces["Character"].rootpart.Parent
					end
			
					for i,v in pairs(debug.getupvalue(v.getplayerhit, 1)) do
						if v == plr then
							return i
						end
					end
				end
				phantomforces["GetRoot"] = function(plr)
					if plr == nil then return end
	
					local char
					if plr:IsA("Player") then
						char = phantomforces["GetCharacter"](plr)
					else
						char = plr
					end
	
					if char then
						return (char:FindFirstChild("Torso") or char.PrimaryPart)
					end
	
					return
				end
			end
		end
	end
	if phantomforces["GameLogic"] == nil then
		phantomforces = {}
		wait(1)
		getfunctions()
	else
		print("loaded")
	end
end
getfunctions()
teleportfunc = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
		if shared.vapekickedfrom then
			queueteleport('shared.vapekickedfrom = "'..shared.vapekickedfrom..'"')
		end
	end
end)
local injectiontime = tick()
local AimAssist = {["Enabled"] = false}
local AimAssistMode = {["Value"] = "Legit"}
local AimAssistFOV = {["Value"] = 90}
local AimAssistFOVShow = {["Enabled"] = false}
local aimfovframecolor = {["Value"] = 0.44}
local AimAssistSwitchDelay = {["GetRandomValue"] = function() return 10 end}
local AimAssistAutoFire = {["Enabled"] = false}
local AimAssistGunStats = {["Enabled"] = true}
local Reach = {["Enabled"] = false}
local ReachRange = {["Value"] = 18}
local ReachHeadshot = {["Value"] = 25}
local oldindex
local oldplr
local currenttargeted = nil
local currenttargetedtick = tick()
local oldpos
local oldrealpos
local switchdelay = 0
local shooting = 0
local shootinglerp = 0
local shootpos = vec3(0, 0, 0)
local aimfovframe
oldindex = hookmetamethod(game, "__index", function(self, index, ...)
	if checkcaller() then
		return oldindex(self, index, ...)
	end

	if index == "CFrame" then -- its a meh..
		if shooting <= tick() and oldplr then
			oldplr = nil
		end
		if Reach["Enabled"] then
			local knife = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.knife
			if knife then
				if tostring(self) == "Tip" then
					return CFrame.new(self.Position + (cam.CFrame.lookVector * ReachRange["Value"]))
				end
			end
		end
		if AimAssist["Enabled"] then
			local barrel = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.barrel
			local sight = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.aimsightdata and phantomforces["GameLogic"].currentgun.aimsightdata[1] and phantomforces["GameLogic"].currentgun.aimsightdata[1].sightpart
			if barrel and (self == barrel or self == sight) then
				local Dir = oldindex(self, index, ...)
				Dir = Dir.LookVector * 1000
				local OldDir = Dir
				local plr, Head, dist = nil, nil, nil
				if AimAssistMode["Value"] == "Legit" then plr, Head, dist = GetNearestHumanoidToMouse(true, AimAssistFOV["Value"], true) else plr, Head, dist = GetNearestHumanoidToPosition(true, AimAssistFOV["Value"], true) end
				local hipfire = math.floor((1 - (phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.data and phantomforces["GameLogic"].currentgun.data.hipfirestability or 0.75)) * 100)
				if Head then
					local randomval = AimAssistSwitchDelay["GetRandomValue"]()
					local allowed = true
					local realmag = (barrel.Position - Head.Position).magnitude / 150
					local bulletspeed = phantomforces["GameLogic"].currentgun.data and phantomforces["GameLogic"].currentgun.data.bulletspeed or dist * 10
					--dist = (bulletspeed ^ 2 * dist + 196.2 * dist) / bulletspeed ^ 2
					local t = (bulletspeed * dist + 196.2 * dist) / bulletspeed ^ 2
					local newshootpos = vec3(
						Head.Position.X,
						Head.Position.Y + (((196.2 ^ t) / 2) - (t * 2)),
						Head.Position.Z
					)

					Dir = CFrame.lookAt(barrel.Position, newshootpos).LookVector * 1000
					currenttargeted = plr
					currenttargetedtick = tick() + 1.5
					if AimAssistMode["Value"] == "Legit" then 
						if plr ~= oldplr then
							if shooting >= tick() then
								print("switching from", oldplr, "to", plr)
								if oldplr ~= nil then 
									switchdelay = tick() + 1
									oldpos = shootpos
								end
								oldplr = plr
							end
						else
							oldrealpos = CFrame.lookAt(barrel.Position, Head.Position).LookVector * 1000
						end
						if shooting <= tick() then
							shootinglerp = tick() + 1
						end
						if shootinglerp >= tick() and (math.clamp((shootinglerp - tick()) * (100 / (randomval * 1.2)), 0, 1)) < 1 then
							local shootlerp = Dir:Lerp(OldDir, (math.clamp((shootinglerp - tick()) * (100 / (randomval * 1.2)), 0, 1)))
							print("shooting to", (OldDir - Dir).magnitude)
							if (OldDir - Dir).magnitude <= 30 then
								shootinglerp = tick()
							end
							Dir = shootlerp
							allowed = false
						else
							if switchdelay >= tick() and (math.clamp((switchdelay - tick()) * (100 / randomval), 0, 1)) < 1 then
								if typeof(oldpos) == "Vector3" then
									print(switchdelay - tick())
									if (Dir - OldDir).magnitude <= 30 then
										switchdelay = tick()
									end
									Dir = Dir:Lerp(oldpos, (math.clamp((switchdelay - tick()) * (100 / randomval), 0, 1)))
									allowed = false
								end
							end
						end

						shooting = tick() + 1
						shootpos = Dir

						local snipercheck = (phantomforces["GameLogic"].currentgun and (phantomforces["GameLogic"].currentgun.type ~= "SNIPER" or (not phantomforces["GameLogic"].currentgun.isaiming())))
						if AimAssistGunStats["Enabled"] and snipercheck then
							newshootpos = newshootpos + (vec3(
								math.random(-hipfire,hipfire) / 10,
								0,
								math.random(-hipfire,hipfire) / 10
							) * math.clamp(realmag, 1, 10))
						else
							newshootpos = newshootpos + (vec3(
								math.random(-2, 2) / 10,
								0,
								math.random(-2, 2) / 10
							) * math.clamp(realmag, 1, 10))
						end
					end

					if allowed or AimAssistMode["Value"] == "Blatant" then
						newshootpos = newshootpos + (Head.Parent.Torso.Velocity * (t * 2.1))
						Dir = CFrame.lookAt(barrel.Position, newshootpos).LookVector * 1000
					end

					return CFrame.new(barrel.Position, barrel.Position + Dir)
				else
					if shooting >= tick() then
						shootpos = OldDir:lerp(shootpos, (shooting - tick()))
						return CFrame.new(barrel.Position, barrel.Position + OldDir:lerp(shootpos, (shooting - tick())))
					end
				end
			end
		end
	end

	return oldindex(self, index, ...)
end)

--stolen from 2015 leak lol
local function toanglesyx(v)
	local x,y,z=v.x,v.y,v.z
	return math.asin(y/(x*x+y*y+z*z)^0.5),math.atan2(-x,-z)
end
local pi = math.pi
local tau = 2*pi

local AimAssistHeadshotChance = {["Value"] = 25}
local SilentGrenade = {["Enabled"] = false}
local SilentGrenadeMode = {["Value"] = "Impact"}
local oldsend = phantomforces["Network"].send
local oldupdatechar = phantomforces["Character"].updatecharacter
local oldbreak  = phantomforces["Effects"].breakwindow
local oldbullet = phantomforces["Particles"].new
local oldhitmarker = phantomforces["Hud"].firehitmarker
local oldsound = phantomforces["Sound"].PlaySound
local seeable = {}
local actuallyseeable = {}
print("done1")
runcode(function()
	local GunTracers = {["Enabled"] = false}
	local GunTracersColor = {["Hue"] = 0.44, ["Sat"] = 1, ["Value"] = 1}
	local GunTracersDelay = {["Value"] = 10}
	local GunTracersFade = {["Enabled"] = false}
	setreadonly(phantomforces["Particles"], false)
	phantomforces["Particles"].new = function(tab)
		if tab.thirdperson and tab.penetrationdepth then
			local mag = (tab.position - phantomforces["Camera"].cframe.p).magnitude
			if mag <= 60 then
				local playersnear = GetAllNearestHumanoidToPosition(tab.position, 5)
				for i,v in pairs(playersnear) do
					if v.Team ~= lplr.Team then
						seeable[v.Name] = tick() + 1.5
					end
				end
			end
		end
		if GunTracers["Enabled"] then
			if (not tab.thirdperson) and tab.penetrationdepth then
				local origin = tab.position
				local position = (origin + (tab.velocity.unit * 100))
				local distance = (origin - position).Magnitude
				local p = Instance.new("Part")
				p.Anchored = true
				p.CanCollide = false
				p.Transparency = 0.5
				p.Color = Color3.fromHSV(GunTracersColor["Hue"], GunTracersColor["Sat"], GunTracersColor["Value"])
				p.Parent = workspace.Ignore
				p.Material = Enum.Material.Neon
				p.Size = vec3(0.01, 0.01, distance)
				p.CFrame = CFrame.lookAt(origin, position)*CFrame.new(0, 0, -distance/2)
				game:GetService("Debris"):AddItem(p, GunTracersDelay["Value"] / 10)
			end
		end
		return oldbullet(tab)
	end
	setreadonly(phantomforces["Particles"], true)
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

local anglex = 0
local angley = 0
local AntiAim = {["Enabled"] = false}
local AntiAimStance = {["Value"] = "Stand"}
local NoFall = {["Enabled"] = false}
local realhit = "Torso"
local thirdpersonstuff = {}

local function thirdpersonfunc()
	debug.setupvalue(debug.getupvalue(phantomforces["Replication"].getupdater, 2), 1, "")
	thirdpersonstuff.updater = phantomforces["Replication"].getupdater(lplr)
	debug.setupvalue(debug.getupvalue(phantomforces["Replication"].getupdater, 2), 1, lplr)
	local localchar = phantomforces["GetCharacter"](lplr)
	local localroot = localchar and localchar:FindFirstChild("Torso")
	thirdpersonstuff.updater.spawn(localroot and localroot.Position or cam.CFrame.p)
	for i,v in pairs(debug.getupvalues(thirdpersonstuff.updater.step)) do
		if type(v) == "table" then
			if rawget(v, "update") and rawget(v, "accelerate") then
				for i2,v2 in pairs(v) do 
					--print(v._s, i2,v2)
				end
				if v._s == 32 then
					thirdpersonstuff.posspr = v
				elseif v._s == 12 then
					--thirdpersonstuff.angspr = v
				end
			end
			if rawget(v, "makesound") ~= nil then
				v.makesound = false
			end
		end
	end
	for i,v in pairs(debug.getupvalues(thirdpersonstuff.updater.spawn)) do
		if typeof(v) == "Instance" and v:IsA("Model") and v.Name == "Player" then
			thirdpersonstuff.model = v
			break
		end
	end
	if thirdpersonstuff.posspr then
		thirdpersonstuff.posspr.s = 100
	end
	local repindex
	for i,v in pairs(debug.getupvalues(thirdpersonstuff.updater.step)) do 
		if type(v) == "table" then 
			for i2,v2 in pairs(v) do 
				if tostring(i2):find("frameDataList") then 	
					repindex = v
					break
				end
			end
			if repindex then 
				break
			end
		end
	end
	BindToRenderStep("ThirdPerson", 1, function()
		if thirdpersonstuff.updater and thirdpersonstuff.plrang then
			--thirdpersonstuff.angspr.t = Vector2.new(thirdpersonstuff.plrang.x, thirdpersonstuff.plrang.y)
			thirdpersonstuff.updater.step(3, true)
			if repindex then
				repindex:receive(tick(), tick(), {
					t = tick(),
					position = thirdpersonstuff.pos or Vector3.new(0, 0, 0),
					velocity = thirdpersonstuff.plrvelo or Vector3.new(0, 0, 0),
					angles = thirdpersonstuff.plrang or Vector2.new(0, 0),
					breakcount = 4
				}, false)
			end
		end
	end)
end

phantomforces["Character"].updatecharacter = function(spawnPos)
	oldupdatechar(spawnPos)
	if ThirdPerson["Enabled"] then
		thirdpersonfunc()
	end
	--[[if ThirdPerson["Enabled"] then
		debug.setupvalue(debug.getupvalue(phantomforces["Replication"].getupdater, 2), 1, "")
		thirdpersonstuff.updater = phantomforces["Replication"].getupdater(lplr)
		debug.setupvalue(debug.getupvalue(phantomforces["Replication"].getupdater, 2), 1, lplr)
		thirdpersonstuff.updater.spawn(spawnPosition)
		for i,v in pairs(debug.getupvalues(thirdpersonstuff.updater.step)) do
			if type(v) == "table" then
				if rawget(v, "update") and rawget(v, "accelerate") then
					if v._s == 32 then
						thirdpersonstuff.posspr = v
					elseif v._s == 12 then
						print("set")
						thirdpersonstuff.angspr = v
					end
				end
				if rawget(v, "makesound") ~= nil then
					v.makesound = false
				end
			end
		end
		for i,v in pairs(debug.getupvalues(thirdpersonstuff.updater.spawn)) do
			if typeof(v) == "Instance" and v:IsA("Model") and v.Name == "Player" then
				thirdpersonstuff.model = v
				print("model")
				break
			end
		end
		if thirdpersonstuff.posspr and thirdpersonstuff.angspr then
			thirdpersonstuff.posspr.s = 100

		end
		BindToRenderStep("ThirdPerson", 1, function()
			if thirdpersonstuff.updater and thirdpersonstuff.plrang then
			--	thirdpersonstuff.angspr.t = Vector2.new(thirdpersonstuff.plrang.x, thirdpersonstuff.plrang.y)
				thirdpersonstuff.updater.step(3, true)
			end
		end)
	end]]
end
phantomforces["Network"].send = function(self, method, ...)
	if checkcaller() then return oldsend(self, method, ...) end
	if not method then return oldsend(self, method, ...) end
    local args = {...}
	local checkmethod = method
	checkmethod = checkmethod:gsub("%W", "")

	if checkmethod == "closeconnection" or checkmethod == "debug" then
		return
	end

	if NoFall["Enabled"] and checkmethod == "falldamage" then
		return
	end
	if SilentGrenade["Enabled"] then
		--[[if checkmethod == "newgrenade" then
			local oldpos = vec3(0, 9999, 0)
			local selected = #args[2].frames + 1
			for i,v in pairs(args[2].frames) do
				if i > selected then
					table.remove(args[2].frames, i)
				else
					if (vec3(0, oldpos.Y, 0) - vec3(0, v.p0.Y, 0)).magnitude <= 0.05 then
						oldpos = v.p0
						args[2].blowuptime = v.t0
						selected = i
					else
						oldpos = v.p0
					end
				end
			end
		end]]
		--[[if checkmethod == "newgrenade" then
			local plr = GetNearestHumanoidToMouse(true, 1000)
			if plr then
				local char = phantomforces["GetCharacter"](plr)
				if char then
					args[2].blowuptime = 0.2
					args[2].time = tick()

					local ok = char.Torso.Position - (cam.CFrame.lookVector * 2)
					local ok2 = phantomforces["GetCharacter"](lplr).Torso.Position
					args[2].frames = {
						{
							v0 = vec3(100, 0, 0),
							t0 = 0,
							glassbreaks = {},
							offset = vec3(0, 0, 0),
							rot0 = CFrame.Angles(math.rad(90), 0, 0),
							p0 = ok2,
							rotv = vec3(0, 0, 0)
						},
						{
							v0 = cam.CFrame.lookVector * 2,
							t0 = 0,
							glassbreaks = {},
							offset = vec3(0, 0, 0),
							rot0 = CFrame.Angles(math.rad(90), 0, 0),
							p0 = ok,
							rotv = vec3(0, 0, 0)
						},
					}
				end
			end
		end]]
		if checkmethod == "newgrenade" then 
			print(SilentGrenadeMode["Value"])
			if SilentGrenadeMode["Value"] == "Impact" then 
				for i,v in pairs(args[2].frames) do
					if type(phantomforces["Ray"].raycastwhitelist) == "table" then
						local ray = workspace:FindPartOnRayWithWhitelist(Ray.new(v.p0, Vector3.new(0, -1, 0)), phantomforces["Ray"].raycastwhitelist)
						if ray then
							args[2].blowuptime = v.t0
							break
						end
					end
				end
			elseif SilentGrenadeMode["Value"] == "Sticky" then 
				local newpos
				for i,v in pairs(args[2].frames) do
					print(i)
					if newpos == nil then
						if type(phantomforces["Ray"].raycastwhitelist) == "table" then
							local ray = workspace:FindPartOnRayWithWhitelist(Ray.new(v.p0, v.v0), phantomforces["Ray"].raycastwhitelist)
							if ray and i ~= #args[2].frames then
								newpos = args[2].frames[i + 1].p0
							end
						end
					else
						print("overwrite", i)
						v.p0 = newpos
						v.v0 = Vector3.new(0, 0, 0)
					end
				end
			elseif SilentGrenadeMode["Value"] == "PlayerTP" then 
				local plr = GetNearestHumanoidToMouse(true, 1000)
				if plr then
					local char = phantomforces["GetCharacter"](plr)
					if char then
						args[2].blowuptime = 0.2
						args[2].time = tick()

						local ok = char.Torso.Position - (cam.CFrame.lookVector * 2)
						local ok2 = phantomforces["GetCharacter"](lplr).Torso.Position
						args[2].frames = {
							{
								v0 = vec3(100, 0, 0),
								t0 = 0,
								glassbreaks = {},
								offset = vec3(0, 0, 0),
								rot0 = CFrame.Angles(math.rad(90), 0, 0),
								p0 = ok2,
								rotv = vec3(0, 0, 0)
							},
							{
								v0 = cam.CFrame.lookVector * 2,
								t0 = 0,
								glassbreaks = {},
								offset = vec3(0, 0, 0),
								rot0 = CFrame.Angles(math.rad(90), 0, 0),
								p0 = ok,
								rotv = vec3(0, 0, 0)
							},
						}
					end
				end
			elseif SilentGrenadeMode["Value"] == "PlayerLerp" then 
				local frames = {}
				local ok
				for i,v in pairs(args[2].frames) do
					table.insert(frames, v)
					if ok then
						v.p0 = v.p0 - ((v.p0 - ok) / 4)
						v.v0 = v.v0 / 4
					else
						local plr, head = GetNearestHumanoidToPosition2(v.p0, 50)
						if plr then 
							v.v0 = v.v0.Unit * (v.p0 - head.Position).magnitude
							ok = v.p0 + v.v0.Unit * (v.p0 - head.Position).magnitude
						end
					end
				end
				args[2].frames = frames
			end
		end
	end

--	if checkmethod == "newbullets" then
	--	print("newbullets", args[1]["firepos"], args[1]["bullets"][1][1])
	--	local origin = args[1]["firepos"]
	--	local bullet = args[1]["bullets"][#args[1]["bullets"]][1]
	--	local position = origin + (bullet.unit * 1000)--(origin + args[1]["bullets"][1][1])
	--	local distance = (origin - position).Magnitude
	--	local p = Instance.new("Part")
	--	p.Anchored = true
	--	p.CanCollide = false
	--	p.Transparency = 0.5
	--	p.Color = col3(1, 0, 0)
	--	p.Parent = workspace.Ignore
	--	p.Size = vec3(0.1, 0.1, distance)
	--	p.CFrame = CFrame.lookAt(origin, position)*CFrame.new(0, 0, -distance/2)
	--	game:GetService("Debris"):AddItem(p, 1)
	--end

	if AimAssist["Enabled"] then
		if checkmethod == "repupdate" then
			if shooting >= tick() then
				local x, ay = toanglesyx(CFrame.new(cam.CFrame.p, shootpos).lookVector)
				local cy=phantomforces["Camera"].angles.y
				x=x>phantomforces["Camera"].maxangle and phantomforces["Camera"].maxangle
					or x<phantomforces["Camera"].minangle and phantomforces["Camera"].minangle
					or x
				local y=(ay+pi-cy)%tau-pi+cy
				args[2] = vec2(x, y)
			end
		end
		if checkmethod == "bullethit" then -- headshot %
			if args[3] and typeof(args[3]) == 'string' then
				local ran = math.random(1,100)
				if ran <= AimAssistHeadshotChance["Value"] then
					args[3] = "Head"
					realhit = "Head"
				else
					args[3] = "Torso"
					realhit = "Torso"
				end
			end
		end
	end
	if Reach["Enabled"] then
		if method:find("window") then
			local hit, pos, normal, material = workspace:FindPartOnRayWithIgnoreList(Ray.new(cam.CFrame.p, cam.CFrame.lookVector * 8), {})
			if not hit then
				return
			end
		end
		if checkmethod == "knifehit" then -- headshot %
			if args[3] and typeof(args[3]) == "Instance" then

				local ran = math.random(1,100)

				if ran <= ReachHeadshot["Value"] then
					args[3] = args[3].Parent:FindFirstChild("Head") or args[3]
					realhit = "Head"
				else
					args[3] = args[3].Parent:FindFirstChild("Torso") or args[3]
					realhit = "Torso"
				end
			end
		end
	end
	if AntiAim["Enabled"] then
		if checkmethod == "repupdate" then
			args[2] = vec2(math.rad(angley), math.rad(anglex))
		elseif checkmethod == "stance" then
			args[2] = AntiAimStance["Value"]:lower()
		end
	end
	if thirdpersonstuff.updater then
		if checkmethod == "repupdate" then
			--print(args[1])
			thirdpersonstuff.plrang = args[2]
			local velo = (args[1] - (thirdpersonstuff.pos or args[1]))/(args[3] - (thirdpersonstuff.ltick or args[3]))
			thirdpersonstuff.ltick = args[3]
			thirdpersonstuff.pos = args[1]
			thirdpersonstuff.plrang = args[2]
			thirdpersonstuff.plrvelo = velo == velo and velo or Vector3.new()
			thirdpersonstuff.updater.receivedFrameTime = args[3]
			thirdpersonstuff.updater.receivedVelocity = velo == velo and velo or Vector3.new()
			thirdpersonstuff.updater.receivedPosition = args[1]
			thirdpersonstuff.updater.receivedLookAngles = args[2]
			thirdpersonstuff.updater.lastPacketTime = tick()
		--[[	thirdpersonstuff.updater.breakcount = 0
			thirdpersonstuff.updater.lastbreakcount = 0
			thirdpersonstuff.updater.receivedVelocity = velo == velo and velo or Vector3.new()
			thirdpersonstuff.updater.receivedFrameTime = args[3]
            thirdpersonstuff.updater.receivedPosition = args[1]
            thirdpersonstuff.updater.receivedLookAngles = args[2]
			thirdpersonstuff.updater.lastPacketTime = tick()
            thirdpersonstuff.updater.receivedDataFlag = true]]
		end
		if checkmethod == "stance" or name == "sprint" or name == "aim" then
			thirdpersonstuff.updater["set"..checkmethod](args[1])
		end
		if checkmethod == "equip" then
			local gunstats = realreq(game:GetService("ReplicatedStorage").Content.ProductionContent.GunModules[phantomforces["GameLogic"].currentgun.name])
			local model = game:GetService("ReplicatedStorage").Content.ProductionContent.ExternalModels[phantomforces["GameLogic"].currentgun.name]
			thirdpersonstuff.updater[phantomforces["GameLogic"].currentgun.knife and "equipknife" or "equip"](gunstats, model)
		end
	end
	if checkmethod == "state" and args[1] == lplr then
		return
	end

	return oldsend(self, method, unpack(args))
end
phantomforces["Sound"].PlaySound = function(...)
	local args = {...}
	if args[1]:find("enemy") then
		local mag = (args[7].position - phantomforces["Camera"].cframe.p).magnitude
		if mag <= 30 then
			local playersnear = GetAllNearestHumanoidToPosition(args[7].Position, 5)
			for i,v in pairs(playersnear) do
				if v.Team ~= lplr.Team then
					seeable[v.Name] = tick() + 1.5
				end
			end
		end
	end
	return oldsound(unpack(args))
end

GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
GuiLibrary["RemoveObject"]("TriggerBotOptionsButton")
GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("BlinkOptionsButton")
GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("FlyOptionsButton")
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
GuiLibrary["RemoveObject"]("KillauraOptionsButton")
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
GuiLibrary["RemoveObject"]("HighJumpOptionsButton")
GuiLibrary["RemoveObject"]("PhaseOptionsButton")
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
GuiLibrary["RemoveObject"]("SpinBotOptionsButton")
GuiLibrary["RemoveObject"]("ESPOptionsButton")
GuiLibrary["RemoveObject"]("TracersOptionsButton")
GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
GuiLibrary["RemoveObject"]("GravityOptionsButton")
GuiLibrary["RemoveObject"]("SwimOptionsButton")
GuiLibrary["RemoveObject"]("XrayOptionsButton")
GuiLibrary["RemoveObject"]("FreecamOptionsButton")
GuiLibrary["RemoveObject"]("SafeWalkOptionsButton")
GuiLibrary["RemoveObject"]("ChatSpammerOptionsButton")
GuiLibrary["RemoveObject"]("SpiderOptionsButton")

runcode(function()
	local Killaura = {["Enabled"] = false}
	local KillauraRange = {["Value"] = 30}
	local KillauraKnifeOnly = {["Enabled"] = false}
	local KillauraMouseOnly = {["Enabled"] = false}
	local KillauraAngle = {["Value"] = 90}
	local killauratargetframe = {["Players"] = {["Enabled"] = false}}
	local KillauraHeadshotChance = {["Value"] = 100}
	Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Killaura", 
		["Function"] = function(callback) 
			if callback then
				spawn(function()
					repeat
						task.wait(0.1)
						if phantomforces["Character"] and phantomforces["Character"].alive then 
							local plr = GetNearestHumanoidToPosition(killauratargetframe["Players"]["Enabled"], KillauraRange["Value"], false)
							local gun = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun
							if phantomforces["KnifeRemote"] == nil then 
								if gun and gun.knife then
									phantomforces["KnifeRemote"] = getremoteknife(debug.getconstants(debug.getupvalues(gun.step)[8]))
								end
							end
							if plr and phantomforces["KnifeRemote"] then
								if KillauraKnifeOnly["Enabled"] then 
									if gun and (not gun.knife) then
										continue
									end
								end
								if KillauraMouseOnly["Enabled"] then
									if gun and gun.knife then 
										if not debug.getupvalue(gun.playanimation, 1) then continue end
									end
								end
								if killauratargetframe["Walls"]["Enabled"] then 
									if type(phantomforces["Ray"].raycastwhitelist) == "table" then
										local char = phantomforces["GetCharacter"](plr)
										if char then
											local ray = workspace:FindPartOnRayWithWhitelist(Ray.new(phantomforces["Camera"].cframe.p, CFrame.lookAt(phantomforces["Camera"].cframe.p, char.Head.Position).lookVector * KillauraRange["Value"]), {table.unpack(phantomforces["Ray"].raycastwhitelist), char})
											if not (ray and ray:IsDescendantOf(char)) then 
												continue
											end
										end
									end
								end
								phantomforces["Network"]:send(phantomforces["KnifeRemote"], plr, tick(), math.random(1,100) <= KillauraHeadshotChance["Value"] and "Head" or "Torso")
							end
						end
					until (not Killaura["Enabled"])
				end)
			end
		end,
	})
	killauratargetframe = Killaura.CreateTargetWindow({})
	KillauraRange = Killaura.CreateSlider({
		["Name"] = "Attack range",
		["Min"] = 1,
		["Max"] = 30,
		["Default"] = 30,
		["Function"] = function() end
	})
	KillauraHeadshotChance = Killaura.CreateSlider({
		["Name"] = "Headshot Chance",
		["Min"] = 1,
		["Max"] = 100,
		["Default"] = 45,
		["Function"] = function() end
	})
	KillauraKnifeOnly = Killaura.CreateToggle({
		["Name"] = "Limit to knife",
		["Function"] = function() end,
	})
	KillauraMouseOnly = Killaura.CreateToggle({
        ["Name"] = "Attacking only",
        ["Function"] = function() end,
		["HoverText"] = "Only attacks when knife is being swung.",
    })
end)

local AutoRespawn = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "AutoRespawn", 
	["Function"] = function(callback) end,
})
local AutoRespawnDelay = AutoRespawn.CreateSlider({
	["Name"] = "Delay",
	["Min"] = 1,
	["Max"] = 10,
	["Default"] = 1,
	["Function"] = function() end
})

runcode(function()
	local AntiAimXAxis = {["Value"] = "Clockwise"}
	local AntiAimYAxis = {["Value"] = "Default"}
	local upanddown = false
	AntiAim = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AntiAim", 
		["Function"] = function(callback) 
			if callback then
				if AntiAimYAxis["Value"] == "Circle" then
					local val = (upanddown and 20 or -20)
					if (angley + val) > 360 or (angley + val) < -360 then
						upanddown = not upanddown
					end
				end
				angley = AntiAimYAxis["Value"] == "Up" and 80 or AntiAimYAxis["Value"] == "Middle" and 1 or AntiAimYAxis["Value"] == "Down" and -80 or (upanddown and 20 or -20)
				phantomforces["Network"]:send(phantomforces["StateRemote"], AntiAimStance["Value"]:lower())
				spawn(function()
					repeat
						task.wait(0.001)
						anglex = AntiAimXAxis["Value"] == "Clockwise" and (anglex + 45) or (anglex - 45)
						if anglex > 360 or anglex < -360 then
							anglex = 1
						end
					until (not AntiAim["Enabled"])
				end)
			else
				anglex = 1
				angley = 1
			end
		end,
	})
	AntiAimStance = AntiAim.CreateDropdown({
		["Name"] = "Stance",
		["List"] = {"Stand", "Crouch", "Prone"},
		["Function"] = function() end
	})
	AntiAimXAxis = AntiAim.CreateDropdown({
		["Name"] = "X Axis",
		["List"] = {"Clockwise", "Counter Clockwise"},
		["Function"] = function() end
	})
	AntiAimYAxis = AntiAim.CreateDropdown({
		["Name"] = "Y Axis",
		["List"] = {"Up", "Middle", "Down", "Circle"},
		["Function"] = function(val) 
			if AntiAim["Enabled"] then
				angley = val and 80 or val and 1 or -80
				anglex = 0
			end
		end
	})
end)

local ondied = phantomforces["Character"].ondied:connect(function(realdeath)
	if ThirdPerson["Enabled"] then
		pcall(function() thirdpersonstuff.updater.died() thirdpersonstuff.model:Remove() end)
		pcall(function() UnbindFromRenderStep("ThirdPerson") end)
		table.clear(thirdpersonstuff)
	end
	if not realdeath then
		task.wait(5)
	end
	task.wait(AutoRespawnDelay["Value"] / 10)
	if AutoRespawn["Enabled"] and phantomforces["Character"] then
		repeat
			if phantomforces["Menu"] then
				phantomforces["Menu"]:deploy()
			end
			task.wait(0.1)
		until phantomforces["Character"] and phantomforces["Character"].alive
	end
end)

local oldgrenade = phantomforces["Character"].loadgrenade
local oldscope = phantomforces["Hud"].updatescope
phantomforces["Hud"].firehitmarker = function(old)
	if AimAssist["Enabled"] then
		old = realhit == "Head"
	end
	if Reach["Enabled"] and phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.knife then
		old = realhit == "Head"
	end
	return oldhitmarker(old)
end
phantomforces["Hud"].updatescope = function(pos1, pos2, size1, size2)
	if shooting >= tick() then
		pos1 = UDim2.new(0, 960, 0, 540)
		pos2 = UDim2.new(0, 960, 4.439627332431e-09, 540)
		size1 = UDim2.new(1.12, 0, 1.12, 0)
		size2 = UDim2.new(0.9, 0, 0.9, 0)
	end
	return oldscope(pos1, pos2, size1, size2)
end
--[[phantomforces["Character"].loadgrenade = function(self, ...)
	if checkcaller() then return oldgrenade(self, ...) end
	local args = {...}
	local res = oldgrenade(self, unpack(args))
	local old = res.step
	local old2 = res.throw
	local removepart = false
	local grenadedata = debug.getupvalues(res.setequipped)[5]	
	local parttable = {}
	for v81675 = 1, 5 / 0.016666666666666666 + 1 do
	--	if v81675 % 3 == 0 then
			local part = Instance.new("Part")
			part.Size = vec3(0.3, 0.3, 0.3)
			part.Parent = workspace.Ignore
			part.TopSurface = Enum.SurfaceType.Smooth
			part.Material = Enum.Material.Neon
			part.BottomSurface = Enum.SurfaceType.Smooth
			part.Shape = Enum.PartType.Ball
			part.Position = vec3(88888, 888888, 888888)
			part.Color = col3(1, 1, 1)
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			local attachment = Instance.new("Attachment")
			attachment.Parent = part
			local beam = Instance.new("Beam")
			beam.Attachment1 = attachment
			beam.FaceCamera = true
			beam.Width0 = 0.2
			beam.Width1 = 0.2
			beam.Parent = part
			parttable[v81675] = part
		--end
	end
	local oldcooking = false
	local cookingtimer = tick()
	local newcookingtimer = 0
	res.step = function(...)
		if oldcooking ~= res.cooking then
			cookingtimer = tick() + 3.9
			oldcooking = res.cooking
		else
			newcookingtimer = cookingtimer - tick()
			--print(newcookingtimer)
		end
		if res.cooking then
			local model = debug.getupvalues(old2)[12]
			local raycastwhitelist = debug.getupvalues(old2)[1].raycastwhitelist
		--	part.Position = debug.getupvalues(model)[2].Position
			local u162 = phantomforces["Character"].alive and (phantomforces["Camera"].cframe * CFrame.Angles(math.rad(grenadedata.throwangle and 0), 0, 0)).lookVector * grenadedata.throwspeed + phantomforces["Character"].rootpart.Velocity or vec3(math.random(-3, 5), math.random(0, 2), math.random(-3, 5));
			local u164 = phantomforces["Character"].deadcf and phantomforces["Character"].deadcf.p or debug.getupvalues(model)[2].CFrame.p;
			local l__p__807 = phantomforces["Camera"].basecframe.p;
			local v808, v809, v810 = workspace:FindPartOnRayWithWhitelist(Ray.new(l__p__807, u164 - l__p__807), raycastwhitelist);
			local u164 = v809 + 0.01 * v810;
			local u173 = 0;
			local u165 = v806;
			local u170 = vec3(0, -80, 0);
			local u171 = vec3();
			local u157 = vec3().Dot
			local u166 = (phantomforces["Camera"].cframe - phantomforces["Camera"].cframe.p) * vec3(19.539, -5, 0);
			local u167 = debug.getupvalues(model)[2].CFrame - debug.getupvalues(model)[2].CFrame.p;
			local l__CFrame__811 = debug.getupvalues(model)[2].CFrame;
			local u168 = {
				time = v806, 
				blowuptime = 3, 
				frames = { {
						t0 = 0, 
						p0 = u164, 
						v0 = u162, 
						offset = u91, 
						rot0 = l__CFrame__811 - l__CFrame__811.p, 
						rotv = u166, 
						glassbreaks = {}
					} }
			};
			for v812 = 1, 5 / 0.016666666666666666 + 1 do
				local v813 = u164 + 0.016666666666666666 * u162 + 0.0001388888888888889 * u170;
				local v814, v815, v816 = workspace:FindPartOnRayWithWhitelist(Ray.new(u164, v813 - u164 - 0.05 * u171), raycastwhitelist);
				local v817 = 0.016666666666666666 * v812;
				if v814 and v814.Name ~= "Window" and v814.Name ~= "Col" then
					u167 = debug.getupvalues(model)[2].CFrame - debug.getupvalues(model)[2].CFrame.p;
					u171 = 0.2 * v816;
					u166 = v816:Cross(u162) / 0.2;
					local v818 = v815 - u164;
					local v819 = 1 - 0.001 / v818.magnitude;
					if v819 < 0 then
						local v820 = 0;
					else
						v820 = v819;
					end;
					u164 = u164 + v820 * v818 + 0.05 * v816;
					local v821 = u157(v816, u162) * v816;
					local v822 = u162 - v821;
					local v823 = -u157(v816, u170);
					local v824 = -1.2 * u157(v816, u162);
					if v823 < 0 then
						local v825 = 0;
					else
						v825 = v823;
					end;
					if v824 < 0 then
						local v826 = 0;
					else
						v826 = v824;
					end;
					local v827 = 1 - 0.08 * (10 * v825 * 0.016666666666666666 + v826) / v822.magnitude;
					local v828 = 0;
					if v827 < 0 then
						v828 = 0;
					else
						v828 = v827;
					end;
					u162 = v828 * v822 - 0.2 * v821;
					if u162.magnitude < 1 then
						local l__frames__829 = u168.frames;
						l__frames__829[#l__frames__829 + 1] = {
							t0 = v817 - 0.016666666666666666 * (v813 - v815).magnitude / (v813 - u164).magnitude, 
							p0 = u164, 
							v0 = u91, 
							b = true, 
							rot0 = 0, 
							offset = 0.2 * v816, 
							rotv = u91, 
							glassbreaks = {}
						};
						break;
					end;
					local l__frames__830 = u168.frames;
					l__frames__830[#l__frames__830 + 1] = {
						t0 = v817 - 0.016666666666666666 * (v813 - v815).magnitude / (v813 - u164).magnitude, 
						p0 = u164, 
						v0 = u162, 
						b = u172, 
						rot0 = 0, 
						offset = 0.2 * v816, 
						rotv = u166, 
						glassbreaks = {}
					};
					u172 = true;
				else
					u164 = v813;
					u162 = u162 + 0.016666666666666666 * u170;
					u172 = false;
					if v814 and v814.Name == "Window" and u173 < 5 then
						u173 = u173 + 1;
						local l__frames__831 = u168.frames;
						local l__glassbreaks__832 = l__frames__831[#l__frames__831].glassbreaks;
						l__glassbreaks__832[#l__glassbreaks__832 + 1] = {
							t = v817, 
							part = v814
						};
					end;
				end;
			end;
			local old
			for i2, v2 in pairs(parttable) do
				if u168.frames[i2] then
					--if i2 ~= (#u168.frames - 1) then
						v2.Attachment.Position = vec3(0, 0, 0)
						v2.Position = u168.frames[i2].p0
						v2.Beam.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromHSV(0, math.floor(1 - math.clamp((u168.frames[i2].t0 - newcookingtimer) - 0.2, 0, 1)), 1)),
							ColorSequenceKeypoint.new(1, Color3.fromHSV(0, math.floor(1 - math.clamp((u168.frames[i2].t0 - newcookingtimer) - 0.2, 0, 1)), 1))
						})
						if old and v2.Position ~= vec3(9999, 9999, 9999) and old.WorldPosition ~= vec3(9999, 9999, 9999) then
							v2.Beam.Attachment0 = old
						end
						if v2.Position ~= vec3(9999, 9999, 9999) then
							old = v2.Attachment
						end
					--end
				else
					v2.Position = vec3(9999, 9999, 9999)
					v2.Attachment.Position = vec3(-9999, -9999, -9999)
				end
			end
		else
			if removepart then
				for i, v in pairs(parttable) do
					v:Remove()
				end
			end
			if removepart and part then
				for i, v in pairs(parttable) do
					v:Remove()
				end
			end
		end
		return old(...)
	end
	res.throw = function(...)
		if parttable then
			removepart = true
			for i, v in pairs(parttable) do
				--v:Remove()
			end
		end
		return old2(...)
	end
	return res
end]]

local function findjobid(jobid, compare)
	if compare then
		for i,v in pairs(compare:split("/")) do
			print(i, v)
			if v == jobid then
				return false
			end
		end
		return true
	else
		return true
	end
end

local AutoVotekick = {["Enabled"] = false}
local AutoVotekickAnswer = {["Value"] = "Yes"}
local AutoRejoin = {["Enabled"] = false}
local onreport
local onrejoin
local votekicked = 0
spawn(function()
	local title = lplr.PlayerGui.ChatGame:WaitForChild("Votekick"):WaitForChild("Title")
	onreport = title.Parent:GetPropertyChangedSignal("Visible"):connect(function()
		if title.Parent.Visible then
			task.wait(1)
			local str = title.Text:sub(10, title.Text:len() - 19)
			if str == lplr.Name then
				votekicked = votekicked + 1
				if AutoVotekick["Enabled"] then
					phantomforces["Hud"]:vote("no")
				end
			else
				if AutoVotekick["Enabled"] then
					phantomforces["Hud"]:vote(AutoVotekickAnswer["Value"]:lower())
				end
			end
		end
	end)
	local overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
	onrejoin = overlay.DescendantAdded:Connect(function(obj)
		if obj.Name == "ErrorMessage" then
			obj:GetPropertyChangedSignal("Text"):Connect(function()
				if obj.Text:find("votekicked") and AutoRejoin["Enabled"] then
					shared.vapekickedfrom = shared.vapekickedfrom and shared.vapekickedfrom..game.JobId..'/' or game.JobId..'/'
					local PlaceId = game.PlaceId
					local URL = requestfunc({
						Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100",
						Method = "GET"
					}).Body
					local MaxPlayers = tonumber(game.Players.MaxPlayers)
					local List = {}
					function tablelength(T)
						local count = 0
						for _ in pairs(T) do count = count + 1 end
						return count
					end
					local Query = game:GetService("HttpService"):JSONDecode(URL)
					print(Query.data)
					for i=1,tonumber(tablelength(Query.data)) do
						List[Query.data[i].id] = {
							PlayerCount = tonumber(Query.data[i].playing),
							IsSlow = tonumber(Query.data[i].ping)
						}
					end
					local ChosenServer = game.JobId
					for i,v in pairs(List) do
						if i ~= game.JobId then
							local MaxCheck = (v.PlayerCount <= MaxPlayers)
							local SlowCheck = (v.IsSlow < 500)
							local GoodPlayers = (v.PlayerCount >= (MaxPlayers - 10 ))
							
							if MaxCheck and SlowCheck and GoodPlayers and findjobid(i, shared.vapekickedfrom) then
								ChosenServer = i
								break
							end
						end
					end
					spawn(function()
						repeat 
							task.wait(1)
							game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, ChosenServer, game.Players.LocalPlayer)
						until true == false
					end)
				end
			end)
		end
	end)
end)
print("done2")
runcode(function()
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
	local TriggerBot = {["Enabled"] = false}
	local TriggerHoverTime = {["Value"] = 20}
	local TriggerAfterTime = {["Value"] = 20}
	local TriggerAimOnly = {["Enabled"] = false}
	local TriggerRandom = {["Enabled"] = false}
	local wasshooting = false
	local shoottick = tick()
	local hovertick = tick()
	local hoverplr
	TriggerBot = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "TriggerBot",
		["Function"] = function(callback)
			if callback then
				BindToRenderStep("TriggerBot", 1, function()
					for i,plr in pairs(players:GetChildren()) do
						if lplr ~= plr and shared.vapeteamcheck(plr) and type(phantomforces["Ray"].raycastwhitelist) == "table" then 
							local char = phantomforces["GetCharacter"](plr)
							if char then
								local ray = workspace:FindPartOnRayWithWhitelist(Ray.new(phantomforces["Camera"].cframe.p, phantomforces["Camera"].cframe.LookVector * 3000), {table.unpack(phantomforces["Ray"].raycastwhitelist), char})
								local gun = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun
								if gun and gun.shoot and (not gun.knife) then
									if ray and ray:IsDescendantOf(char) then 
										if TriggerAimOnly["Enabled"] and (not gun.isaiming()) then 
											continue
										end
										if hovertick <= tick() then 
											if hoverplr ~= char then
												hovertick = tick() + (TriggerHoverTime["Value"] / 10)
											else
												gun:shoot(true)
												wasshooting = true
												shoottick = tick() + ((TriggerAfterTime["Value"] / 10) + (TriggerRandom["Enabled"] and (math.random(5, 15) / 100) or 0))
											end
										end
										hoverplr = char
										break
									else
										if wasshooting then
											hoverplr = nil
											if shoottick <= tick() then 
												gun:shoot(false)
												wasshooting = false
											else
												gun:shoot(true)
											end
										end
									end
								end
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("TriggerBot")
			end
		end,
		["HoverText"] = "Automatic shooting when hovering over target"
	})
	TriggerHoverTime = TriggerBot.CreateSlider({
		["Name"] = "Hover Time",
		["Function"] = function() end,
		["Min"] = 1,
		["Max"] = 50,
		["Default"] = 5,
		["HoverText"] = "time in ms hovering target before shoot"
	})
	TriggerAfterTime = TriggerBot.CreateSlider({
		["Name"] = "Stop Time",
		["Function"] = function() end,
		["Min"] = 1,
		["Max"] = 50,
		["Default"] = 5,
		["HoverText"] = "time in ms after not hovering over target"
	})
	TriggerAimOnly = TriggerBot.CreateToggle({
		["Name"] = "Aim Only",
		["Function"] = function() end,
		["Default"] = true,
		["HoverText"] = "shoots only when gun is being aimed"
	})
	TriggerRandom = TriggerBot.CreateToggle({
		["Name"] = "Random Delay",
		["Function"] = function() end,
		["Default"] = true,
		["HoverText"] = "adds a random delay to stop time"
	})
end)

BindToRenderStep("LegitRender", 500, function()
	local allowed = GuiLibrary["ObjectsThatCanBeSaved"]["ESPOptionsButton"]["Api"]["Enabled"] or GuiLibrary["ObjectsThatCanBeSaved"]["NameTagsOptionsButton"]["Api"]["Enabled"] or GuiLibrary["ObjectsThatCanBeSaved"]["TracersOptionsButton"]["Api"]["Enabled"]
	if not allowed then return end
	for i,plr in pairs(players:GetChildren()) do
		if lplr ~= plr and shared.vapeteamcheck(plr) then 
			actuallyseeable[plr.Name] = false
			if seeable[plr.Name] and seeable[plr.Name] >= tick() then
				actuallyseeable[plr.Name] = true
			else
				actuallyseeable[plr.Name] = phantomforces["Hud"]:isspotted(plr)
				if (not actuallyseeable[plr.Name]) and type(phantomforces["Ray"].raycastwhitelist) == "table" then
					local char = phantomforces["GetCharacter"](plr)
					if char then
						local ray = workspace:FindPartOnRayWithWhitelist(Ray.new(phantomforces["Camera"].cframe.p, CFrame.lookAt(phantomforces["Camera"].cframe.p, char.Head.Position + vec3(0, 0.5, 0)).LookVector * 1000), {table.unpack(phantomforces["Ray"].raycastwhitelist), char})
						if ray and ray.Parent == char then
							actuallyseeable[plr.Name] = true
						end
					end
				end
			end
		end
	end
end)

GuiLibrary["SelfDestructEvent"].Event:connect(function()
	print("uninject")
	UnbindFromRenderStep("LegitRender")
	phantomforces["Network"].send = oldsend
	phantomforces["Character"].updatecharacter = oldupdatechar
--	phantomforces["Connections"].bulkplayerupdate = oldserverrepupdate
	phantomforces["Character"].loadgrenade = oldgrenade
	phantomforces["Effects"].breakwindow = oldbreak
	phantomforces["Hud"].updatescope = oldscope
	phantomforces["Hud"].firehitmarker = oldhitmarker
	phantomforces["Sound"].PlaySound = oldsound
	setreadonly(phantomforces["Particles"], false)
	phantomforces["Particles"].new = oldbullet
	setreadonly(phantomforces["Particles"], true)
	if ondied then
		ondied:Disconnect()
	end
	if teleportfunc then
		teleportfunc:Disconnect()
	end
	if onrejoin then
		onrejoin:Disconnect()
	end
	if onreport then
		onreport:Disconnect()
	end
	for i,v in pairs(phantomforces) do
		phantomforces[i] = nil
	end
	phantomforces = {}
end)

AimAssist = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "SilentAim", 
	["Function"] = function(callback) 
		if callback then
			if aimfovframe then
				aimfovframe.Visible = AimAssistMode["Value"] ~= "Blatant"
			end
			spawn(function()
				repeat
					task.wait(0.1)
					local targettable = {}
					local targetsize = 0
					if currenttargetedtick <= tick() and currenttargeted then
						currenttargeted = nil
					end
					if currenttargeted then
						targettable[currenttargeted.Name] = {
							["UserId"] = currenttargeted.UserId,
							["Health"] = phantomforces["Hud"]:getplayerhealth(currenttargeted),
							["MaxHealth"] = 100
						}
						targetsize = targetsize + 1
					end
					pcall(function()
						targetinfo.UpdateInfo(targettable, targetsize)
					end)
				until AimAssist["Enabled"] == false
			end)
		end
	end,
})
AimAssistMode = AimAssist.CreateDropdown({
	["Name"] = "Mode",
	["List"] = {"Legit", "Blatant"},
	["Function"] = function() end
})
aimfovframecolor = AimAssist.CreateColorSlider({
	["Name"] = "Circle Color",
	["Function"] = function(hue, sat, val)
		if aimfovframe then
			aimfovframe.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
		end
	end
})
AimAssistFOV = AimAssist.CreateSlider({
	["Name"] = "FOV",
	["Min"] = 1,
	["Max"] = 1000,
	["Default"] = 90,
	["Function"] = function(val) 
		if aimfovframe then
			aimfovframe.Size = UDim2.new(0, val, 0, val)
		end
	end
})
AimAssistHeadshotChance = AimAssist.CreateSlider({
	["Name"] = "Headshot Chance",
	["Min"] = 1,
	["Max"] = 100,
	["Default"] = 25,
	["Function"] = function() end
})
AimAssistSwitchDelay = AimAssist.CreateTwoSlider({
	["Name"] = "Switch Delay",
	["Min"] = 1,
	["Max"] = 100, 
	["Default"] = 80,
	["Default2"] = 100,
	["HoverText"] = "Delay from moving to target."
})
AimAssistGunStats = AimAssist.CreateToggle({
	["Name"] = "Gun Stats",
	["Function"] = function() end,
	["HoverText"] = "Uses gun data to make you look more legit.\nTurning this off is more blatant with no attachments.\n(hip accuracy stat = less spread)",
	["Default"] = true
})
AimAssistFOVShow = AimAssist.CreateToggle({
	["Name"] = "FOV Circle",
	["Function"] = function(callback) 
		if callback then
			aimfovframe = Instance.new("Frame")
			aimfovframe.BackgroundTransparency = 0.8
			aimfovframe.ZIndex = -1
			aimfovframe.Visible = AimAssistMode["Value"] ~= "Blatant" and AimAssist["Enabled"]
			aimfovframe.BackgroundColor3 = Color3.fromHSV(aimfovframecolor["Hue"], aimfovframecolor["Sat"], aimfovframecolor["Value"])
			aimfovframe.Size = UDim2.new(0, AimAssistFOV["Value"], 0, AimAssistFOV["Value"])
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
AimAssistAutoFire = AimAssist.CreateToggle({
	["Name"] = "AutoFire",
	["Function"] = function(callback)
		if callback then
			spawn(function()
				repeat
					task.wait()
					if AimAssistMode["Value"] == "Blatant" and AimAssist["Enabled"] then
						local gun = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun
						if gun and gun.shoot and (not gun.knife) then 
							local plr, Head, dist = GetNearestHumanoidToPosition(true, 9999999999, true)
							gun:shoot(Head and true or false)
						end
					end
				until (not AimAssistAutoFire["Enabled"])
			end)
		end
	end,
	["HoverText"] = "Automatically fires gun (Blatant Only)",
})

local Hitboxes = {["Enabled"] = false}
local hitboxesexpand = {["Value"] = 30}
local realsizes = {
	["Head"] = vec3(1, 1, 1),
	["Torso"] = vec3(2, 2, 1),
	["Left Leg"] = vec3(1, 2, 1),
	["Left Arm"] = vec3(1, 2, 1),
	["Right Leg"] = vec3(1, 2, 1),
	["Right Arm"] = vec3(1, 2, 1),
}
local hitboxparts = {}
local hitboxesconnection
Hitboxes = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Hitboxes",
	["Function"] = function(callback)
		if callback then
			spawn(function()
				repeat
					if (not Hitboxes["Enabled"]) then break end
					task.wait(0.5)
					if (not Hitboxes["Enabled"]) then break end
					local teamparts = workspace.Players[tostring(lplr.TeamColor) == "Bright blue" and "Bright orange" or "Bright blue"]
					for i,v in pairs(teamparts:GetChildren()) do
						for i2,v2 in pairs(v:GetChildren()) do
							if realsizes[v2.Name] then
								v2.Size = realsizes[v2.Name] * (hitboxesexpand["Value"] / 10)
								v2.Mesh.Scale = Vector3.new(1, 1, 1)
							end
						end
					end
					hitboxesconnection = workspace.Ignore.DeadBody.ChildAdded:connect(function(v)
						for i2,v2 in pairs(v:GetChildren()) do
							if realsizes[v2.Name] then
								v2.Size = realsizes[v2.Name]
							end
						end
					end)
				until (not Hitboxes["Enabled"])
			end)
		else
			if hitboxesconnection then hitboxesconnection:Disconnect() end
			local teamparts = workspace.Players[tostring(lplr.TeamColor) == "Bright blue" and "Bright orange" or "Bright blue"]
			for i,v in pairs(teamparts:GetChildren()) do
				for i2,v2 in pairs(v:GetChildren()) do
					if realsizes[v2.Name] then
						v2.Size = realsizes[v2.Name]
						v2.Mesh.Scale = Vector3.new(1, 1, 1)
					end
				end
			end
		end
	end,
	["HoverText"] = "Increases enemy hitboxes"
})
hitboxesexpand = Hitboxes.CreateSlider({
	["Name"] = "Expand amount",
	["Min"] = 10,
	["Max"] = 50,
	["Function"] = function() end,
	["Default"] = 30
})

phantomforces["Effects"].breakwindow = function(self, part, direction, ...)
	local knife = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.knife
	if knife then
		local localchar = phantomforces["GetCharacter"](lplr)
		if localchar then
			local mag = (localchar.Torso.Position - part.Position).magnitude
			if mag >= 22 and direction ~= nil then
				return nil
			end
		end
	end
	return oldbreak(self, part, direction, ...)
end

Reach = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Reach", 
	["Function"] = function(callback) end,
})
ReachRange = Reach.CreateSlider({
	["Name"] = "Range",
	["Min"] = 1,
	["Max"] = 18,
	["Default"] = 18,
	["Function"] = function() end
})
ReachHeadshot = Reach.CreateSlider({
	["Name"] = "Headshot Chance",
	["Min"] = 1,
	["Max"] = 100,
	["Default"] = 25,
	["Function"] = function() end
})

SilentGrenade = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "GrenadeModifications", 
	["Function"] = function(callback) end,
	["HoverText"] = "spawns grenade to the nearest player to your mouse."
})
SilentGrenadeMode = SilentGrenade.CreateDropdown({
	["Name"] = "Mode",
	["List"] = {"Impact", "Sticky", "PlayerTP", "PlayerLerp"},
	["Function"] = function(val) end
})

NoFall = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "NoFall", 
	["Function"] = function(callback) end,
	["HoverText"] = "Removes Fall Damage"
})

runcode(function()
	local speedval = {["Value"] = 1}
	local bodyvelo
	local speeddelayval = tick()

	local speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed", 
		["Function"] = function(callback)
			if callback then
				BindToStepped("Speed", 1, function(time, delta)
					if phantomforces["Character"].alive then
						local newpos = (lplr.Character.Humanoid.MoveDirection * speedval["Value"])
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(newpos.X, lplr.Character.HumanoidRootPart.Velocity.Y, newpos.Z)
						if (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) and lplr.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
							lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end)
			else
				UnbindFromStepped("Speed")
			end
		end,
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed", 
		["Min"] = 1,
		["Max"] = 50, 
		["Function"] = function(val) end,
		["Default"] = 50
	})
end)

runcode(function()
	local CameraModification = {["Enabled"] = false}
	local CameraRecoil = {["Value"] = 100}
	local CameraSway = {["Value"] = 100}
	local old1
	local old2
	local old3
	local old4
	CameraModification = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "CameraModification",
		["Function"] = function(callback)
			if callback then
				old1 = phantomforces["Camera"].shakespring.s
				old2 = phantomforces["Camera"].swayspeed.s
				spawn(function()
					repeat
						if (not CameraModification["Enabled"]) then break end
						task.wait(0.1)
						if phantomforces["Camera"] then
							phantomforces["Camera"].shakespring.s = old1 * (100 / CameraRecoil["Value"])
							phantomforces["Camera"].zanglespring.s = 100
						end
						if (not CameraModification["Enabled"]) then break end
					until (not CameraModification["Enabled"])
				end)
			else
				if phantomforces["Camera"] then
					phantomforces["Camera"].shakespring.s = old1
					phantomforces["Camera"].swayspeed.s = old2
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
	local GunModification = {["Enabled"] = false}
	local GunFireRate = {["Value"] = 0}
	local GunInstantReload = {["Enabled"] = false}
	local gunoldfirerate
	local gunoldreload
	GunModification = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "GunModification",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.1)
						if (not GunModification["Enabled"]) then break end
						local memes = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.memes
						if memes then 
							local reload = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.reload
							if gunoldfirerate == nil then 
								gunoldfirerate = debug.getupvalue(memes, 4)
							end
							if reload then
								if gunoldreload == nil then 
									gunoldreload = phantomforces["GameLogic"].currentgun.reload
								end
								phantomforces["GameLogic"].currentgun.reload = function(...)
									if GunInstantReload["Enabled"] then 
										local magsize = phantomforces["GameLogic"].currentgun.data.magsize
										local currentammo = debug.getupvalue(memes, 2)
										local currentreserve = debug.getupvalue(memes, 3)
										local newnum = math.abs(currentammo - magsize)
										currentammo = currentammo + newnum
										if (currentreserve - newnum) < 0 then 
											if currentreserve > 0 then 
												currentammo = currentreserve
												currentreserve = 0
											else
												return 
											end
										else
											currentreserve = currentreserve - newnum
										end
										debug.setupvalue(memes, 2, currentammo)
										debug.setupvalue(memes, 3, currentreserve)
										phantomforces["Hud"]:updateammo(currentammo, currentreserve)
									else
										return gunoldreload(...)
									end
								end
							end
							debug.setupvalue(memes, 4, gunoldfirerate + (GunFireRate["Value"] * 10))
						else
							gunoldfirerate = nil
							gunoldreload = nil
						end
					until (not GunModification["Enabled"])
				end)
			else
				local memes = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.memes
				if memes then 
					if gunoldfirerate then
						debug.setupvalue(memes, 4, gunoldfirerate)
					end
					local reload = phantomforces["GameLogic"] and phantomforces["GameLogic"].currentgun and phantomforces["GameLogic"].currentgun.reload
					if reload and gunoldreload then 
						phantomforces["GameLogic"].currentgun.reload = gunoldreload
					end
				end
				gunoldfirerate = nil
				gunoldreload = nil
			end
		end
	})
	GunFireRate = GunModification.CreateSlider({
		["Name"] = "Extra FireRate",
		["Min"] = 0,
		["Max"] = 100,
		["Default"] = 10,
		["Function"] = function() end
	})
	GunInstantReload = GunModification.CreateToggle({
		["Name"] = "Instant Reload",
		["Function"] = function() end
	})
end)

runcode(function()
	local NoJumpDelay = {["Enabled"] = false}
	local oldjumpdelay1
	local oldjumpdelay2
	local oldjumpdelay3
	NoJumpDelay = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NoJumpDelay",
		["Function"] = function(callback)
			local tab = debug.getconstants(phantomforces["KeyPressFunc"])
			local jumploc = table.find(tab, "jump")
			local sprintloc = table.find(tab, "sprinting")
			if callback then 
				if jumploc then 
					oldjumpdelay1 = tab[jumploc + 1]
					oldjumpdelay2 = tab[jumploc + 2]
					debug.setconstant(phantomforces["KeyPressFunc"], jumploc + 1, 0)
					debug.setconstant(phantomforces["KeyPressFunc"], jumploc + 2, 0)
				end
				if sprintloc then 
					oldjumpdelay3 = tab[sprintloc + 3]
					debug.setconstant(phantomforces["KeyPressFunc"], sprintloc + 3, 0)
				end
			else
				if jumploc then 
					debug.setconstant(phantomforces["KeyPressFunc"], jumploc + 1, oldjumpdelay1)
					debug.setconstant(phantomforces["KeyPressFunc"], jumploc + 2, oldjumpdelay2)
				end
				if sprintloc then 
					debug.setconstant(phantomforces["KeyPressFunc"], sprintloc + 3, oldjumpdelay3)
				end
			end
		end
	})
end)

local function checkname()
	local str = lplr.Name
	for i = 1, str:len() do
		if str:sub(i, i) ~= "I" and str:sub(i, i) ~= "l" then
			return false
		end
	end
	return true
end
print("done3")

runcode(function()
	local Overlay = GuiLibrary.CreateCustomWindow({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png",
		["IconSize"] = 16
	})
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.SourceSans
	label.TextSize = 17
	label.Text = ""
	label.BackgroundTransparency = 1
	label.TextColor3 = col3(1, 1, 1)
	label.TextStrokeTransparency = 0
	label.Parent = Overlay.GetCustomChildren()
	Overlay["Bypass"] = true
	GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png", 
		["Function"] = function(callback)
			Overlay.SetVisible(callback) 
			if callback then
				spawn(function()
					repeat
						wait(1)
						label.Text = "Time Played : "..os.date("!%X",math.floor(tick() - injectiontime)).."\nVotekick Attempt : "..votekicked.."\nIlI Username : "..(checkname() and "Yes" or "No")
					until (Overlay and Overlay.GetCustomChildren() and Overlay.GetCustomChildren().Parent and Overlay.GetCustomChildren().Parent.Visible == false)
				end)
			end
		end, 
		["Priority"] = 2
	})
end)

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
	local ESPColor = {["Value"] = 0.44}
	local ESPHealthBar = {["Enabled"] = false}
	local ESPMethod = {["Value"] = "2D"}
	local ESPDrawing = {["Enabled"] = false}
	local ESPTeammates = {["Enabled"] = true}
	local ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ESP", 
		["Function"] = function(callback) 
			if callback then
				print("espenabled")
				BindToRenderStep("ESP", 500, function()
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

								
								if plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local char = phantomforces["GetCharacter"](plr)
    								if char then
										local allowed = false
										local rootPos, rootVis = cam:WorldToViewportPoint(char.Torso.Position)
										local rootSize = (char.Torso.Size.X * 1200) * (cam.ViewportSize.X / 1920)
										local headPos, headVis = cam:WorldToViewportPoint(char.Torso.Position + Vector3.new(0, 1 + 2.5, 0))
										local legPos, legVis = cam:WorldToViewportPoint(char.Torso.Position - Vector3.new(0, 1 + 2.5, 0))
										if ESPMethod2["Value"] == "Legit" then
											if rootVis then
												allowed = actuallyseeable[plr.Name]
											end
										else
											if rootVis then
												allowed = true
											end
										end
										if allowed then
											--thing.Visible = rootVis
											local sizex, sizey = (rootSize / rootPos.Z), (headPos.Y - legPos.Y) 
											local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
											if ESPHealthBar["Enabled"] then
												local health = phantomforces["Hud"]:getplayerhealth(plr) / 100
                								local color = HealthbarColorTransferFunction(health)
												thing.Quad3.Color = color
												thing.Quad3.Visible = true
												thing.Quad4.From = Vector2.new(posx - 4, posy + 1)
												thing.Quad4.To = Vector2.new(posx - 4, posy + sizey - 1)
												thing.Quad4.Visible = true
												local healthposy = sizey * math.clamp(health, 0, 1)
												thing.Quad3.From = Vector2.new(posx - 4, posy + sizey - (sizey - healthposy))
												thing.Quad3.To = Vector2.new(posx - 4, posy)
												--thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
											end
											thing.Quad1.PointA = Vector2.new(posx + sizex, posy)
											thing.Quad1.PointB = Vector2.new(posx, posy)
											thing.Quad1.PointC = Vector2.new(posx, posy + sizey)
											thing.Quad1.PointD = Vector2.new(posx + sizex, posy + sizey)
											thing.Quad1.Visible = true
											thing.Quad2.PointA = Vector2.new(posx + sizex, posy)
											thing.Quad2.PointB = Vector2.new(posx, posy)
											thing.Quad2.PointC = Vector2.new(posx, posy + sizey)
											thing.Quad2.PointD = Vector2.new(posx + sizex, posy + sizey)
											thing.Quad2.Visible = true
										end
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
								
								if plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local char = phantomforces["GetCharacter"](plr)
    								if char then
										local allowed = false
										local rootPos, rootVis = cam:WorldToViewportPoint(char.Torso.Position)
										if ESPMethod2["Value"] == "Legit" then
											if rootVis then
												allowed = actuallyseeable[plr.Name]
											end
										else
											if rootVis then
												allowed = true
											end
										end
										if allowed then
											local head = CalculateObjectPosition((char["Head"].CFrame).p)
											local headfront = CalculateObjectPosition((char["Head"].CFrame * CFrame.new(0, -0.5, -0.5)).p)
											local toplefttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(-1, -0.5, 0)).p)
											local toprighttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(1, -0.5, 0)).p)
											local toptorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(0, -0.5, 0)).p)
											local bottomtorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(0, -0.8, 0)).p)
											local bottomlefttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
											local bottomrighttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(0.5, -0.8, 0)).p)
											local leftarm = CalculateObjectPosition((char["Left Arm"].CFrame * CFrame.new(0, -0.2, 0)).p)
											local rightarm = CalculateObjectPosition((char["Right Arm"].CFrame * CFrame.new(0, -0.2, 0)).p)
											local leftleg = CalculateObjectPosition((char["Left Leg"].CFrame * CFrame.new(0, -0.2, 0)).p)
											local rightleg = CalculateObjectPosition((char["Right Leg"].CFrame * CFrame.new(0, -0.2, 0)).p)
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
								
								if plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local char = phantomforces["GetCharacter"](plr)
    								if char then
										local allowed = false
										local rootPos, rootVis = cam:WorldToViewportPoint(char.Torso.Position)
										local rootSize = (char.Torso.Size.X * 1200) * (cam.ViewportSize.X / 1920)
										local headPos, headVis = cam:WorldToViewportPoint(char.Torso.Position + Vector3.new(0, 1 + 2.5, 0))
										local legPos, legVis = cam:WorldToViewportPoint(char.Torso.Position - Vector3.new(0, 1 + 2.5, 0))
										if ESPMethod2["Value"] == "Legit" then
											if rootVis then
												allowed = actuallyseeable[plr.Name]
											end
										else
											if rootVis then
												allowed = true
											end
										end
										if allowed then
											if ESPHealthBar["Enabled"] then
												local health = phantomforces["Hud"]:getplayerhealth(plr) / 100
                								local color = HealthbarColorTransferFunction(health)
												thing.HealthLineMain.BackgroundColor3 = color
												thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(health, 0, 1), (math.clamp(health, 0, 1) == 0 and 0 or -2))
											end
											thing.Visible = true
											thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
											thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
										end
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
								
								if plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local char = phantomforces["GetCharacter"](plr)
    								if char then
										local allowed = false
										local rootPos, rootVis = cam:WorldToViewportPoint(char.Torso.Position)
										if ESPMethod2["Value"] == "Legit" then
											if rootVis then
												allowed = actuallyseeable[plr.Name]
											end
										else
											if rootVis then
												allowed = true
											end
										end
										if allowed then
											thing.Visible = true
											local head = CalculateObjectPosition((char["Head"].CFrame).p)
											local headfront = CalculateObjectPosition((char["Head"].CFrame * CFrame.new(0, -0.5, -0.5)).p)
											local toplefttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(-1, -0.5, 0)).p)
											local toprighttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(1, -0.5, 0)).p)
											local toptorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(0, -0.5, 0)).p)
											local bottomtorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(0, -0.8, 0)).p)
											local bottomlefttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
											local bottomrighttorso = CalculateObjectPosition((char["Torso"].CFrame * CFrame.new(0.5, -0.8, 0)).p)
											local leftarm = CalculateObjectPosition((char["Left Arm"].CFrame * CFrame.new(0, -0.2, 0)).p)
											local rightarm = CalculateObjectPosition((char["Right Arm"].CFrame * CFrame.new(0, -0.2, 0)).p)
											local leftleg = CalculateObjectPosition((char["Left Leg"].CFrame * CFrame.new(0, -0.2, 0)).p)
											local rightleg = CalculateObjectPosition((char["Right Leg"].CFrame * CFrame.new(0, -0.2, 0)).p)
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
						end
					end
				end)
			else
				print("espdisabled")
				UnbindFromRenderStep("ESP") 
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
		["List"] = {"2D", "Skeleton"},
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
	ESPMethod2 = ESP.CreateDropdown({
		["Name"] = "Visible",
		["List"] = {"Blatant", "Legit"},
		["Function"] = function() end
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
end)

print("done4")

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
	local TracersMethod = {["Value"] = "Blatant"}
	local TracersStartPosition = {["Value"] = "Middle"}
	local TracersEndPosition = {["Value"] = "Head"}
	local TracersTeammates = {["Enabled"] = true}
	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("Tracers", 500, function()
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

								if plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local char = phantomforces["GetCharacter"](plr)
									local allowed = TracersMethod["Value"] == "Blatant" or actuallyseeable[plr.Name]
									if char and allowed then
										local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and char.Head or char.Torso).Position)
										local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and char.Head or char.Torso).Position)
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
								
								if plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local char = phantomforces["GetCharacter"](plr)
									local allowed = TracersMethod["Value"] == "Blatant" or actuallyseeable[plr.Name]
									if char and allowed then
										local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and char.Head or char.Torso).Position)
										local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and char.Head or char.Torso).Position)
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
						end
				end)
			else
				UnbindFromRenderStep("Tracers") 
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
	TracersMethod = Tracers.CreateDropdown({
		["Name"] = "Visible",
		["List"] = {"Blatant", "Legit"},
		["Function"] = function() end
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
end)


runcode(function()
	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
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
	local NameTagsMethod = {["Value"] = "Blatant"}
	local NameTagsColor = {["Value"] = 0.44}
	local NameTagsDisplayName = {["Enabled"] = false}
	local NameTagsHealth = {["Enabled"] = false}
	local NameTagsDistance = {["Enabled"] = false}
	local NameTagsBackground = {["Enabled"] = true}
	local NameTagsScale = {["Value"] = 10}
	local NameTagsFont = {["Value"] = "SourceSans"}
	local NameTagsTeammates = {["Enabled"] = true}
	local fontitems = {"SourceSans"}
	local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameTags", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("NameTags", 500, function()
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

							if plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
								local char = phantomforces["GetCharacter"](plr)
								if char then
									local headPos, headVis = cam:WorldToViewportPoint((char.Torso:GetRenderCFrame() * CFrame.new(0, char.Head.Size.Y, 0)).Position)
									local allowed = NameTagsMethod["Value"] == "Blatant" or actuallyseeable[plr.Name]
									if headVis and allowed then
										local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										local displaynamestr2 = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										local blocksaway = 0
										if NameTagsDistance["Enabled"] then 
											local localchar = phantomforces["GetCharacter"](lplr)
											if localchar then 
												blocksaway = math.floor((localchar.Torso.Position - char.Torso.Position).magnitude / 3)
											end
										end
										local health = phantomforces["Hud"]:getplayerhealth(plr) / 100
										local rawText = (NameTagsDistance["Enabled"] and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth["Enabled"] and " "..math.floor(phantomforces["Hud"]:getplayerhealth(plr)) or "")
										local color = HealthbarColorTransferFunction(health)
										local modifiedText = (istarget and '[TARGET] ' or '')..(NameTagsDistance["Enabled"] and '['..blocksaway..'] ' or '')..displaynamestr2..(NameTagsHealth["Enabled"] and ' '..math.floor(phantomforces["Hud"]:getplayerhealth(plr)).."" or '')
										thing.Text.Text = removeTags(modifiedText)
										thing.Text.Size = 17 * (NameTagsScale["Value"] / 10)
										thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
										thing.Text.Visible = headVis
										thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont["Value"]) or 1) - 1, 0, 3))
										thing.Text.Position = Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y))
										thing.BG.Visible = headVis and NameTagsBackground["Enabled"]
										thing.BG.Size = Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y)
										thing.BG.Position = Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5)
									end
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
								
							if plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
								local char = phantomforces["GetCharacter"](plr)
								if char then
									local headPos, headVis = cam:WorldToViewportPoint((char.Torso:GetRenderCFrame() * CFrame.new(0, char.Head.Size.Y, 0)).Position)
									local allowed = NameTagsMethod["Value"] == "Blatant" or actuallyseeable[plr.Name]
									if headVis and allowed then
										local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										local displaynamestr2 = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
										local blocksaway = 0
										if NameTagsDistance["Enabled"] then 
											local localchar = phantomforces["GetCharacter"](lplr)
											if localchar then 
												blocksaway = math.floor((localchar.Torso.Position - char.Torso.Position).magnitude / 3)
											end
										end
										local health = phantomforces["Hud"]:getplayerhealth(plr) / 100
										local rawText = (NameTagsDistance["Enabled"] and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth["Enabled"] and " "..math.floor(phantomforces["Hud"]:getplayerhealth(plr)) or "")
										local color = HealthbarColorTransferFunction(health)
										local modifiedText = (NameTagsDistance["Enabled"] and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor(blocksaway)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(phantomforces["Hud"]:getplayerhealth(plr)).."</font>" or '')
										local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
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
					end
				end)
			else
				UnbindFromRenderStep("NameTags")
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
	NameTagsMethod = NameTags.CreateDropdown({
		["Name"] = "Visible",
		["List"] = {"Blatant", "Legit"},
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
end)

runcode(function()
	local AutoSpot = {["Enabled"] = false}
	AutoSpot = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoSpot",
		["Function"] = function(callback)
			if callback then 
				repeat 
					task.wait(0.5)
					if phantomforces["SpotRemote"] then 
						for i,plr in pairs(players:GetChildren()) do
							if lplr ~= plr and shared.vapeteamcheck(plr) then 
								if (not actuallyseeable[plr.Name]) and type(phantomforces["Ray"].raycastwhitelist) == "table" then
									local char = phantomforces["GetCharacter"](plr)
									if char then
										local ray = workspace:FindPartOnRayWithWhitelist(Ray.new(phantomforces["Camera"].cframe.p, CFrame.lookAt(phantomforces["Camera"].cframe.p, char.Head.Position + vec3(0, 0.5, 0)).LookVector * 1000), {table.unpack(phantomforces["Ray"].raycastwhitelist), char})
										if ray and ray.Parent == char then
											phantomforces["Network"]:send(phantomforces["SpotRemote"], plr, true, phantomforces["GameClock"].getTime())
										end
									end
								end
							end
						end
					end
				until (not AutoSpot["Enabled"])
			end
		end,
	})
end)

runcode(function()
	local GrenadeESP = {["Enabled"] = false}
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
							local localchar = phantomforces["GetCharacter"](lplr)
							local localroot = localchar and localchar:FindFirstChild("Torso")
							if localroot then
								local mag = (part.Position - localroot.Position).magnitude
								local rootPos, rootVis = cam:WorldToViewportPoint(part.Position)
								partframe.Visible = mag <= 50 and rootVis
								partframe.Position = UDim2.new(0, rootPos.X, 0, rootPos.Y - 36)
								partdistance.Text = math.floor(mag / 5).."m"
								local damagetext = "Safe"
								if mag < 30 then
									if not workspace:FindPartOnRayWithWhitelist(Ray.new(part.Position, (localroot.Position - part.Position)), phantomforces["Ray"].raycastwhitelist, true) then
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
	local oldcam
	local ThirdPersonDistance = {["Value"] = 20}
	local partconnection
	local thirdpersonparts = {}
	local thirdpersonconnections = {}
	--[[local states = {}
	local reader = phantomforces["BitReader"].newReader()
	local function readbit(bit)
		return reader:read(bit)
	end
	phantomforces["Network"]:add("bulkplayerupdate", function(p473)
		print("updatecec")
		if p473.newarray then
			states = p473.newarray
		end
		if p473.initstates then
			local initstates = p473.initstates;
			for plrnum = 1, #initstates do
				local currentstate = initstates[plrnum]
				local plr = states[plrnum]
				if plr == lplr then
					print("updat")
					phantomforces["Replication"].getupdater(lplr).initstate(currentstate)
				end
			end
		end
		if p473.packets then
			local l__packets__1516 = p473.packets;
			for plrnum = 1, #states do
				local plr = states[plrnum]
				if readbit(1) == 1 then
					if plr == lplr then
						print("updat")
						phantomforces["Replication"].getupdater(v1518).updateReplication(readbit)
					end
				end
			end
		end
	end)]]
	ThirdPerson = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ThirdPerson",
		["Function"] = function(callback)
			if callback then
				oldcam = phantomforces["CameraTask"].task
				phantomforces["CameraTask"].task = function(...)
					oldcam(...)
					local orig = cam.CFrame
					if thirdpersonstuff.updater and cam:FindFirstChild("MenuLobby") == nil then
						orig = orig * CFrame.new(0, 0, ThirdPersonDistance["Value"])
					end
					cam.CFrame = orig
				end
				if cam:FindFirstChild("MenuLobby") == nil then
					thirdpersonfunc()
				end
				for i,part in pairs(cam:GetDescendants()) do
					if part:IsA("BasePart") or part:IsA("Trail") or part:IsA("Decal") or part:IsA("Texture") then
						thirdpersonparts[part] = part.Transparency
						part.Transparency = (part.ClassName == "Trail" and NumberSequence.new(1) or 1)
						thirdpersonconnections[#thirdpersonconnections + 1] = part:GetPropertyChangedSignal("Transparency"):connect(function()
							if thirdpersonparts[part] then
								part.Transparency = (part.ClassName == "Trail" and NumberSequence.new(1) or 1)
							end
						end)
					end
				end
				partconnection = cam.DescendantAdded:connect(function(part)
					if part:IsA("BasePart") or part:IsA("Trail") or part:IsA("Decal") or part:IsA("Texture") then
						thirdpersonparts[part] = part.Transparency
						part.Transparency = (part.ClassName == "Trail" and NumberSequence.new(1) or 1)
						thirdpersonconnections[#thirdpersonconnections + 1] = part:GetPropertyChangedSignal("Transparency"):connect(function()
							if thirdpersonparts[part] then
								part.Transparency = (part.ClassName == "Trail" and NumberSequence.new(1) or 1)
							end
						end)
					end
				end)
				--[[phantomforces["Connections"].bulkplayerupdate = function(p473)
					print("updatecec")
					if p473.newarray then
						states = p473.newarray
					end
					if p473.initstates then
						local initstates = p473.initstates;
						for plrnum = 1, #initstates do
							local currentstate = initstates[plrnum]
							local plr = states[plrnum]
							if plr == lplr then
								print("updat")
								phantomforces["Replication"].getupdater(lplr).initstate(currentstate)
							end
						end
					end
					if p473.packets then
						for plrnum = 1, #states do
							local plr = states[plrnum]
							if readbit(1) == 1 then
								if plr == lplr then
									print("updat")
									phantomforces["Replication"].getupdater(v1518).updateReplication(readbit)
								end
							end
						end
					end
				end]]
				--print(phantomforces["Connections"].bulkplayerupdate)b tyg
				--[[spawn(function()
					repeat
						task.wait(1)
						print(ok.alive)
					until (not ThirdPerson["Enabled"])
				end)]]
			--	phantomforces["Camera"]:setspectate(game.Players:GetChildren()[2])
			else
				pcall(function() UnbindFromRenderStep("ThirdPerson") end)
				if partconnection then
					partconnection:Disconnect()
				end
				for i2,v2 in pairs(thirdpersonconnections) do
					if v2.Disconnect then
						v2:Disconnect()
					end
				end
				for i,v in pairs(thirdpersonparts) do
					if i and v then
						local real = v
						thirdpersonparts[i] = nil
						i.Transparency = real
					end
				end
				table.clear(thirdpersonparts)
				phantomforces["CameraTask"].task = oldcam
				pcall(function() thirdpersonstuff.model:Remove() thirdpersonstuff.updater.died() end)
				table.clear(thirdpersonstuff)
				--phantomforces["Connections"].bulkplayerupdate = oldserverrepupdate
			end
		end
	})
	ThirdPersonDistance = ThirdPerson.CreateSlider({
		["Name"] = "Distance",
		["Function"] = function() end,
		["Min"] = 1,
		["Max"] = 30,
		["Default"] = 20
	})
end)

print("done5")