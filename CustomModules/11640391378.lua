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

local framework = require(game:GetService("ReplicatedStorage"):WaitForChild("MultiboxFramework"))
local setthreadidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity
local getthreadidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity

local function fireremote(...)
	local old = getthreadidentity()
	setthreadidentity(2)
	if framework.Network and framework.Network.Fire then
		framework.Network.Fire(...)
	else
		createwarning("Vape", "skill issue", 1)
	end
	setthreadidentity(old)
end

local function firefunction(...)
	local old = getthreadidentity()
	setthreadidentity(2)
	if framework.Network and framework.Network.Invoke then 
		framework.Network.Invoke(...)
	else
		createwarning("Vape", "skill issue", 1)
	end
	setthreadidentity(old)
end

local function getItem(name)
	if entity.isAlive then 
		for i,v in pairs(lplr.Character:GetChildren()) do 
			if v:GetAttribute("Type") == name then return v end
		end
	end
	return nil
end

local killauranear = false
runcode(function()
	GuiLibrary["RemoveObject"]("KillauraOptionsButton")
	local killauraboxes = {}
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
							local tool = getItem("Sword")
							if #plrs > 0 and tool then
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
										fireremote("SwordSlash", tool.Name, v.RootPart, CFrame.lookAt(entity.character.HumanoidRootPart.Position, v.RootPart.Position).lookVector, {v.RootPart})
									end
									task.wait(0.01)
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
		["Max"] = 20, 
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
	local Nuker = {["Enabled"] = false}
	local NukerAllBlocks = {["Enabled"] = false}
	local nukerlegit = {["Enabled"] = false}
	local nukerrange = {["Value"] = 25}
	local nukerown = {["Enabled"] = false}
	Nuker = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Nuker", 
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						if entity.isAlive then 
							if nukerlegit["Enabled"] then 
								local tool = getItem("Normal")
								if not tool then return end
								if tool.Name ~= "wooden_pickaxe" then return end
							end
							local breakblock = false
							for i,v in pairs(workspace.PlacedItems:GetChildren()) do 
								if v:GetAttribute("Breakable") and (NukerAllBlocks["Enabled"] or v.Name == "bed") then 
									if not nukerown["Enabled"] then 
										if v:GetAttribute("DisplayName"):find(tostring(lplr.Team)) then continue end
									end
									if v:IsA("Model") and v.PrimaryPart and (v.PrimaryPart.Position - entity.character.HumanoidRootPart.Position).Magnitude < nukerrange["Value"] then 
										fireremote("HitBlock", "wooden_pickaxe", v)
										breakblock = true
									end
								end
							end
							if breakblock then 
								task.wait(0.01)
							end
						end
					until (not Nuker.Enabled)
				end)
			end 
		end
	})
	nukerrange = Nuker.CreateSlider({
		["Name"] = "Break range",
		["Min"] = 1, 
		["Max"] = 25, 
		["Function"] = function(val) end, 
		["Default"] = 25
	})
	NukerAllBlocks = Nuker.CreateToggle({
		["Name"] = "All Blocks",
		["Function"] = function() end
	})
	nukerlegit = Nuker.CreateToggle({
		["Name"] = "Hand Check",
		["Function"] = function() end
	})
	nukerown = Nuker.CreateToggle({
		["Name"] = "Team Break",
		["Function"] = function() end,
	})
end)

runcode(function()
	local AutoQueue = {["Enabled"] = false}
	local connection 
	AutoQueue = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoQueue", 	
		["Function"] = function(callback)
			if callback then
				pcall(function()
					connection = lplr.PlayerGui:FindFirstChild("WinFrame", true):GetPropertyChangedSignal("Visible"):Connect(function()
						fireremote("JoinQueue")
					end)
				end)
			else
				if connection then 
					connection:Disconnect()
				end
			end
		end
	})
end)
