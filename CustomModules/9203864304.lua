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

local function removeTags(str)
	str = str:gsub("<br%s*/>", "\n")
	return (str:gsub("<[^<>]->", ""))
end

local function run(func) func() end

local function isFriend(plr, recolor)
	if GuiLibrary.ObjectsThatCanBeSaved["Use FriendsToggle"].Api.Enabled then
		local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectList, plr.Name)
		friend = friend and GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectListEnabled[friend]
		if recolor then
			friend = friend and GuiLibrary.ObjectsThatCanBeSaved["Recolor visualsToggle"].Api.Enabled
		end
		return friend
	end
	return nil
end

local function isTarget(plr)
	local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectList, plr.Name)
	friend = friend and GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectListEnabled[friend]
	return friend
end

local function isVulnerable(plr)
	return plr.Humanoid.Health > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
end

local function getPlayerColor(plr)
	if isFriend(plr, true) then
		return Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Value)
	end
	return tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color
end

local whitelist = {data = {WhitelistedUsers = {}}, hashes = {}, said = {}, alreadychecked = {}, customtags = {}, loaded = false, localprio = 0, hooked = false, get = function() return 0, true end}
local entityLibrary = loadstring(vapeGithubRequest("Libraries/entityHandler.lua"))()
shared.vapeentity = entityLibrary
do
	entityLibrary.selfDestruct()
	table.insert(vapeConnections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendRefresh.Event:Connect(function()
		entityLibrary.fullEntityRefresh()
	end))
	table.insert(vapeConnections, GuiLibrary.ObjectsThatCanBeSaved["Teams by colorToggle"].Api.Refresh.Event:Connect(function()
		entityLibrary.fullEntityRefresh()
	end))
	local oldUpdateBehavior = entityLibrary.getUpdateConnections
	entityLibrary.getUpdateConnections = function(newEntity)
		local oldUpdateConnections = oldUpdateBehavior(newEntity)
		table.insert(oldUpdateConnections, {Connect = function()
			newEntity.Friend = isFriend(newEntity.Player) and true
			newEntity.Target = isTarget(newEntity.Player) and true
			return {Disconnect = function() end}
		end})
		return oldUpdateConnections
	end
	entityLibrary.isPlayerTargetable = function(plr)
		if isFriend(plr) then return false end
		if not ({whitelist:get(plr)})[2] then return false end
		if (not GuiLibrary.ObjectsThatCanBeSaved["Teams by colorToggle"].Api.Enabled) then return true end
		if (not lplr.Team) then return true end
		if (not plr.Team) then return true end
		if plr.Team ~= lplr.Team then return true end
        return #plr.Team:GetPlayers() == playersService.NumPlayers
	end
	entityLibrary.fullEntityRefresh()
	entityLibrary.LocalPosition = Vector3.zero

	task.spawn(function()
		local postable = {}
		repeat
			task.wait()
			if entityLibrary.isAlive then
				table.insert(postable, {Time = tick(), Position = entityLibrary.character.HumanoidRootPart.Position})
				if #postable > 100 then
					table.remove(postable, 1)
				end
				local closestmag = 9e9
				local closestpos = entityLibrary.character.HumanoidRootPart.Position
				local currenttime = tick()
				for i, v in pairs(postable) do
					local mag = 0.1 - (currenttime - v.Time)
					if mag < closestmag and mag > 0 then
						closestmag = mag
						closestpos = v.Position
					end
				end
				entityLibrary.LocalPosition = closestpos
			end
		until not vapeInjected
	end)
end

local function calculateMoveVector(cameraRelativeMoveVector)
	local c, s
	local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = gameCamera.CFrame:GetComponents()
	if R12 < 1 and R12 > -1 then
		c = R22
		s = R02
	else
		c = R00
		s = -R01*math.sign(R12)
	end
	local norm = math.sqrt(c*c + s*s)
	return Vector3.new(
		(c*cameraRelativeMoveVector.X + s*cameraRelativeMoveVector.Z)/norm,
		0,
		(c*cameraRelativeMoveVector.Z - s*cameraRelativeMoveVector.X)/norm
	)
end

local raycastWallProperties = RaycastParams.new()
local function raycastWallCheck(char, checktable)
	if not checktable.IgnoreObject then
		checktable.IgnoreObject = raycastWallProperties
		local filter = {lplr.Character, gameCamera}
		for i,v in pairs(entityLibrary.entityList) do
			if v.Targetable then
				table.insert(filter, v.Character)
			end
		end
		for i,v in pairs(checktable.IgnoreTable or {}) do
			table.insert(filter, v)
		end
		raycastWallProperties.FilterDescendantsInstances = filter
	end
	local ray = workspace.Raycast(workspace, checktable.Origin, (char[checktable.AimPart].Position - checktable.Origin), checktable.IgnoreObject)
	return not ray
end

local function EntityNearPosition(distance, checktab)
	checktab = checktab or {}
	if entityLibrary.isAlive then
		local sortedentities = {}
		for i, v in pairs(entityLibrary.entityList) do -- loop through playersService
			if not v.Targetable then continue end
            if isVulnerable(v) then -- checks
				local playerPosition = v.RootPart.Position
				local mag = (entityLibrary.character.HumanoidRootPart.Position - playerPosition).magnitude
				if checktab.Prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - playerPosition).magnitude
				end
                if mag <= distance then -- mag check
					table.insert(sortedentities, {entity = v, Magnitude = v.Target and -1 or mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i, v in pairs(sortedentities) do
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			return v.entity
		end
	end
end

local function EntityNearMouse(distance, checktab)
	checktab = checktab or {}
    if entityLibrary.isAlive then
		local sortedentities = {}
		local mousepos = inputService.GetMouseLocation(inputService)
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local vec, vis = worldtoscreenpoint(v[checktab.AimPart].Position)
				local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
                if vis and mag <= distance then
					table.insert(sortedentities, {entity = v, Magnitude = v.Target and -1 or mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i, v in pairs(sortedentities) do
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			return v.entity
		end
    end
end

local function AllNearPosition(distance, amount, checktab)
	local returnedplayer = {}
	local currentamount = 0
	checktab = checktab or {}
    if entityLibrary.isAlive then
		local sortedentities = {}
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local playerPosition = v.RootPart.Position
				local mag = (entityLibrary.character.HumanoidRootPart.Position - playerPosition).magnitude
				if checktab.Prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - playerPosition).magnitude
				end
                if mag <= distance then
					table.insert(sortedentities, {entity = v, Magnitude = mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i,v in pairs(sortedentities) do
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			table.insert(returnedplayer, v.entity)
			currentamount = currentamount + 1
			if currentamount >= amount then break end
		end
	end
	return returnedplayer
end

run(function() 
    local AutoClickCar = {Enabled = false}
    local Delay = {Value = 0.01}

    AutoClickCar = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton({
        Name = "AutoClickCar",
        Function = function(callback) 
            repeat task.wait(Delay.Value or 0.01)
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