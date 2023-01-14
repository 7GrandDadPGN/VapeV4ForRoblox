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
local textchatservice = game:GetService("TextChatService")
local collectionservice = game:GetService("CollectionService")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChildWhichIsA("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local v3check = syn and syn.toast_notification and "V3" or ""
local connectionstodisconnect = {}
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
local entity = shared.vapeentity

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

local vischeckobj = RaycastParams.new()
local function vischeck(char, checktable)
	local rayparams = checktable.IgnoreObject or vischeckobj
	if not checktable.IgnoreObject then 
		rayparams.FilterDescendantsInstances = {lplr.Character, char, cam, table.unpack(checktable.IgnoreTable or {})}
	end
	local ray = workspace.Raycast(workspace, checktable.Origin, CFrame.lookAt(checktable.Origin, char[checktable.AimPart].Position).lookVector * (checktable.Origin - char[checktable.AimPart].Position).Magnitude, rayparams)
	return not ray
end

local function runcode(func)
	func()
end

local animals = {}
animals = workspace.animals:GetChildren()
workspace.animals.ChildAdded:Connect(function(obj)
	table.insert(animals, obj)
end)
workspace.animals.ChildRemoved:Connect(function(obj)
	table.remove(animals, table.find(animals, obj))
end)

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
		for i, v in pairs(animals) do 
            if v.PrimaryPart and currentamount < amount then -- checks
				local mag = (entity.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, {Player = {Name = v.Name, UserId = 1}, RootPart = v.PrimaryPart, Animal = true, Character = v})
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

local remotes
local itemhandler = require(repstorage.game.Items)
local items = debug.getupvalue(itemhandler.getItemData, 1)
local projectiles = require(repstorage.modules.game.Projectiles)
local clientdata = require(repstorage.modules.player.ClientData)
local newitems = {}
for i,v in pairs(items) do 
	newitems[v.id] = v
end
local hooked = {}
repeat
	for i,v in pairs(getgc(true)) do 
		if type(v) == "function" then
			if debug.getinfo(v).source:find("exitButtonComponent") and not hooked[v] then 
				hooked[v] = true
				hookfunction(v, function() return end)
			end
		end
		if type(v) == "table" and remotes == nil then
			if rawget(v, "meleePlayer") and typeof(v.meleePlayer) == "table" then 
				remotes = v
			end
		end
	end
	task.wait(1)
until remotes ~= nil

GuiLibrary["SelfDestructEvent"].Event:Connect(function()
	for i3,v3 in pairs(connectionstodisconnect) do
		if v3.Disconnect then pcall(function() v3:Disconnect() end) continue end
		if v3.disconnect then pcall(function() v3:disconnect() end) continue end
	end
end)

local killauranear = false
GuiLibrary["RemoveObject"]("KillauraOptionsButton")
GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("TriggerBotOptionsButton")
GuiLibrary["RemoveObject"]("SafeWalkOptionsButton")
GuiLibrary["RemoveObject"]("XrayOptionsButton")
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
GuiLibrary["RemoveObject"]("FlyOptionsButton")

runcode(function()
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

	local SilentAim = {["Enabled"] = false}
	local SilentAimFOV = {["Value"] = 300}
	local old
	SilentAim = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SilentAim", 
		["Function"] = function(callback)
			if callback then
				old = projectiles.shoot
				projectiles.shoot = function(p1, p2, p3, p4, p5, ...)
					local projvelo = items[p3].projectileVelocity
					local plr = GetNearestHumanoidToMouse(true, SilentAimFOV["Value"], {
						AimPart = "HumanoidRootPart",
						WallCheck = true
					})
					if plr then 
						local dist = (plr.RootPart.Position - p4.Position).Magnitude
						local t = (projvelo * dist + 196.2 * dist) / projvelo ^ 2
						local pos = Vector3.new(
							plr.RootPart.Position.X,
							plr.RootPart.Position.Y + (((196.2 ^ t) / 2) - (t * 2)),
							plr.RootPart.Position.Z
						)
						local calculated = LaunchDirection(p4.Position, FindLeadShot(pos, plr.RootPart.Velocity, projvelo, p4.Position, Vector3.zero, workspace.Gravity), projvelo, workspace.Gravity, false)
						if calculated then
							p4 = CFrame.new(p4.Position, p4.Position + calculated)
						end
					end
					return old(p1, p2, p3, p4, p5, ...)
				end
			else
				projectiles.shoot = old
			end
		end
	})
	SilentAimFOV = SilentAim.CreateSlider({
		["Name"] = "FOV", 
		["Min"] = 1, 
		["Max"] = 1000, 
		["Function"] = function(val) end,
		["Default"] = 80
	})
end)

runcode(function()
	local ignorelist = OverlapParams.new()
	ignorelist.FilterType = Enum.RaycastFilterType.Whitelist
	local killauraboxes = {}
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
    local killauraremote = remotes.meleePlayer
	local killauraremote2 = repstorage:WaitForChild("remoteInterface"):WaitForChild("interactions"):WaitForChild("meleeAnimal")
	local killauraanimdelay = tick()
	local killauraanimnum = 0

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
								if tool then
									local toolmeta = newitems[tool.toolModel:GetAttribute("itemId")]
									if toolmeta and table.find(toolmeta.itemType, "Melee Weapon") then
										if (not killauramouse["Enabled"]) or uis:IsMouseButtonPressed(0) then 
											for i,v in pairs(plrs) do
												local localfacing = entity.character.HumanoidRootPart.CFrame.lookVector
												local vec = (v.RootPart.Position - entity.character.HumanoidRootPart.Position).unit
												local angle = math.acos(localfacing:Dot(vec))
												if angle >= (math.rad(killauraangle["Value"]) / 2) then continue end
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
												if killauraanimdelay < tick() then
													killauraanimdelay = tick() + 0.5
													local anims = itemhandler.getItemAnimations(toolmeta.id, "action")
													if killauraanimnum >= #anims then killauraanimnum = 0 end
													killauraanimnum = killauraanimnum + 1
													local anim = Instance.new("Animation")
													anim.AnimationId = anims[killauraanimnum]
													local loaded = entity.character.Humanoid.Animator:LoadAnimation(anim)
													loaded.Stopped:Connect(function()
														if anim then anim:Destroy() anim = nil end
														if loaded then loaded:Destroy() loaded = nil end
													end)
													loaded:Play(nil, 1, loaded.Length / 0.5)
												end
												local rem = v.Animal and killauraremote2 or killauraremote
												rem:FireServer(tonumber(tool.Name), v.Animal and v.Character or v.Player)
											end
											task.wait(0.1)
										end
									end
								else
									lastplr = nil
									targetedplayer = nil
									killauranear = false
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
	killaurarange = Killaura.CreateSlider({
		["Name"] = "Attack range",
		["Min"] = 1,
		["Max"] = 16, 
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
				RunLoops:BindToHeartbeat("Speed", 1, function(delta)
					if entity.isAlive then
						local movevec = (speedmovemethod["Value"] == "Manual" and (CFrame.lookAt(cam.CFrame.p, cam.CFrame.p + Vector3.new(cam.CFrame.lookVector.X, 0, cam.CFrame.lookVector.Z))):VectorToWorldSpace(Vector3.new(a + d, 0, w + s)) or entity.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.new()
						local newpos = (movevec * (math.max(speedval["Value"] - entity.character.Humanoid.WalkSpeed, 0) * delta))
						if speedwallcheck["Enabled"] then
							local raycastparameters = RaycastParams.new()
							raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
							raycastparameters.FilterDescendantsInstances = {lplr.Character, cam}
							local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, newpos, raycastparameters)
							if ray then newpos = (ray.Position - entity.character.HumanoidRootPart.Position) end
						end
						entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + newpos
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
	speedmovemethod = speed.CreateDropdown({
		["Name"] = "Movement", 
		["List"] = {"Manual", "MoveDirection"},
		["Function"] = function(val) end
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed", 
		["Min"] = 1,
		["Max"] = 28, 
		["Function"] = function(val) end
	})
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
				local flytog = false
				local flytogtick = tick()
				local oldflypos
				RunLoops:BindToHeartbeat("Fly", 1, function(delta) 
					if entity.isAlive then
						if flyalivecheck == false then
							flyposy = entity.character.HumanoidRootPart.CFrame.p.Y
							flyalivecheck = true
						end
						local movevec = (flymovemethod["Value"] == "Manual" and (CFrame.lookAt(cam.CFrame.p, cam.CFrame.p + Vector3.new(cam.CFrame.lookVector.X, 0, cam.CFrame.lookVector.Z))):VectorToWorldSpace(Vector3.new(a + d, 0, w + s)) or entity.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.new()
						if flystate["Value"] ~= "None" then 
							entity.character.Humanoid:ChangeState(Enum.HumanoidStateType[flystate["Value"]])
						end
						if flyup then
							flyposy = flyposy + (flyverticalspeed["Value"] * delta)
						end
						if flydown then
							flyposy = flyposy - (flyverticalspeed["Value"] * delta)
						end
						flypos = Vector3.new(0, (flyposy - entity.character.HumanoidRootPart.CFrame.p.Y), 0)
						if flywall["Enabled"] then
							local raycastparameters = RaycastParams.new()
							raycastparameters.FilterType = Enum.RaycastFilterType.Blacklist
							raycastparameters.FilterDescendantsInstances = {lplr.Character, cam}
							local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, flypos, raycastparameters)
							if ray and ray.Instance.CanCollide then flypos = (ray.Position - entity.character.HumanoidRootPart.Position) flyposy = entity.character.HumanoidRootPart.CFrame.p.Y end
						end
						local origvelo = entity.character.HumanoidRootPart.Velocity
						entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + flypos
						entity.character.HumanoidRootPart.Velocity = Vector3.new(origvelo.X, 0, origvelo.Z)
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
	flyverticalspeed = fly.CreateSlider({
		["Name"] = "Vertical Speed",
		["Min"] = 1,
		["Max"] = 150, 
		["Function"] = function(val) end
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
end)

runcode(function()
	local Nuker = {["Enabled"] = false}
	local structures = {}
	local resources = {}
	for i,obj in pairs(workspace.placedStructures:GetDescendants()) do 
		if obj:IsA("Model") then 
			table.insert(structures, obj)
		end
	end
	connectionstodisconnect[#connectionstodisconnect + 1] = workspace.placedStructures.DescendantAdded:Connect(function(obj)
		if obj:IsA("Model") then 
			table.insert(structures, obj)
		end
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = workspace.placedStructures.DescendantRemoving:Connect(function(obj)
		if obj:IsA("Model") then 
			table.remove(structures, table.find(structures, obj))
		end
	end)
	for i,obj in pairs(workspace.worldResources:GetDescendants()) do 
		if obj:IsA("Model") then 
			table.insert(resources, obj)
		end
	end
	connectionstodisconnect[#connectionstodisconnect + 1] = workspace.worldResources.DescendantAdded:Connect(function(obj)
		if obj:IsA("Model") then 
			table.insert(resources, obj)
		end
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = workspace.worldResources.DescendantRemoving:Connect(function(obj)
		if obj:IsA("Model") then 
			table.remove(resources, table.find(resources, obj))
		end
	end)
	Nuker = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Nuker", 
		["Function"] = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						if entity.isAlive then 
							local tool = lplr.Character:FindFirstChildWhichIsA("Tool")
							local broke = 0
							if tool then
								local toolmeta = newitems[tool.toolModel:GetAttribute("itemId")]
								if toolmeta then
									for i,v in pairs(structures) do 
										if v.PrimaryPart and (v.PrimaryPart.Position - entity.character.HumanoidRootPart.Position).Magnitude < 25 then 
											if (table.find(toolmeta.itemType, "Axe") or table.find(toolmeta.itemType, "Melee Weapon")) and v:GetAttribute("placedBy") ~= lplr.UserId then
												remotes.hitStructure:FireServer(tonumber(tool.Name), v, v.PrimaryPart.Position)
												broke += 1
											end
										end
									end
									for i,v in pairs(resources) do 
										local primary = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
										if primary and (primary.Position - entity.character.HumanoidRootPart.Position).Magnitude < 25 then 
											if table.find(toolmeta.itemType, "Pickaxe") then 
												remotes.mine:FireServer(tonumber(tool.Name), v, primary.Position)
												broke += 1
											end
											if table.find(toolmeta.itemType, "Axe") then
												remotes.chop:FireServer(tonumber(tool.Name), v, primary.Position)
												broke += 1
											end
										end
									end
								end
								task.wait(broke % 10 / 100)
							end
						end
					until (not Nuker["Enabled"])
				end)
			end
		end
	})
end)

local doing = false
runcode(function()
    local PlayerTP = {["Enabled"] = false}
    PlayerTP = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "PlayerTP", 
		["Function"] = function(callback)
            if callback then 
                task.spawn(function()
                    if doing then 
                        createwarning("PlayerTP", "currently doing", 5)
                        return 
                    end
                    doing = true
                    if entity.isAlive then 
                        local root = entity.character.HumanoidRootPart
                        local seat
                        for i,v in pairs(workspace.boats:GetChildren()) do 
                            local gotseat = v:FindFirstChildWhichIsA("VehicleSeat", true)
                            if gotseat and gotseat.Occupant == nil then 
                                seat = gotseat
                                break
                            end
                        end
                        if not seat then 
                            createwarning("PlayerTP", "no seat", 5)
                            doing = false
                            return 
                        end
                        local target
                        for i,v in pairs(entity.entityList) do 
                            if v.Targetable and targetCheck(v) then
                                target = v 
                                break
                            end
                        end
                        if target == nil then 
                            createwarning("PlayerTP", "no target", 5)
                            doing = false
                            return 
                        end
                        firetouchinterest(root, seat, 1)
                        firetouchinterest(root, seat, 0)
						local start = tick()
                        repeat task.wait() until entity.character.Humanoid.SeatPart ~= nil or (tick() - start) > 3
						if entity.character.Humanoid.SeatPart == nil then 
							doing = false
							return
						end
						createwarning("PlayerTP", "Teleporting, wait.", 10)
                        local connection = game:GetService("RunService").Heartbeat:Connect(function()
                            seat.Parent.PrimaryPart.Velocity = Vector3.zero
                            seat.Parent.PrimaryPart.RotVelocity = Vector3.zero
                        end)
						local pos = target.Character.PrimaryPart.CFrame
                        seat.Parent.PrimaryPart.CFrame = pos
						lplr:GetAttributeChangedSignal("tpCheckTime"):Wait()
						task.wait(1)
                        connection:Disconnect()
                        entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        doing = false
                    else
                        createwarning("PlayerTP", "not alive", 5)
                        doing = false
                    end
                end)
                PlayerTP["ToggleButton"](false)
            end
        end
    })
end)


runcode(function()
    local MouseTP = {["Enabled"] = false}
    MouseTP = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "MouseTP", 
		["Function"] = function(callback)
            if callback then 
                task.spawn(function()
                    if doing then 
                        createwarning("MouseTP", "currently doing", 5)
                        return 
                    end
                    doing = true
                    if entity.isAlive then 
                        local root = entity.character.HumanoidRootPart
                        local seat
                        for i,v in pairs(workspace.boats:GetChildren()) do 
                            local gotseat = v:FindFirstChildWhichIsA("VehicleSeat", true)
                            if gotseat and gotseat.Occupant == nil then 
                                seat = gotseat
                                break
                            end
                        end
                        if not seat then 
                            createwarning("MouseTP", "no seat", 5)
                            doing = false
                            return 
                        end
                        local target = workspace:Raycast(lplr:GetMouse().UnitRay.Origin, lplr:GetMouse().UnitRay.Direction * 100000, RaycastParams.new())
                        if target == nil then 
                            createwarning("MouseTP", "no target", 5)
                            doing = false
                            return 
                        end
                        firetouchinterest(root, seat, 1)
                        firetouchinterest(root, seat, 0)
						local start = tick()
                        repeat task.wait() until entity.character.Humanoid.SeatPart ~= nil or (tick() - start) > 3
						if entity.character.Humanoid.SeatPart == nil then 
							doing = false
							return
						end
						createwarning("MouseTP", "Teleporting, wait.", 10)
                        local connection = game:GetService("RunService").Heartbeat:Connect(function()
                            seat.Parent.PrimaryPart.Velocity = Vector3.zero
                            seat.Parent.PrimaryPart.RotVelocity = Vector3.zero
                        end)
                        seat.Parent.PrimaryPart.CFrame = CFrame.new(target.Position)
						lplr:GetAttributeChangedSignal("tpCheckTime"):Wait()
						task.wait(1)
                        connection:Disconnect()
                        entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        doing = false
                    else
                        createwarning("MouseTP", "not alive", 5)
                        doing = false
                    end
                end)
                MouseTP["ToggleButton"](false)
            end
        end
    })
end)

runcode(function()
	local AutoHeal = {["Enabled"] = false}
	local eatremote = repstorage:WaitForChild("remoteInterface"):WaitForChild("interactions"):WaitForChild("eat")
	local maxHunger = repstorage:WaitForChild("game"):WaitForChild("maxHunger").Value
	AutoHeal = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoHeal", 
		["Function"] = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						local inv = clientdata.getInventory()
						if inv then 
							local chosen
							local smallest = 9e9
							for i,v in pairs(inv) do 
								local itemdata = newitems[i]
								if itemdata and itemdata.itemStats and itemdata.itemStats.food and (itemdata.instantHealth == nil or itemdata.instantHealth > 0) then 
									if (clientdata.getHunger() + itemdata.itemStats.food) < maxHunger and itemdata.itemStats.food < smallest then 
										smallest = itemdata.itemStats.food
										chosen = i
									end
								end
							end
							if chosen then 
								eatremote:FireServer(chosen)
								task.wait(0.2)
							end
						end
					until (not AutoHeal["Enabled"])
				end)
			end
		end
	})
end)

runcode(function()
	local AutoPickup = {["Enabled"] = false}
	local pickupitem = repstorage:WaitForChild("remoteInterface"):WaitForChild("inventory"):WaitForChild("pickupItem")
	local pickedup = {}
	AutoPickup = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoPickup", 
		["Function"] = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait(0.01)
						if entity.isAlive then 
							for i,v in pairs(collectionservice:GetTagged("DROPPED_ITEM")) do 
								if (v.Position - entity.character.HumanoidRootPart.Position).Magnitude < 10 and (pickedup[v] == nil or pickedup[v] <= tick()) then
									pickedup[v] = tick() + 0.2
									pickupitem:FireServer(v)
								end
							end
						end
					until (not AutoPickup["Enabled"])
				end)
			end
		end
	})
end)

runcode(function()
	local InfiniteStamina = {["Enabled"] = false}
	InfiniteStamina = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "InfiniteStamina", 
		["Function"] = function(callback)
			if callback then 
				task.spawn(function()
					repeat
						task.wait(0.01)
						lplr:SetAttribute("stamina", 1)
					until (not InfiniteStamina["Enabled"])
				end)
			end
		end
	})
end)