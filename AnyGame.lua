--[[ 
	Credits
	Infinite Yield - Blink (backtrack), Freecam and SpinBot (spin / fling)
	Please notify me if you need credits
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		if not betterisfile("vape/"..scripturl) then
			error("File not found : vape/"..scripturl)
		end
		return readfile("vape/"..scripturl)
	else
		local res = game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
		assert(res ~= "404: Not Found", "File not found")
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
	else
		return {
			Body = "bad exploit",
			Headers = {},
			StatusCode = 404
		}
	end
end 
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local entity = loadstring(GetURL("Libraries/entityHandler.lua"))()
shared.vapeentity = entity

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
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
		local friend = (table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)] and true or nil)
		if recolor then
			return (friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] and true or nil)
		else
			return friend
		end
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

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #players:GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr)
	return plr and plr.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil
end

do
	GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendRefresh.Event:connect(function()
		entity.fullEntityRefresh()
	end)
	entity.isPlayerTargetable = function(plr)
		return lplr ~= plr and shared.vapeteamcheck(plr) and friendCheck(plr) == nil
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

local function vischeck(char, part, ignorelist)
	local rayparams = RaycastParams.new()
	rayparams.FilterDescendantsInstances = {lplr.Character, char, cam, table.unpack(ignorelist or {})}
	local ray = workspace.Raycast(workspace, cam.CFrame.p, CFrame.lookAt(cam.CFrame.p, char[part].Position).lookVector.Unit * (cam.CFrame.p - char[part].Position).Magnitude, rayparams)
	return not ray
--	local unpacked = unpack(cam.GetPartsObscuringTarget(cam, {lplr.Character[part].Position, char[part].Position}, {lplr.Character, char, cam, table.unpack(ignorelist or {})}))
	--return not unpacked
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount, checkvis, vistab)
	local returnedplayer = {}
	local currentamount = 0
    if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
            if (targetcheck or v.Targetable) and targetCheck(v) and currentamount < amount then -- checks
				if checkvis then
					if not vischeck(v.Character, "Head", vistab) then continue end
				end
                local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance, checkvis, vistab)
	local closest, returnedplayer, targetpart = distance, nil, nil
	if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
            if (targetcheck or v.Targetable) and targetCheck(v) then -- checks
				if checkvis then
					if not vischeck(v.Character, "Head", vistab) then continue end
				end
                local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
                if mag <= closest then -- mag check
                    closest = mag
					returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(player, distance, checkvis, ignorelist)
    local closest, returnedplayer = distance, nil
    if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
            if (targetcheck or v.Targetable) and targetCheck(v) then -- checks
				if checkvis then
					if not vischeck(v.Character, "HumanoidRootPart") then continue end
				end
                local vec, vis = cam.WorldToScreenPoint(cam, v.RootPart.Position)
				local mag = (uis.GetMouseLocation(uis) - Vector2.new(vec.X, vec.Y)).magnitude
                if vis and mag <= closest then -- mag check
                    closest = mag
					returnedplayer = v
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

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

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
Radar.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):connect(function()
	RadarFrame.Position = UDim2.new(0, 0, 0, (Radar.GetCustomChildren().Parent.Size.Y.Offset == 0 and 45 or 0))
end)
players.PlayerRemoving:connect(function(plr)
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
	local aimsmartab = {}
	local aimfovframecolor = {["Value"] = 0.44}
	local aimheadshotchance = {["Value"] = 1}
	local aimassisttarget
	local aimhitchance = {["Value"] = 1}
	local aimmethod = {["Value"] = "FindPartOnRayWithIgnoreList"}
	local aimmode = {["Value"] = "Legit"}
	local aimmethodmode = {["Value"] = "Whitelist"}
	local aimtable = {["FindPartOnRayWithIgnoreList"] = 1, ["FindPartOnRayWithWhitelist"] = 1, ["FindPartOnRay"] = 1, ["ScreenPointToRay"] = 3, ["ViewportPointToRay"] = 3, ["Raycast"] = 2}
	local aimignoredscripts = {["ObjectList"] = {}}
	local aimbound
	local shoottime = tick()
	local recentlyshotplr
	local recentlyshottick = tick()
	local aimfovframe
	local pressed = false
	local tar = nil

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

	local AimAssist = {["Enabled"] = false}
	AimAssist = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SilentAim", 
		["Function"] = function(callback) 
			if callback then
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
									["Health"] = plr.Character.Humanoid.Health,
									["MaxHealth"] = plr.Character.Humanoid.MaxHealth
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
						local Args = {...}
						local calling = getcallingscript() 
						if calling then
							local list = #aimignoredscripts["ObjectList"] > 0 and aimignoredscripts["ObjectList"] or {"ControlScript", "ControlModule"}
							if table.find(list, tostring(calling)) then
								return oldnamecall(self, ...)
							else
							--	print("SilentAim ["..NamecallMethod.."]: "..tostring(calling))
								if aimtable[aimmethod["Value"]] == 1 then
									if type(Args[2]) == "table" then
									--	local str = "{"
									--	for i,v in pairs(Args[2]) do 
										--	str = str..tostring(v)..(#Args[2] == i and "}" or ", ")
										--end
									--	print("FilterInstances ["..#Args[2].."]: "..str)
									end
								elseif aimtable[aimmethod["Value"]] == 2 then
									if aimmethodmode["Value"] ~= "All" and aimmethodmode["Value"] ~= Args[3].FilterType.Name then
										return oldnamecall(self, ...)
									else
									--	local str = "{"
									--	for i,v in pairs(Args[3].FilterDescendantsInstances) do 
									--		str = str..tostring(v)..(#Args[3].FilterDescendantsInstances == i and "}" or ", ")
									--	end
									--	print("FilterInstances ["..#Args[3].FilterDescendantsInstances.."]: "..str)
										--print("FilterType: "..Args[3].FilterType.Name)
									end
								end
							end
						end
						local plr
						if aimmode["Value"] == "Legit" then
							plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], aimvischeck["Enabled"], aimsmartab)
						else
							plr = GetNearestHumanoidToPosition(aimassisttarget["Players"]["Enabled"], aimfov["Value"], aimvischeck["Enabled"], aimsmartab)
						end
						if not plr then
							return oldnamecall(self, ...)
						end
						recentlyshotplr = plr
						recentlyshottick = tick() + 3
						local tar = (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimheadshotchance["Value"] and plr.Head or plr.RootPart
						if aimtable[aimmethod["Value"]] == 1 then
							local mag = (Vector3.new() - Args[1].Direction).Magnitude
							local direction = CFrame.lookAt(Args[1].Origin, tar.Position).lookVector * mag
							Args[1] = Ray.new(Args[1].Origin, direction)
							if aimwallbang["Enabled"] then
								return tar, tar.Position, direction, tar.Material
							end
						elseif aimtable[aimmethod["Value"]] == 2 then
							local mag = (Vector3.new() - Args[2]).Magnitude
							local direction = CFrame.lookAt(Args[1], tar.Position).lookVector * mag
							Args[2] = direction
							if aimwallbang["Enabled"] then
								local haha = RaycastParams.new()
								haha.FilterType = Enum.RaycastFilterType.Whitelist
								haha.FilterDescendantsInstances = {tar}
								Args[3] = haha
							end
						elseif aimtable[aimmethod["Value"]] == 3 then
							local direction = CFrame.lookAt(cam.CFrame.p, tar.Position).lookVector.Unit
							return Ray.new(cam.CFrame.p, direction)
						end
						return oldnamecall(self, unpack(Args))
					end)
					--[[local oldindex
					oldindex = hookmetamethod(game, "__index", function(Self, Val)
						if (not tar) or (not AimAssist["Enabled"]) then
							return oldindex(Self, Val)
						end
						if checkcaller() then
							return oldindex(Self, Val)
						end
						if aimmethod["Value"] ~= "Mouse" then
							return oldindex(Self, Val)
						end
						local calling = getcallingscript() 
						if calling then
							local list = #aimignoredscripts["ObjectList"] > 0 and aimignoredscripts["ObjectList"] or {"ControlModule"}
							if table.find(list, tostring(calling)) then
								return oldindex(Self, Val)
							end
						end
						local plr
						if aimmode["Value"] == "Legit" then
							plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], aimvischeck["Enabled"], aimsmartab)
						else
							plr = GetNearestHumanoidToPosition(aimassisttarget["Players"]["Enabled"], aimfov["Value"], aimvischeck["Enabled"], aimsmartab)
						end
						if not plr then
							return oldindex(Self, Val)
						end
						local tar = (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimheadshotchance["Value"] and plr.Character.Head or plr.Character.HumanoidRootPart
						if tostring(Val) == "Hit" then
							return tar.CFrame
						elseif tostring(Val) == "Target" then
							return tar
						elseif tostring(Val) == "UnitRay" then
							local direction = CFrame.lookAt(Self.UnitRay.Origin, tar.Position).lookVector.Unit
							return Ray.new(Self.UnitRay.Origin, direction)
						end

						return oldindex(Self, Val)
					end)]]
				end
			--[[	BindToRenderStep("AimAssist", 1, function() 
					if entity.isAlive then
						local targettable = {}
						local targetsize = 0
						if plr and (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimhitchance["Value"] then
							targettable[plr.Player.Name] = {
								["UserId"] = plr.Player.UserId,
								["Health"] = plr.Character.Humanoid.Health,
								["MaxHealth"] = plr.Character.Humanoid.MaxHealth
							}
							targetsize = targetsize + 1
							if aimautofire["Enabled"] then
								if mouse1click and iswindowactive() and shoottime <= tick() and isNotHoveringOverGui() and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false and uis:GetFocusedTextBox() == nil then
									if pressed then
										mouse1release()
									else
										mouse1press()
									end
									pressed = not pressed
									shoottime = tick() + 0.01
								end
							end
							targetinfo.UpdateInfo(targettable, targetsize)
						else
							if pressed then
								mouse1release()
							end
							pressed = false
							tar = nil
							targetinfo.UpdateInfo({}, 0)
						end
					end
				end)]]
			else
			--	UnbindFromRenderStep("AimAssist") 
				tar = nil 
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
				aimfovframe.Visible = val == "Legit"
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
		end
	})
	aimfovframecolor = AimAssist.CreateColorSlider({
		["Name"] = "Circle Color",
		["Function"] = function(hue, sat, val)
			if aimfovframe then
				aimfovframe.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	aimfov = AimAssist.CreateSlider({
		["Name"] = "FOV", 
		["Min"] = 1, 
		["Max"] = 1000, 
		["Function"] = function(val) 
			if aimfovframe then
				aimfovframe.Size = UDim2.new(0, val, 0, val)
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
	aimfovshow = AimAssist.CreateToggle({
		["Name"] = "FOV Circle",
		["Function"] = function(callback) 
			if callback then
				aimfovframe = Instance.new("Frame")
				aimfovframe.BackgroundTransparency = 0.8
				aimfovframe.ZIndex = -1
				aimfovframe.Visible = aimmode["Value"] ~= "Blatant" and AimAssist["Enabled"]
				aimfovframe.BackgroundColor3 = Color3.fromHSV(aimfovframecolor["Hue"], aimfovframecolor["Sat"], aimfovframecolor["Value"])
				aimfovframe.Size = UDim2.new(0, aimfov["Value"], 0, aimfov["Value"])
				aimfovframe.AnchorPoint = Vector2.new(0.5, 0.5)
				aimfovframe.Position = UDim2.new(0.5, 0, 0.5, 0)
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
								plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], aimvischeck["Enabled"], aimsmartab)
							else
								plr = GetNearestHumanoidToPosition(aimassisttarget["Players"]["Enabled"], aimfov["Value"], aimvischeck["Enabled"], aimsmartab)
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
										shoottime = tick() + 0.01
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
	aimsmartignore = AimAssist.CreateToggle({
		["Name"] = "Smart Ignore",
		["Function"] = function(callback)
			if callback then
				for i,v in pairs(workspace:GetChildren()) do
					if v.Name:lower():find("junk") or v.Name:lower():find("trash") or v.Name:lower():find("ignore") then
						table.insert(aimsmartab, v)
					end
				end
			else
				table.clear(aimsmartab)
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
							if pressed and mousefunctions then
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
					if autoclickermode["Value"] == "Sword" then
						local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
						if tool and uis:IsMouseButtonPressed(0) then
							tool:Activate()
							autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]()) * Random.new().NextNumber(Random.new(), 0.75, 1)
						end
					else
						if mousefunctions then
							if (isrbxactive or iswindowactive)() and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false then
								mouse1click()
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
	["List"] = {"Sword", "RealClick"},
	["Function"] = function() end
})
autoclickercps = autoclicker.CreateTwoSlider({
	["Name"] = "CPS",
	["Min"] = 1,
	["Max"] = 20, 
	["Default"] = 8,
	["Default2"] = 12
})

local reachrange = {["Value"] = 1}
local oldsize = {}
local Reach = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Reach", 
	["Function"] = function(callback)
		if callback then
			RunLoops:BindToRenderStep("Reach", 1, function() 
				local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
				if tool and entity.isAlive then
					local touch = findTouchInterest(tool)
					if touch then
						local size = rawget(oldsize, tool.Name)
						if size then
							touch.Parent.Size = Vector3.new(size.X + reachrange["Value"], size.Y, size.Z + reachrange["Value"])
							touch.Parent.Massless = true
						else
							oldsize[tool.Name] = touch.Parent.Size
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("Reach")
			for i2,v2 in pairs(lplr.Character:GetChildren()) do
				if v2:IsA("Tool") and rawget(oldsize, v2.Name) then
					local touch = findTouchInterest(v2)
					if touch then
						touch.Parent.Size = rawget(oldsize, v2.Name)
						touch.Parent.Massless = false
					end
				end
			end
			for i2,v2 in pairs(lplr.Backpack:GetChildren()) do
				if v2:IsA("Tool") and rawget(oldsize, v2.Name) then
					local touch = findTouchInterest(v2)
					if touch then
						touch.Parent.Size = rawget(oldsize, v2.Name)
						touch.Parent.Massless = false
					end
				end
			end
			oldsize = {}
		end
	end
})
reachrange = Reach.CreateSlider({
	["Name"] = "Range", 
	["Min"] = 1,
	["Max"] = 20, 
	["Function"] = function(val) end,
})

runcode(function()
	local BlinkIncoming = {["Enabled"] = false}
	local Blink = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Blink", 
		["Function"] = function(callback) 
			if callback then
				game:GetService("NetworkClient"):SetOutgoingKBPSLimit(1)
				if BlinkIncoming["Enabled"] then 
					settings():GetService("NetworkSettings").IncomingReplicationLag = 99999999
				end
			else
				game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
				if BlinkIncoming["Enabled"] then 
					settings():GetService("NetworkSettings").IncomingReplicationLag = 0
				end
			end
		end, 
		["HoverText"] = "Chokes all incoming or outgoing packets"
	})
	BlinkIncoming = Blink.CreateToggle({
		["Name"] = "Incoming",
		["Function"] = function(callback)
			if callback then
				if Blink["Enabled"] then 
					settings():GetService("NetworkSettings").IncomingReplicationLag = 99999999
				end
			else
				if Blink["Enabled"] then 
					settings():GetService("NetworkSettings").IncomingReplicationLag = 0
				end
			end
		end
	})

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
					if ClickTPMethod["Value"] == "Normal" then
						entity.character.HumanoidRootPart.CFrame = CFrame.new(localmouse.Hit.p)
						ClickTP["ToggleButton"](false)
					else
						spawn(function()
							local selectedpos = localmouse.Hit.p
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
	local flywall = {["Enabled"] = false}
	local flyupanddown = {["Enabled"] = false}
	local flymethod = {["Value"] = "Normal"}
	local flymovemethod = {["Value"] = "MoveDirection"}
	local flykeys = {["Value"] = "Space/LeftControl"}
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
	local fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Fly", 
		["Function"] = function(callback)
			if callback then
				if entity.isAlive then
					flyposy = entity.character.HumanoidRootPart.CFrame.p.Y
					flyalivecheck = true
				end
				flypress = uis.InputBegan:connect(function(input1)
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
				flyendpress = uis.InputEnded:connect(function(input1)
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
				RunLoops:BindToHeartbeat("Fly", 1, function(delta) 
					if entity.isAlive then
						entity.character.Humanoid.PlatformStand = flyplatformstanding["Enabled"]
						if flyalivecheck == false then
							flyposy = entity.character.HumanoidRootPart.CFrame.p.Y
							flyalivecheck = true
						end
						local movevec = (flymovemethod["Value"] == "Manual" and (not (w or s or a or d)) and Vector3.new() or entity.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and movevec or Vector3.new()
						if flymethod["Value"] == "Normal" then
							if flyplatformstanding["Enabled"] then
								entity.character.HumanoidRootPart.CFrame = CFrame.new(entity.character.HumanoidRootPart.CFrame.p, entity.character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector)
								entity.character.HumanoidRootPart.RotVelocity = Vector3.new()
							end
							entity.character.HumanoidRootPart.Velocity = (movevec * flyspeed["Value"]) + Vector3.new(0, 0.85 + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0)
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
							if flymethod["Value"] ~= "Jump" then
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + flypos
								if flyplatformstanding["Enabled"] then
									entity.character.HumanoidRootPart.CFrame = CFrame.new(entity.character.HumanoidRootPart.CFrame.p, entity.character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector)
								end
								entity.character.HumanoidRootPart.Velocity = Vector3.new()
							else
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + Vector3.new(flypos.X, 0, flypos.Z)
								if entity.character.HumanoidRootPart.Velocity.Y < -(entity.character.Humanoid.JumpPower - ((flyup and flyverticalspeed["Value"] or 0) - (flydown and flyverticalspeed["Value"] or 0))) then
									flyjumpcf = entity.character.HumanoidRootPart.CFrame * CFrame.new(0, -entity.character.Humanoid.HipHeight, 0)
									entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							end
						end
						if flyplatform then
							flyplatform.CFrame = (flymethod["Value"] == "Jump" and flyjumpcf or entity.character.HumanoidRootPart.CFrame * CFrame.new(0, -entity.character.Humanoid.HipHeight * 2, 0))
							flyplatform.Velocity = Vector3.new()
							flyplatform.Parent = cam
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
					flyplatform:Remove()
					flyplatform = nil
				end
			end
		end,
		["ExtraText"] = function() return flymethod["Value"] end
	})
	flymethod = fly.CreateDropdown({
		["Name"] = "Mode", 
		["List"] = {"Normal", "CFrame", "Jump"},
		["Function"] = function(val)
			if entity.isAlive then
				flyposy = entity.character.HumanoidRootPart.CFrame.p.Y
			end
		end
	})
	flymovemethod = fly.CreateDropdown({
		["Name"] = "Movement", 
		["List"] = {"MoveDirection", "Manual"},
		["Function"] = function(val) end
	})
	flykeys = fly.CreateDropdown({
		["Name"] = "Keys", 
		["List"] = {"Space/LeftControl", "Space/LeftShift", "E/Q", "Space/Q"},
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
	flywall = fly.CreateToggle({
		["Name"] = "Wall Check",
		["Function"] = function() end,
		["Default"] = true
	})
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
					flyplatform:Remove()
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

local killauraaps = {["GetRandomValue"] = function() return 1 end}
local killaurarange = {["Value"] = 1}
local killauraangle = {["Value"] = 90}
local killauratarget = {["Value"] = 1}
local killauramouse = {["Enabled"] = false}
local killauratargetframe = {["Players"] = {["Enabled"] = false}}
local killauracframe = {["Enabled"] = false}
local Killaura = {["Enabled"] = false}
local killauratick = tick()
local killauranear = false
Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Killaura", 
	["Function"] = function(callback)
		if callback then
			RunLoops:BindToRenderStep("Killaura", 1, function() 
				killauranear = false
				if entity.isAlive then
					local tool = lplr.Character:FindFirstChildWhichIsA("Tool")
					local plr = GetAllNearestHumanoidToPosition(killauratargetframe["Players"]["Enabled"], killaurarange["Value"], 100)
					if tool and (killauramouse["Enabled"] and uis:IsMouseButtonPressed(0) or (not killauramouse["Enabled"])) then
						local touch = findTouchInterest(tool)
						if touch then
							local targettable = {}
							local targetsize = 0
							for i,v in pairs(plr) do
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
									if killauracframe["Enabled"] then
										entity.character.RootPart.CFrame = CFrame.new(entity.character.RootPart.Position, Vector3.new(v.RootPart.Position.X, entity.character.RootPart.Position.Y, v.RootPart.Position.Z))
									end
									if killauratick <= tick() then
										tool:Activate()
										killauratick = tick() + (1 / killauraaps["GetRandomValue"]())
									end
									firetouchinterest(touch.Parent, v.RootPart, 1)
									firetouchinterest(touch.Parent, v.RootPart, 0)
								end
							end
							targetinfo.UpdateInfo(targettable, targetsize)
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("Killaura")
			killauranear = false
		end
	end,
	["HoverText"] = "Attack players around you\nwithout aiming at them."
})
killauratargetframe = Killaura.CreateTargetWindow({})
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
	["Function"] = function(val) end
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
killauracframe = Killaura.CreateToggle({
	["Name"] = "Face target", 
	["Function"] = function() end
})

local longjumpboost = {["Value"] = 1}
local longjumpdisabler = {["Enabled"] = false}
local longjumpfall = false
local longjumpjump = {["Enabled"] = false}
local longjump = {["Enabled"] = false}
longjump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "LongJump", 
	["Function"] = function(callback)
		if callback then
			if longjumpjump then
				if entity.isAlive then
					entity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
			RunLoops:BindToRenderStep("LongJump", 1, function() 
				if entity.isAlive then
					if (entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall or entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping) and entity.character.Humanoid.MoveDirection ~= Vector3.new() then
						local velo = entity.character.Humanoid.MoveDirection * longjumpboost["Value"]
						entity.character.HumanoidRootPart.Velocity = Vector3.new(velo.X, entity.character.HumanoidRootPart.Velocity.Y, velo.Z)
					end
					if entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
						longjumpfall = true
					else
						if longjumpfall and longjumpdisabler["Enabled"] then
							longjumpfall = false
							longjump["ToggleButton"](true)
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("LongJump")
			longjumpfall = false
		end
	end
})
longjumpboost = longjump.CreateSlider({
	["Name"] = "Boost",
	["Min"] = 1,
	["Max"] = 150, 
	["Function"] = function(val) end
})
longjumpjump = longjump.CreateToggle({
	["Name"] = "Jump",
	["Function"] = function()
	end,
	["Default"] = true
})
longjumpdisabler = longjump.CreateToggle({
	["Name"] = "Auto Disable",
	["Function"] = function()
	end,
	["Default"] = true
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
	local speedwallcheck = {["Enabled"] = true}
	local speedjump = {["Enabled"] = false}
	local speedjumpheight = {["Value"] = 20}
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

	local speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed", 
		["Function"] = function(callback)
			if callback then
				speeddown = uis.InputBegan:connect(function(input1)
					if uis:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.W then
							w = true
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = true
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = true
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = true
						end
					end
				end)
				speedup = uis.InputEnded:connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.W then
						w = false
					end
					if input1.KeyCode == Enum.KeyCode.S then
						s = false
					end
					if input1.KeyCode == Enum.KeyCode.A then
						a = false
					end
					if input1.KeyCode == Enum.KeyCode.D then
						d = false
					end
				end)
				RunLoops:BindToHeartbeat("Speed", 1, function(delta)
					if entity.isAlive then
						local jumpcheck = killauranear and Killaura["Enabled"]
						local movevec = (speedmovemethod["Value"] == "Manual" and (not (w or s or a or d)) and Vector3.new() or entity.character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and movevec or Vector3.new()
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
									raycastparameters.RaycastFilterType = Enum.RaycastFilterType.Blacklist
									raycastparameters.FilterDescendantsInstances = {lplr.Character, cam}
									local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, newpos, raycastparameters)
									if ray then newpos = (ray.Position - entity.character.HumanoidRootPart.Position) end
								end
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + newpos
							end
						elseif speedmethod["Value"] == "WalkSpeed" then 
							if oldwalkspeed == nil then
								oldwalkspeed = entity.character.Humanoid.WalkSpeed
							end
							entity.character.Humanoid.WalkSpeed = speedval["Value"]
						end
						if speedjump["Enabled"] and (speedjumpalways["Enabled"] or jumpcheck) then
							if (entity.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entity.character.Humanoid.MoveDirection ~= Vector3.new() then
								entity.character.HumanoidRootPart.Velocity = Vector3.new(entity.character.HumanoidRootPart.Velocity.X, speedjumpheight["Value"], entity.character.HumanoidRootPart.Velocity.Z)
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
		["ExtraText"] = function() return speedmethod["Value"] end
	})
	speedmethod = speed.CreateDropdown({
		["Name"] = "Mode", 
		["List"] = {"Velocity", "CFrame", "TP", "WalkSpeed"},
		["Function"] = function(val)
			if oldwalkspeed then
				entity.character.Humanoid.WalkSpeed = oldwalkspeed
				oldwalkspeed = nil
			end
			speeddelay["Object"].Visible = val == "TP"
		end
	})
	speedmovemethod = speed.CreateDropdown({
		["Name"] = "Movement", 
		["List"] = {"MoveDirection", "Manual"},
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
		["Default"] = 7
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
	speedwallcheck = speed.CreateToggle({
		["Name"] = "Wall Check",
		["Function"] = function() end,
		["Default"] = true
	})
	speedjumpalways["Object"].BackgroundTransparency = 0
	speedjumpalways["Object"].BorderSizePixel = 0
	speedjumpalways["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	speedjumpalways["Object"].Visible = speedjump["Enabled"]
end)

runcode(function()
	local bodyspin
	local spinbotspeed = {["Value"] = 1}
	local spinbot = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SpinBot",
		["Function"] = function(callback)
			if callback then
				RunLoops:BindToRenderStep("SpinBot", 1, function()
					if entity.isAlive then
						if (bodyspin == nil or bodyspin ~= nil and bodyspin.Parent ~= entity.character.HumanoidRootPart) then
							bodyspin = Instance.new("BodyAngularVelocity")
							bodyspin.MaxTorque = Vector3.new(0, math.huge, 0)
							bodyspin.AngularVelocity = Vector3.new(0, spinbotspeed["Value"], 0)
							bodyspin.Parent = entity.character.HumanoidRootPart
						else
							bodyspin.AngularVelocity = Vector3.new(0, spinbotspeed["Value"], 0)
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
					if aliveplr and plr ~= lplr and (ArrowsTeammate["Enabled"] or shared.vapeteamcheck(plr)) then
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
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position)
									local rootSize = (aliveplr.RootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position + Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position - Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										--thing.Visible = rootVis
										local sizex, sizey = (rootSize / rootPos.Z), (headPos.Y - legPos.Y) 
										local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth)
											thing.Quad3.Color = color
											thing.Quad3.Visible = true
											thing.Quad4.From = floorpos(Vector2.new(posx - 4, posy + 1))
											thing.Quad4.To = floorpos(Vector2.new(posx - 4, posy + sizey - 1))
											thing.Quad4.Visible = true
											local healthposy = sizey * math.clamp(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth, 0, 1)
											thing.Quad3.From = floorpos(Vector2.new(posx - 4, posy + sizey - (sizey - healthposy)))
											thing.Quad3.To = floorpos(Vector2.new(posx - 4, posy))
											--thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
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
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
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
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position)
									local rootSize = (aliveplr.RootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position + Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position - Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									rootPos = rootPos
									if rootVis then
										if ESPHealthBar["Enabled"] then
											local color = HealthbarColorTransferFunction(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth)
											thing.HealthLineMain.BackgroundColor3 = color
											thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth, 0, 1), (math.clamp(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
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
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position)
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
								if aliveplr and plr ~= lplr and (ESPTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position)
									local rootSize = (aliveplr.RootPart.Size.X * 1200) * (cam.ViewportSize.X / 1920)
									local headPos, headVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position + Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
									local legPos, legVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position - Vector3.new(0, 1 + (rigcheck and 2 or aliveplr.Humanoid.HipHeight), 0))
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

runcode(function()
	local ChamsFolder = Instance.new("Folder")
	ChamsFolder.Name = "ChamsFolder"
	ChamsFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
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
						if aliveplr and plr ~= lplr and (ChamsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
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
			lightingconnection = lighting.Changed:connect(function()
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
							if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
								local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
								
								if headVis then
									local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
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
							if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
								local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
								headPos = headPos
								
								if headVis then
									local rawText = (NameTagsDistance["Enabled"] and entity.isAlive and "["..math.floor((entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(aliveplr.Humanoid.Health) or "")
									local color = HealthbarColorTransferFunction(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth)
									local modifiedText = (NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor((entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(aliveplr.Humanoid.Health).."</font>" or '')
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
			searchAdd = workspace.DescendantAdded:connect(function(v)
				if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList["ObjectList"], v.Name) and searchFindBoxHandle(v) == nil then
					local highlight = Instance.new("Highlight")
					highlight.Name = v.Name
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillColor = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
					highlight.Adornee = v
					highlight.Parent = searchFolder
				end
			end)
			searchRemove = workspace.DescendantRemoving:connect(function(v)
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
			XrayAdd = workspace.DescendantAdded:connect(function(v)
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
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
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
								
								local aliveplr = isAlive(plr)
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or shared.vapeteamcheck(plr)) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
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
				if lplr.PlayerGui:FindFirstChild("Chat") and lplr.PlayerGui.Chat:FindFirstChild("Frame") and lplr.PlayerGui.Chat.Frame:FindFirstChild("ChatChannelParentFrame") and game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
					if chatspammerhook == false then
						spawn(function()
							chatspammerhook = true
							for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
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
									game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer((#ChatSpammerMessages["ObjectList"] > 0 and ChatSpammerMessages["ObjectList"][math.random(1, #ChatSpammerMessages["ObjectList"])] or "vxpe on top"), "All")
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
						local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position + vec, Vector3.new(0, -1000, 0), raycastparameters)
						local ray2 = workspace:Raycast(entity.character.HumanoidRootPart.Position, Vector3.new(0, -entity.character.Humanoid.HipHeight * 2, 0), raycastparameters)
						if ray == nil and ray2 then
							vec = Vector3.new()
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
				vapecapeconnection = lplr.CharacterAdded:connect(function(char)
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
						entity.character.HumanoidRootPart.Velocity = ((entity.character.Humanoid.MoveDirection ~= Vector3.new() or uis:IsKeyDown(Enum.KeyCode.Space)) and entity.character.HumanoidRootPart.Velocity or Vector3.new())
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
end)


runcode(function()
	local Breadcrumbs = {["Enabled"] = false}
	local BreadcrumbsLifetime = {["Value"] = 20}
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
								breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.9, 0.5)
								breadcrumbattachment2 = Instance.new("Attachment")
								breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.9, 0.5)
								breadcrumbtrail = Instance.new("Trail")
								breadcrumbtrail.Attachment0 = breadcrumbattachment 
								breadcrumbtrail.Attachment1 = breadcrumbattachment2
								breadcrumbtrail.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0, 0, 1))
								breadcrumbtrail.FaceCamera = true
								breadcrumbtrail.Lifetime = BreadcrumbsLifetime["Value"] / 10
								breadcrumbtrail.Enabled = true
								breadcrumbtrail.Parent = cam
							else
								breadcrumbattachment.Parent = entity.character.HumanoidRootPart
								breadcrumbattachment2.Parent = entity.character.HumanoidRootPart
								breadcrumbtrail.Parent = cam
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
	BreadcrumbsLifetime = Breadcrumbs.CreateSlider({
		["Name"] = "Lifetime",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) end,
		["Default"] = 20
	})
end)

--[[runcode(function()
	local femboyconnection
	GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FemboyMode",
		["Function"] = function(callback)
			if callback then
				local desc = Instance.new("HumanoidDescription")
				local info = '{"SwimAnimation":1018554245,"JumpAnimation":754637084,"WalkAnimation":619512767,"RightLegColor":{"R":0.917647123336792,"B":0.572549045085907,"G":0.7215686440467835},"WidthScale":0.8799999952316284,"Face":236399287,"BodyTypeScale":0.6100000143051148,"RunAnimation":1018548665,"RightArmColor":{"R":0.917647123336792,"B":0.572549045085907,"G":0.7215686440467835},"ClimbAnimation":1018554668,"LeftArmColor":{"R":0.917647123336792,"B":0.572549045085907,"G":0.7215686440467835},"HeadColor":{"R":0.917647123336792,"B":0.572549045085907,"G":0.7215686440467835},"GraphicTShirt":0,"Torso":86499666,"HairAccessory":"8022084941","Head":86498113,"Shirt":0,"RightArm":86499698,"ProportionScale":0.12999999523162843,"RightLeg":27112068,"Pants":6474866173,"LeftLegColor":{"R":0.917647123336792,"B":0.572549045085907,"G":0.7215686440467835},"FallAnimation":754636589,"IdleAnimation":1018553897,"TorsoColor":{"R":0.917647123336792,"B":0.572549045085907,"G":0.7215686440467835},"DepthScale":0.9399999976158142,"LeftArm":86499716,"HeadScale":1,"HeightScale":1,"LeftLeg":27112056}'
				local info2 = '[{"IsLayered":true,"Order":1,"AssetId":9367213925,"AccessoryType":{"Parent":"AccessoryType","EnumVal":"Shirt"}},{"IsLayered":true,"Order":1,"AssetId":9342333632,"AccessoryType":{"Parent":"AccessoryType","EnumVal":"DressSkirt"}},{"IsLayered":true,"Order":1,"AssetId":9239535402,"AccessoryType":{"Parent":"AccessoryType","EnumVal":"Pants"}},{"AssetId":8022084941,"AccessoryType":{"Parent":"AccessoryType","EnumVal":"Hair"},"IsLayered":false}]'
				for i,v in pairs(game:GetService("HttpService"):JSONDecode(info)) do 
					desc[i] = type(v) == "table" and Color3.new(v.R, v.G, v.B) or v
				end
				local newdesc = {}
				for i,v in pairs(game:GetService("HttpService"):JSONDecode(info2)) do 
					local newtab = {}
					for i2,v2 in pairs(v) do 
						newtab[i2] = type(v2) == "table" and Enum[v2.Parent][v2.EnumVal] or v2
					end
					newdesc[i] = newtab
				end
				desc:SetAccessories(newdesc, true)
				if entity.isAlive then
					for i,v in pairs(lplr.Character:GetChildren()) do 
						if v:IsA("Shirt") or v:IsA("Pants") then 
							v:Remove()
						end
					end
					entity.character.Humanoid:ApplyDescriptionClientServer(desc)
				end
				femboyconnection = lplr.CharacterAdded:connect(function(char)
					local hum = char:WaitForChild("Humanoid")
					for i,v in pairs(char:GetChildren()) do 
						if v:IsA("Shirt") or v:IsA("Pants") then 
							v:Remove()
						end
					end
					char.Humanoid:ApplyDescriptionClientServer(desc)
				end)
			else
				if femboyconnection then
					femboyconnection:Disconnect()
				end
				if entity.isAlive then
					for i,v in pairs(lplr.Character:GetChildren()) do 
						if v:IsA("Shirt") or v:IsA("Pants") then 
							v:Remove()
						end
					end
					local lplrdesc = players:GetHumanoidDescriptionFromUserId(lplr.UserId)
					entity.character.Humanoid:ApplyDescriptionClientServer(lplrdesc)
				end
			end
		end,
		["HoverText"] = "femboy mode, will flag on all anticheats :troll: and remove most parts for everyone because fat roblox function"
	})
end)]]